import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

class EmojiSelect extends StatelessWidget {
  final TextEditingController controller;
  final ScrollController scrollController;
  final ValueSetter<bool> onTypingStatusChanged;

  const EmojiSelect({
    super.key,
    required this.controller,
    required this.scrollController,
    required this.onTypingStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return EmojiPicker(
      onBackspacePressed: () {
        String currentText = controller.text;

        if (currentText.isNotEmpty) {
          var runes = currentText.runes.toList();
          runes.removeLast();
          controller.text = String.fromCharCodes(runes);

          controller.selection = TextSelection.fromPosition(
            TextPosition(offset: controller.text.length),
          );
        }

        onTypingStatusChanged(controller.text.isNotEmpty);
      },
      onEmojiSelected: (category, emoji) {
        controller.text += emoji.emoji;

        if (scrollController.hasClients) {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        }

        onTypingStatusChanged(true);

        controller.selection = TextSelection.fromPosition(
          TextPosition(offset: controller.text.length),
        );
      },
    );
  }
}
