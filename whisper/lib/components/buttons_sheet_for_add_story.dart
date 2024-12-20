import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:whisper/constants/colors.dart';
import 'package:whisper/global_cubits/global_user_story_cubit_provider.dart';
import 'package:whisper/keys/file_button_sheet_add_story_keys.dart';
import 'package:whisper/pages/selected_image_captioning.dart';
import 'package:whisper/components/icon_creation_widget.dart';
import 'package:whisper/services/upload_file.dart';

class ImagePickerButtonSheetForStory extends StatelessWidget {
  const ImagePickerButtonSheetForStory({super.key});

  void _pickImageFromCamera(BuildContext context) async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      String fileExtension = path.extension(image.path).toLowerCase();
      if (_isValidImage(fileExtension)) {
        Navigator.of(context).pop();
        List<String> imagePaths = [image.path];
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Selected file is not a valid image.")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Camera image selection canceled")),
      );
    }
  }

  void _pickImageFromGallery(BuildContext context) async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      String fileExtension = path.extension(image.path).toLowerCase();
      if (_isValidImage(fileExtension)) {
        Navigator.of(context).pop();
        List<String> imagePaths = [image.path];
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Selected file is not a valid image.")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gallery image selection canceled")),
      );
    }
  }

  bool _isValidImage(String extension) {
    const validExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp'];
    return validExtensions.contains(extension);
  }

  Future<void> _sendFile(String filePath, String content, String type) async {
    try {
      String uploadResult = await uploadFile(filePath);
      GlobalUserStoryCubitProvider.userStoryCubit
          .sendStory(content, uploadResult, type);
      if (uploadResult != 'Failed') {
        print("File uploaded successfully: $uploadResult");
      } else {
        print("Failed to upload file: $filePath");
      }
    } catch (e) {
      print("Error in _sendFile: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 5,
      width: MediaQuery.of(context).size.width,
      child: Card(
        color: firstSecondaryColor,
        margin: const EdgeInsets.all(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconCreationWidget(
                key: FileButtonSheetAddStoryKeys.cameraIcon,
                textStyle: TextStyle(),
                icon: Icons.camera_alt,
                text: "Camera",
                color: Colors.pink,
                onTap: () => _pickImageFromCamera(context),
              ),
              IconCreationWidget(
                key: FileButtonSheetAddStoryKeys.galleryIcon,
                textStyle: TextStyle(),
                icon: Icons.photo,
                text: "Gallery",
                color: Colors.purple,
                onTap: () => _pickImageFromGallery(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
