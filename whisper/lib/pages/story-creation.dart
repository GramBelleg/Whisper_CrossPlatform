import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:whisper/components/users-stories.dart';
import 'package:whisper/services/upload-file.dart';

class StoryCreationScreen extends StatefulWidget {
  final Function(Story) onStoryCreated;

  const StoryCreationScreen({
    super.key,
    required this.onStoryCreated,
  });

  @override
  _StoryCreationScreenState createState() => _StoryCreationScreenState();
}

class _StoryCreationScreenState extends State<StoryCreationScreen> {
  final TextEditingController _contentController = TextEditingController();
  String _mediaUrl = "";
  bool _isVideo = false;
  VideoPlayerController? _videoController;

  final ImagePicker _picker = ImagePicker();

  // Pick image using the camera or gallery
  Future<void> _pickMedia(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _mediaUrl = pickedFile.path;
        _isVideo = false; // For images
        _videoController?.dispose(); // Dispose of previous video controller
        _videoController = null;
      });
    }
  }

  // Pick video using the camera or gallery
  Future<void> _pickVideo(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickVideo(source: source);
    if (pickedFile != null) {
      setState(() {
        _mediaUrl = pickedFile.path;
        _isVideo = true;
        _videoController?.dispose(); // Dispose of previous video controller
        _videoController = VideoPlayerController.file(File(_mediaUrl))
          ..initialize().then((_) {
            setState(() {}); // Refresh to show the video player
            _videoController!.play(); // Automatically play the video
          });
      });
    }
  }

  void _submitStory(BuildContext context) async {
    if (_mediaUrl.isNotEmpty) {
      String mediaUrl = await uploadFile(_mediaUrl);
      if (mediaUrl != "Failed") {
        widget.onStoryCreated(Story(
          id: DateTime.now().millisecondsSinceEpoch,
          content:
              _contentController.text.isNotEmpty ? _contentController.text : '',
          media: mediaUrl,
          type: _isVideo ? 'VIDEO' : 'IMAGE',
          likes: 0,
          views: 0,
          date: DateTime.now(),
          isArchived: false,
          privacy: 'Everyone',
          viewed: false,
          liked: false,
        ));

        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    _videoController?.dispose(); // Dispose of the video controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a Story'),
      ),
      body: SingleChildScrollView(
        // Make the body scrollable
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    // Use Expanded for buttons
                    child: ElevatedButton.icon(
                      onPressed: () => _pickMedia(ImageSource.camera),
                      icon: Icon(Icons.camera_alt),
                      label: Text('Capture Image'),
                    ),
                  ),
                  SizedBox(width: 10), // Add space between buttons
                  Expanded(
                    // Use Expanded for buttons
                    child: ElevatedButton.icon(
                      onPressed: () => _pickVideo(ImageSource.camera),
                      icon: Icon(Icons.videocam),
                      label: Text('Capture Video'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              if (_isVideo &&
                  _videoController != null &&
                  _videoController!.value.isInitialized)
                AspectRatio(
                  aspectRatio: _videoController!.value.aspectRatio,
                  child: VideoPlayer(_videoController!),
                )
              else if (_mediaUrl.isNotEmpty && !_isVideo)
                Image.file(File(_mediaUrl), height: 200),
              SizedBox(height: 20),
              TextField(
                controller: _contentController,
                decoration: InputDecoration(
                  labelText: 'Write your content here',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _submitStory(context),
                child: Text('Add Story'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton.extended(
          onPressed: () => _pickMedia(ImageSource.gallery),
          label: Text('Gallery'),
          icon: Icon(Icons.photo_library),
        ),
      ),
    );
  }
}
