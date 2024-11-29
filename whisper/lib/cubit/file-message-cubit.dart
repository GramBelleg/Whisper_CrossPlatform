import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:whisper/cubit/file-message-states.dart';
import 'package:whisper/services/read-file.dart';

class FileMessageCubit extends Cubit<FileMessageState> {
  final Dio dio;

  FileMessageCubit({required this.dio}) : super(FileMessageInitial());

  Future<void> checkFileExistence(String fileName, bool fileExists) async {
    try {
      if (fileExists)
        emit(FileMessageChecked(fileExists: fileExists));
      else {
        emit(FileMessageLoading());
        Directory? baseDir = await getExternalStorageDirectory();
        String filePath = "${baseDir!.path}/$fileName";
        fileExists = File(filePath).existsSync();
        if (fileExists) {
          emit(FileMessageChecked(fileExists: fileExists));
        } else {
          // After checking file existence, calculate the size and decide if we need to download
          String fileUrl = await generatePresignedUrl(
              fileName); // Assuming you have this function.
          await checkAndDownloadFile(fileUrl, fileName);
        }
      }
    } catch (e) {
      emit(FileMessageError(message: "Failed to check file existence: $e"));
    }
  }

  Future<void> checkAndDownloadFile(String fileUrl, String fileName) async {
    try {
      int fileSize = await calculateFileSize(fileUrl);

      if (fileSize < 10 * 1024 * 1024) {
        // Size less than 10 MB
        await downloadFile(fileUrl, fileName);
      } else {
        emit(FileMessageError(message: "File is too large to download."));
      }
    } catch (e) {
      emit(FileMessageError(message: "Failed to check and download file: $e"));
    }
  }

  Future<int> calculateFileSize(String fileUrl) async {
    try {
      Response response = await dio.head(fileUrl);
      int contentLength =
          int.parse(response.headers.value('content-length') ?? '0');
      return contentLength;
    } catch (e) {
      throw Exception("Failed to calculate file size: $e");
    }
  }

  Future<void> downloadFile(String fileUrl, String fileName) async {
    try {
      emit(FileMessageDownloading());

      Directory? baseDir = await getExternalStorageDirectory();
      String whisperFolderPath = baseDir!.path;
      Directory whisperFolder = Directory(whisperFolderPath);

      if (!await whisperFolder.exists()) {
        await whisperFolder.create(recursive: true);
      }

      String fileNameWithParams = fileUrl.split('/').last;
      String fileName = fileNameWithParams.split('?').first;
      if (!fileName.contains('.')) {
        throw Exception("File name does not contain an extension.");
      }
      String filePath = "$whisperFolderPath/$fileName";

      final file = File(filePath);
      if (!file.existsSync()) {
        await dio.download(fileUrl, filePath);
      }

      emit(FileMessageDownloaded(filePath: filePath));
    } catch (e) {
      emit(FileMessageError(message: "Failed to download file: $e"));
    }
  }

  Future<void> openFile(String fileName) async {
    try {
      Directory? baseDir = await getExternalStorageDirectory();
      String filePath = "${baseDir!.path}/$fileName";
      final result = await OpenFile.open(filePath);

      if (result.type != ResultType.done) {
        emit(FileMessageError(
            message: "Failed to open file: ${result.message}"));
      } else {
        emit(FileMessageOpened());
      }
    } catch (e) {
      emit(FileMessageError(message: "Failed to open file: $e"));
    }
  }
}
