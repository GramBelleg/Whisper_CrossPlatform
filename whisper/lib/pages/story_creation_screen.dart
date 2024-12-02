import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:whisper/models/story.dart';
import 'package:whisper/services/upload_file.dart';

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

  // Pick image using the gallery or camera
  Future<void> _pickMedia(ImageSource source, {bool isVideo = false}) async {
    final XFile? pickedFile = isVideo
        ? await _picker.pickVideo(source: source)
        : await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _mediaUrl = pickedFile.path;
        _isVideo = isVideo;

        if (isVideo) {
          _videoController?.dispose();
          _videoController = VideoPlayerController.file(File(_mediaUrl))
            ..initialize().then((_) {
              setState(() {}); // Refresh to show the video player
              _videoController!.play(); // Automatically play the video
            });
        } else {
          _videoController?.dispose();
          _videoController = null; // Reset the video controller
        }
      });
    }
  }

  void _showMediaPickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Pick Photo from Gallery'),
              onTap: () {
                if (Navigator.canPop(context)) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      Navigator.pop(context);
                    }
                  });
                }
                _pickMedia(ImageSource.gallery, isVideo: false);
              },
            ),
            ListTile(
              leading: Icon(Icons.video_library),
              title: Text('Pick Video from Gallery'),
              onTap: () {
                if (Navigator.canPop(context)) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      Navigator.pop(context);
                    }
                  });
                }
                _pickMedia(ImageSource.gallery, isVideo: true);
              },
            ),
          ],
        );
      },
    );
  }

  void _submitStory(BuildContext context) async {
    if (_mediaUrl.isNotEmpty) {
      String mediaUrl = await uploadFile(_mediaUrl);
      print("the uploded image to story $mediaUrl");
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
        print("add story then pop");
      }
    }
    if (Navigator.canPop(context)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.pop(context);
        }
      });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Create a Story'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          _pickMedia(ImageSource.camera, isVideo: false),
                      icon: Icon(Icons.camera_alt),
                      label: Text('Capture Image'),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          _pickMedia(ImageSource.camera, isVideo: true),
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
          onPressed: _showMediaPickerOptions,
          label: Text('Gallery'),
          icon: Icon(Icons.photo_library),
        ),
      ),
    );
  }
}
