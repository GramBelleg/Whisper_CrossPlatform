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
    try {
      // Show dialog to choose between photo and video
      final source = await showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(
            'Camera',
            style: TextStyle(
              color: secondNeutralColor, // Set the text color
            ),
          ),
          backgroundColor: firstSecondaryColor,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text(
                  'Take Photo',
                  style: TextStyle(
                    color: secondNeutralColor, // Set the text color
                  ),
                ),
                onTap: () => Navigator.pop(context, 'photo'),
              ),
              ListTile(
                leading: Icon(Icons.videocam),
                title: Text(
                  'Record Video',
                  style: TextStyle(
                    color: secondNeutralColor, // Set the text color
                  ),
                ),
                onTap: () => Navigator.pop(context, 'video'),
              ),
            ],
          ),
        ),
      );

      if (source == null) return;

      XFile? mediaFile;
      if (source == 'photo') {
        mediaFile = await ImagePicker().pickImage(source: ImageSource.camera);
      } else {
        mediaFile = await ImagePicker().pickVideo(source: ImageSource.camera);
      }

      if (mediaFile != null) {
        String fileExtension = path.extension(mediaFile.path).toLowerCase();
        bool isValid = source == 'photo'
            ? _isValidImage(fileExtension)
            : _isValidVideo(fileExtension);

        if (isValid) {
          Navigator.of(context).pop();
          List<String> mediaPaths = [mediaFile.path];
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SelectedImageCaptioning(
                mediaPaths: mediaPaths,
                sendFile: _sendFile,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Selected file is not valid.")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Camera capture canceled")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error capturing media: $e")),
      );
    }
  }

  void _pickImageFromGallery(BuildContext context) async {
    try {
      final XFile? mediaFile = await ImagePicker().pickMedia();
      if (mediaFile != null) {
        String fileExtension = path.extension(mediaFile.path).toLowerCase();

        if (_isValidImage(fileExtension) || _isValidVideo(fileExtension)) {
          Navigator.of(context).pop();
          List<String> mediaPaths = [mediaFile.path];
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SelectedImageCaptioning(
                mediaPaths: mediaPaths,
                sendFile: _sendFile,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text("Selected file is not a valid image or video.")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gallery selection canceled")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error picking media: $e")),
      );
    }
  }

  bool _isValidImage(String extension) {
    const validExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp'];
    return validExtensions.contains(extension);
  }

  bool _isValidVideo(String extension) {
    const validExtensions = ['.mp4', '.mov', '.avi', '.mkv', '.wmv'];
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
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate minimum height needed
        double minHeight = 160; // Minimum height to prevent squishing
        double screenHeight = MediaQuery.of(context).size.height;
        double height = screenHeight / 5;

        // Use the larger of minHeight or calculated height
        height = height < minHeight ? minHeight : height;

        return SizedBox(
          height: height,
          width: MediaQuery.of(context).size.width,
          child: Card(
            color: firstSecondaryColor,
            margin: EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 8, // Reduced vertical margin to prevent overflow
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: height * 0.1, // Proportional vertical padding
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    child: IconCreationWidget(
                      key: FileButtonSheetAddStoryKeys.cameraIcon,
                      textStyle: TextStyle(),
                      icon: Icons.camera_alt,
                      text: "Camera",
                      color: Colors.pink,
                      onTap: () => _pickImageFromCamera(context),
                    ),
                  ),
                  Flexible(
                    child: IconCreationWidget(
                      key: FileButtonSheetAddStoryKeys.galleryIcon,
                      textStyle: TextStyle(),
                      icon: Icons.photo,
                      text: "Gallery",
                      color: Colors.purple,
                      onTap: () => _pickImageFromGallery(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
