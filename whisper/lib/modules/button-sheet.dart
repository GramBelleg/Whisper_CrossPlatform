import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whisper/components/icon-creation.dart';
import 'package:whisper/components/message.dart';
import 'package:whisper/cubit/messages-cubit.dart';
import 'package:whisper/global-cubit-provider.dart';
import 'package:whisper/models/parent-message.dart';
import 'package:whisper/pages/selected-images-captioning.dart';
import 'dart:io';
import 'dart:typed_data';

import 'package:whisper/services/upload-file.dart';

class FileButtonSheet extends StatelessWidget {
  // final ImagePicker _picker = ImagePicker();
  final int chatId;
  final int senderId;
  final String senderName;
  final ParentMessage? parentMessage;
  final bool isReplying;
  final bool isForward;
  final int? forwardedFromUserId;
  final VoidCallback handleOncancelReply;
  BuildContext context;

  FileButtonSheet({
    Key? key,
    required this.chatId,
    required this.senderId,
    required this.senderName,
    this.parentMessage,
    this.isReplying = false,
    this.isForward = false,
    this.forwardedFromUserId,
    required this.context,
    required this.handleOncancelReply,
  }) : super(key: key);

  void _pickAudio(BuildContext context) async {
    // Use FilePicker to pick an audio file
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (result != null) {
      // Get the selected audio file
      String? filePath = result.files.single.path;
      String? fileName = result.files.single.name;

      // You can now send the audio file or show a message with the file name
      print("Audio selected: $fileName at $filePath");

      // Add logic to send the audio or display it in the chat
      // For example:
      // _sendAudio(filePath);
    } else {
      // User canceled the picker
      print("Audio selection canceled");
    }
  }

  Future<FilePickerResult?> filterFilesLessThan50MB(
      FilePickerResult? result, List<String> rejectedFiles) async {
    if (result == null) {
      return null;
    }

    const int maxSizeInBytes = 20 * 1024 * 1024;
    List<PlatformFile> filteredFiles = result.files.where((file) {
      if (file.size < maxSizeInBytes) {
        return true;
      } else if (file.path != null) {
        final fileInfo = File(file.path!);
        if (fileInfo.lengthSync() < maxSizeInBytes) {
          return true;
        }
      }
      rejectedFiles.add(file.name);
      return false;
    }).toList();

    if (filteredFiles.isEmpty) {
      return null;
    }

    return FilePickerResult(filteredFiles);
  }

  void _pickFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    handleOncancelReply();
    handlePickFile(result);
  }

  Future<void> _sendFile(String filePath, String content, String type) async {
    try {
      String uploadResult = await uploadFile(filePath);

      if (uploadResult != 'Failed') {
        print("File uploaded successfullyy: $uploadResult");
        GlobalCubitProvider.messagesCubit.sendMessage(
            content: content,
            chatId: chatId,
            senderId: senderId,
            senderName: senderName,
            parentMessage: parentMessage,
            isReplying: isReplying,
            isForward: isForward,
            forwardedFromUserId: forwardedFromUserId,
            media: uploadResult,
            type: type,
            extension: filePath.split('.').last);
      } else {
        print("Failed to upload file: $filePath");
      }
    } catch (e) {
      print("Error in _sendFile: $e");
    }
  }

  void _pickImageFromCamera() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.camera);
    handleOncancelReply();
    if (image != null) {
      print("Image captured: ${image.name} at ${image.path}");
      Navigator.of(context).pop();
      String? imagePath = image.path;
      List<String> imagePaths = [];

      if (imagePath != null) {
        print("File selected: ${image.name} at $imagePath");
        // await _sendFile(filePath, image.name);
        imagePaths.add(imagePath);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SelectedImageCaptioning(
              mediaPaths: imagePaths,
              sendFile: _sendFile, // Pass the sendFile function
            ),
          ),
        );
      } else {
        print("File path is null for ${image.name}");
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("camera image selection canceled"),
        ),
      );
    }
  }

  void _pickImageFromGallery() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4', 'mov', 'avi'],
    );
    handleOncancelReply();
    List<String> rejectedFiles = [];
    result = await filterFilesLessThan50MB(result, rejectedFiles);
    if (result != null) {
      if (rejectedFiles.isNotEmpty) {
        print(
            "The following files were too large and skipped: ${rejectedFiles.join(', ')}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "The following files were too large and skipped: ${rejectedFiles.join(', ')}"),
          ),
        );
      }
      Navigator.of(context).pop();
      List<String> imagePaths = [];
      imagePaths = result.files
          .map((file) => file.path)
          .where((path) => path != null)
          .cast<String>()
          .toList();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SelectedImageCaptioning(
            mediaPaths: imagePaths,
            sendFile: _sendFile, // Pass the sendFile function
          ),
        ),
      );
    } else if (result == null && rejectedFiles.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "The following files were too large and skipped: ${rejectedFiles.join(', ')}"),
        ),
      );
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("File selection canceled"),
        ),
      );
      Navigator.of(context).pop();
      print("File selection canceled");
    }
  }

  void handlePickFile(FilePickerResult? result) async {
    List<String> rejectedFiles = [];
    result = await filterFilesLessThan50MB(result, rejectedFiles);
    if (result != null) {
      if (rejectedFiles.isNotEmpty) {
        print(
            "The following files were too large and skipped: ${rejectedFiles.join(', ')}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "The following files were too large and skipped: ${rejectedFiles.join(', ')}"),
          ),
        );
      }
      Navigator.of(context).pop();
      for (PlatformFile file in result.files) {
        String? filePath = file.path;

        if (filePath != null) {
          print("File selected: ${file.name} at $filePath");
          await _sendFile(filePath, file.name, "DOC");
        } else {
          print("File path is null for ${file.name}");
        }
      }
    } else if (result == null && rejectedFiles.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "The following files were too large and skipped: ${rejectedFiles.join(', ')}"),
        ),
      );
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("File selection canceled"),
        ),
      );
      Navigator.of(context).pop();
      print("File selection canceled");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: const EdgeInsets.all(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
          child: Column(
            children: [
              Row(
                children: [
                  IconCreationWidget(
                      icon: Icons.insert_drive_file,
                      text: "Document",
                      color: Colors.indigo,
                      onTap: _pickFile),
                  Spacer(flex: 1),
                  IconCreationWidget(
                      icon: Icons.camera_alt,
                      text: "Camera",
                      color: Colors.pink,
                      onTap: _pickImageFromCamera),
                  Spacer(flex: 1),
                  IconCreationWidget(
                      icon: Icons.insert_photo,
                      text: "Gallery",
                      color: Colors.purple,
                      onTap: _pickImageFromGallery),
                ],
              ),
              Spacer(flex: 1),
              Row(
                children: [
                  IconCreationWidget(
                      icon: Icons.headset,
                      text: "Audio",
                      color: Colors.orange,
                      onTap: _pickAudio),
                  Spacer(flex: 1),
                  IconCreationWidget(
                      icon: Icons.location_pin,
                      text: "Location",
                      color: Colors.teal,
                      onTap: () {}),
                  Spacer(flex: 1),
                  IconCreationWidget(
                      icon: Icons.person,
                      text: "Contacts",
                      color: Colors.blue,
                      onTap: () {}),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
