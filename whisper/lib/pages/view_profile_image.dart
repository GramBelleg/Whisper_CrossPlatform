import 'package:flutter/material.dart';
import 'package:whisper/keys/settings_page_keys.dart';

class FullScreenPhotoScreen extends StatelessWidget {
  final String photoUrl;

  const FullScreenPhotoScreen({Key? key, required this.photoUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Image.network(
              photoUrl,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              key: Key(SettingsPageKeys.backFromViewProfilePicture),
              icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
