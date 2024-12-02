import 'package:flutter/material.dart';
import 'package:whisper/components/icon_creation_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EmojiButtonSheet extends StatelessWidget {
  final VoidCallback onEmojiTap;
  final VoidCallback onStickerTap;
  final VoidCallback onGifTap;

  const EmojiButtonSheet({
    super.key,
    required this.onEmojiTap,
    required this.onStickerTap,
    required this.onGifTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 5,
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
                    icon: FontAwesomeIcons.faceSmile,
                    text: "emoji",
                    color: Colors.indigo,
                    onTap: onEmojiTap,
                  ),
                  Spacer(flex: 1),
                  IconCreationWidget(
                    icon: Icons.sticky_note_2,
                    text: "sticker",
                    color: Colors.pink,
                    onTap: onStickerTap,
                  ),
                  Spacer(flex: 1),
                  IconCreationWidget(
                    icon: Icons.gif,
                    text: "gif",
                    color: Colors.purple,
                    onTap: onGifTap,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
