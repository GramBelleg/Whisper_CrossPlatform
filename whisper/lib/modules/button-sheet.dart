import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whisper/components/icon-creation.dart';
import 'package:whisper/components/message.dart';
import 'package:whisper/cubit/messages-cubit.dart';
import 'package:whisper/global-cubit-provider.dart';
import 'package:whisper/models/parent-message.dart';
import 'dart:io';
import 'dart:typed_data';

import 'package:whisper/services/upload-file.dart';

class FileButtonSheet extends StatelessWidget {
  final ImagePicker _picker = ImagePicker();
  final int chatId;
  final int senderId;
  final String senderName;
  final ParentMessage? parentMessage;
  final bool isReplying;
  final bool isForward;
  final int? forwardedFromUserId;
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
      FilePickerResult? result) async {
    if (result == null) {
      return null;
    }

    const int maxSizeInBytes = 50 * 1024 * 1024; // 50 MB

    // Filter files less than 50 MB
    List<PlatformFile> filteredFiles = result.files.where((file) {
      if (file.size < maxSizeInBytes) {
        return true;
      } else if (file.path != null) {
        // Check size if the file has a path
        final fileInfo = File(file.path!);
        return fileInfo.lengthSync() < maxSizeInBytes;
      }
      return false;
    }).toList();

    if (filteredFiles.isEmpty) {
      return null; // Return null if no files meet the criteria
    }

    return FilePickerResult(filteredFiles);
  }

  void _pickFile() async {
    // Use FilePicker to pick multiple files
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    result = await filterFilesLessThan50MB(result);
    if (result != null) {
      // Iterate through the selected files
      Navigator.of(context).pop();
      for (PlatformFile file in result.files) {
        String? filePath = file.path;

        if (filePath != null) {
          print("File selected: ${file.name} at $filePath");
          // Delegate upload responsibility to the generic _sendFile function
          await _sendFile(filePath);
        } else {
          print("File path is null for ${file.name}");
        }
      }
    } else {
      // User canceled the picker'
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("File selection canceled"),
        ),
      );
      print("File selection canceled");
    }
  }

// Example function to handle sending the file as a blob
  Future<void> _sendFile(String filePath) async {
    try {
      // Call the uploadFile function with the selected file path
      String uploadResult = await uploadFile(filePath);

      if (uploadResult != 'Failed') {
        print("File uploaded successfullyy: $uploadResult");
        GlobalCubitProvider.messagesCubit.sendMessage(
          content: "$uploadResult",
          chatId: chatId,
          senderId: senderId,
          senderName: senderName,
          parentMessage: parentMessage,
          isReplying: isReplying,
          isForward: isForward,
          forwardedFromUserId: forwardedFromUserId,
          media: uploadResult,
        );
      } else {
        print("Failed to upload file: $filePath");
      }
    } catch (e) {
      print("Error in _sendFile: $e");
    }
  }

  void _pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      // You can now send the captured image or show a message with the file name
      print("Image captured: ${image.name} at ${image.path}");

      // For example, you can send the image in the chat
      // _sendImage(image.path);
    } else {
      print("Camera image selection canceled");
    }
  }

  void _pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // You can now send the selected image or show a message with the file name
      print("Image selected: ${image.name} at ${image.path}");

      // For example, you can send the image in the chat
      // _sendImage(image.path);
    } else {
      print("Gallery image selection canceled");
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
