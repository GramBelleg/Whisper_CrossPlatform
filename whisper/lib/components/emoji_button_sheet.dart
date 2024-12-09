import 'package:flutter/material.dart';
import 'package:whisper/components/icon_creation_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whisper/constants/colors.dart';

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
      // I commented this to make it work in landscape
      height: 170,
      // width: MediaQuery.of(context).size.width,
      child: Card(
        color: firstSecondaryColor,
        margin: const EdgeInsets.all(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
          child: Row(
            children: [
              IconCreationWidget(
                icon: FontAwesomeIcons.faceSmile,
                text: "Emojis",
                textStyle: TextStyle(color: secondNeutralColor),
                color: Colors.indigo,
                onTap: onEmojiTap,
              ),
              Spacer(flex: 1),
              IconCreationWidget(
                icon: Icons.sticky_note_2,
                text: "Stickers",
                textStyle: TextStyle(color: secondNeutralColor),
                color: Colors.pink,
                onTap: onStickerTap,
              ),
              Spacer(flex: 1),
              IconCreationWidget(
                icon: Icons.gif,
                text: "GIFs",
                textStyle: TextStyle(color: secondNeutralColor),
                color: Colors.purple,
                onTap: onGifTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
