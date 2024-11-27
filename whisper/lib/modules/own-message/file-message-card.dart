import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/modules/own-message/own-message.dart';
import 'package:whisper/services/read-file.dart';
import 'package:whisper/services/shared-preferences.dart'; // Import for GetToken
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class FileMessageCard extends OwnMessage {
  final String blobName;

  FileMessageCard({
    required this.blobName,
    required String message,
    required DateTime time,
    required bool isSelected,
    required MessageStatus status,
    Key? key,
  }) : super(
          message: message,
          time: time,
          isSelected: isSelected,
          status: status,
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return _FileMessageCardStateful(
      blobName: blobName,
      message: message,
      time: formatTime(time),
      isSelected: isSelected,
      status: status,
    );
  }
}

class _FileMessageCardStateful extends StatefulWidget {
  final String blobName;
  final String message;
  final String time;
  final bool isSelected;
  final MessageStatus status;

  const _FileMessageCardStateful({
    required this.blobName,
    required this.message,
    required this.time,
    required this.isSelected,
    required this.status,
    Key? key,
  }) : super(key: key);

  @override
  State<_FileMessageCardStateful> createState() => _FileMessageCardState();
}

class _FileMessageCardState extends State<_FileMessageCardStateful> {
  final Dio dio = Dio();
  bool isDownloading = false;
  bool fileExists = false;

  @override
  void initState() {
    super.initState();
    _checkFileExistence(widget.blobName);
  }

  Future<void> _checkFileExistence(String fileName) async {
    Directory? baseDir = await getExternalStorageDirectory();
    String filePath = "${baseDir!.path}/$fileName";
    setState(() {
      setisexisting(File(filePath).existsSync());
    });
  }

  void setisdownloading(bool value) {
    setState(() {
      isDownloading = value;
    });
  }

  void setisexisting(bool value) {
    setState(() {
      fileExists = value;
    });
  }

  Future<void> _downloadFile(String fileUrl, String fileName) async {
    print(fileUrl);
    setisdownloading(true);

    try {
      Directory? baseDir = await getExternalStorageDirectory();
      // Build the Whisper folder path
      String whisperFolderPath = baseDir!.path;
      Directory whisperFolder = Directory(whisperFolderPath);

      // Ensure the Whisper folder exists
      if (!await whisperFolder.exists()) {
        await whisperFolder.create(recursive: true);
      }

      // Extract the file name and extension from the URL
      String fileNameWithParams =
          fileUrl.split('/').last; // Full name with query params
      String fileName =
          fileNameWithParams.split('?').first; // Remove query params
      if (!fileName.contains('.')) {
        throw Exception("File name does not contain an extension.");
      }

      String filePath = "$whisperFolderPath/$fileName";

      File file = File(filePath);

      if (!file.existsSync()) {
        print("Downloading file...");
        await dio.download(fileUrl, filePath);
        print("File downloaded: $filePath");
      } else {
        print("File already exists: $filePath");
      }
      setisexisting(true);
    } catch (e) {
      print("Error downloading file: $e");
    } finally {
      setisdownloading(false);
    }
  }

  Future<void> _openFile(String fileName) async {
    try {
      Directory? baseDir = await getExternalStorageDirectory();
      String filePath = "${baseDir!.path}/$fileName";

      final result = await OpenFile.open(filePath);

      if (result.type != ResultType.done) {
        print("Failed to open the file. Error: ${result.message}");
      }
    } catch (e) {
      print("Error opening file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: widget.isSelected ? selectColor : Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              child: Card(
                color: const Color(0xFF8D6AEE),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.filePdf,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.blobName,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'File',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.time,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white70),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            widget.status == MessageStatus.seen
                                ? FontAwesomeIcons.checkDouble
                                : widget.status == MessageStatus.received
                                    ? FontAwesomeIcons.check
                                    : FontAwesomeIcons.clock,
                            color: widget.status == MessageStatus.seen
                                ? Colors.blue
                                : Colors.white,
                            size: 14,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () async {
                          if (fileExists) {
                            await _openFile(widget.blobName);
                          } else {
                            String fileUrl =
                                await generatePresignedUrl(widget.blobName);
                            await _downloadFile(fileUrl, widget.blobName);
                          }
                        },
                        child: isDownloading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Text(
                                fileExists ? "Open File" : "Download File",
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
