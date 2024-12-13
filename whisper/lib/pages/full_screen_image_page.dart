import 'package:flutter/material.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/keys/full_screen_image_page_keys.dart';

class FullScreenImagePage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImagePage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            key: Key(FullScreenImagePageKeys.backButton),
            icon: Icon(
              Icons.arrow_back,
              color: primaryColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0, // Optional: removes shadow from AppBar
        ),
        body: Center(
          child: InteractiveViewer(
            child: Image.network(
              key: Key(FullScreenImagePageKeys.imageContainer),
              imageUrl,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(
                    child: CircularProgressIndicator(
                  key: Key(FullScreenImagePageKeys.loadingIndicator),
                ));
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  key: Key(FullScreenImagePageKeys.errorContainer),
                  color: firstSecondaryColor,
                  child: const Center(
                    child: Icon(
                      Icons.broken_image,
                      color: Colors.white,
                      size: 70,
                    ),
                  ),
                );
              },
            ),
          ),
        ));
  }
}
