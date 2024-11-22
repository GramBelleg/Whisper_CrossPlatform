import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whisper/components/icon-creation.dart';
import 'dart:io';
import 'dart:typed_data';

import 'package:whisper/services/upload-file.dart';

class FileButtonSheet extends StatelessWidget {
  final ImagePicker _picker = ImagePicker();
  FileButtonSheet({
    Key? key,
  }) : super(key: key);

  void _pickAudio() async {
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

  void _pickFile() async {
    // Use FilePicker to pick a file
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      // Get the selected file
      String? filePath = result.files.single.path;
      String? fileName = result.files.single.name;

      if (filePath != null) {
        File selectedFile = File(filePath);

        // Extract file extension
        String? fileExtension = fileName?.split('.').last;
        print("File extension: $fileExtension");

        // You can now use fileBytes as a Blob
        print("File selected: $fileName at $filePath");

        // Example: Call a function to send/display the file
        _sendFile(fileName, fileExtension!, filePath);
      }
    } else {
      // User canceled the picker
      print("File selection canceled");
    }
  }

// Example function to handle sending the file as a blob
  void _sendFile(String? fileName, String fileExtension, String filePath) {
    // Here you would handle the file blob (e.g., send it to a server)
    print("Sending file: $fileName ");
    uploadFile(filePath, fileExtension);
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
