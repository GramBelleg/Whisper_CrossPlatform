import 'package:flutter/material.dart';
import 'package:whisper/components/icon-creation.dart';

class FileButtonSheet extends StatelessWidget {
  final VoidCallback onDocumentTap;
  final VoidCallback onCameraTap;
  final VoidCallback onGalleryTap;
  final VoidCallback onAudioTap;
  final VoidCallback onLocationTap;
  final VoidCallback onContactsTap;

  const FileButtonSheet({
    Key? key,
    required this.onDocumentTap,
    required this.onCameraTap,
    required this.onGalleryTap,
    required this.onAudioTap,
    required this.onLocationTap,
    required this.onContactsTap,
  }) : super(key: key);

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
                      onTap: onDocumentTap),
                  Spacer(flex: 1),
                  IconCreationWidget(
                      icon: Icons.camera_alt,
                      text: "Camera",
                      color: Colors.pink,
                      onTap: onCameraTap),
                  Spacer(flex: 1),
                  IconCreationWidget(
                      icon: Icons.insert_photo,
                      text: "Gallery",
                      color: Colors.purple,
                      onTap: onGalleryTap),
                ],
              ),
              Spacer(flex: 1),
              Row(
                children: [
                  IconCreationWidget(
                      icon: Icons.headset,
                      text: "Audio",
                      color: Colors.orange,
                      onTap: onAudioTap),
                  Spacer(flex: 1),
                  IconCreationWidget(
                      icon: Icons.location_pin,
                      text: "Location",
                      color: Colors.teal,
                      onTap: onLocationTap),
                  Spacer(flex: 1),
                  IconCreationWidget(
                      icon: Icons.person,
                      text: "Contacts",
                      color: Colors.blue,
                      onTap: onContactsTap),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
