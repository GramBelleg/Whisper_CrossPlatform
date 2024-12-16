import 'dart:io'; // Import the File class
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whisper/global_cubits/global_chats_cubit.dart';
import 'package:whisper/models/contact.dart';
import 'package:whisper/services/upload_file.dart';

class CreateGroupOrChannelDialog extends StatefulWidget {
  final String type;
  final VoidCallback onCreate;
  final Set<Contact> contacts;
  const CreateGroupOrChannelDialog({
    super.key,
    required this.type,
    required this.onCreate,
    required this.contacts,
  });

  @override
  _CreateGroupOrChannelDialogState createState() =>
      _CreateGroupOrChannelDialogState();
}

class _CreateGroupOrChannelDialogState
    extends State<CreateGroupOrChannelDialog> {
  final TextEditingController groupNameController = TextEditingController();
  final TextEditingController channelNameController = TextEditingController();
  XFile? selectedImage;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Create ${widget.type}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image Picker
          GestureDetector(
            onTap: () async {
              final ImagePicker picker = ImagePicker();
              final XFile? image =
                  await picker.pickImage(source: ImageSource.camera);
              if (image != null) {
                setState(() {
                  selectedImage = image; // Update the selectedImage
                });
              }
            },
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[300],
              backgroundImage: selectedImage != null
                  ? FileImage(
                      File(selectedImage!.path)) // Display the selected image
                  : null,
              child: selectedImage == null
                  ? Icon(Icons.camera_alt, color: Colors.grey[600])
                  : null,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: widget.type == 'Group'
                ? groupNameController
                : channelNameController,
            decoration: InputDecoration(
              labelText: 'Enter ${widget.type} Name',
              hintText: 'Enter the name of the ${widget.type}',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            String uploadResult = '';
            if (selectedImage != null) {
              uploadResult = await uploadFile(selectedImage!.path);
            }
            if (widget.type == 'Group' && uploadResult != 'Failed') {
              // Handle group creation logic
              print(
                  "create ${widget.type} by ${widget.contacts.map((contact) => contact.userName).join('-')}");
              GlobalChatsCubitProvider.chatListCubit.createChat(
                  "GROUP",
                  groupNameController.text.isNotEmpty
                      ? groupNameController.text
                      : widget.contacts
                          .map((contact) => contact.userName)
                          .join('-'),
                  uploadResult == '' ? null : uploadResult,
                  null,
                  widget.contacts.map((contact) => contact.userId).toList());
            } else if (widget.type == 'Channel' && uploadResult != 'Failed') {
              // Handle channel creation logic
              GlobalChatsCubitProvider.chatListCubit.createChat(
                  "CHANNEL",
                  channelNameController.text.isNotEmpty
                      ? groupNameController.text
                      : widget.contacts
                          .map((contact) => contact.userName)
                          .join('-'),
                  uploadResult == '' ? null : uploadResult,
                  null,
                  widget.contacts.map((contact) => contact.userId).toList());
            }

            widget.onCreate();
            Navigator.pop(context); // Close the dialog
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}
