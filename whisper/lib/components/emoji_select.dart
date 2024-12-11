import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:whisper/constants/colors.dart';

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
      config: Config(
        // TODO: edit hegit to be same as opened keyboard
        height: MediaQuery.of(context).size.height / 2.5,
        categoryViewConfig: CategoryViewConfig(
          backgroundColor: firstNeutralColor,
          indicatorColor: highlightColor,
        ),
        emojiViewConfig: EmojiViewConfig(
          backgroundColor: firstNeutralColor,
          columns: 7,
          emojiSizeMax: 32.0,
          verticalSpacing: 0,
          horizontalSpacing: 0,
          recentsLimit: 28,
          buttonMode: ButtonMode.MATERIAL,
        ),
        bottomActionBarConfig: BottomActionBarConfig(
          enabled: false,
        ),
      ),
    );
  }
}
