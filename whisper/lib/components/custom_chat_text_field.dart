import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whisper/components/gif_picker.dart';
import 'package:whisper/models/parent_message.dart';
import 'package:whisper/components/file_button_sheet.dart';
import 'package:whisper/components/emoji_button_sheet.dart';

class CustomChatTextField extends StatefulWidget {
  final ScrollController scrollController;
  final FocusNode focusNode;
  final TextEditingController controller;
  final Function(String) onChanged;
  final TextAlign textAlign;
  final TextDirection textDirection;
  final int chatId;
  final int senderId;
  final String userName;
  final ParentMessage? parentMessage;
  final bool isReplying;
  final VoidCallback toggleEmojiPicker;
  final VoidCallback toggleGifPicker;
  final VoidCallback toggleStickerPicker;
  final VoidCallback handleOncancelReply;

  CustomChatTextField({
    required this.scrollController,
    required this.focusNode,
    required this.controller,
    required this.onChanged,
    required this.textAlign,
    required this.textDirection,
    required this.toggleEmojiPicker,
    required this.toggleGifPicker,
    required this.toggleStickerPicker,
    required this.chatId,
    required this.senderId,
    required this.userName,
    required this.parentMessage,
    required this.isReplying,
    required this.handleOncancelReply,
    Key? key,
  }) : super(key: key);

  @override
  _CustomChatTextFieldState createState() => _CustomChatTextFieldState();
}

class _CustomChatTextFieldState extends State<CustomChatTextField> {
  bool show = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      scrollController: widget.scrollController,
      focusNode: widget.focusNode,
      textAlignVertical: TextAlignVertical.center,
      keyboardType: TextInputType.multiline,
      minLines: 1,
      maxLines: 5,
      controller: widget.controller,
      textAlign: widget.textAlign,
      textDirection: widget.textDirection,
      style: const TextStyle(color: Colors.white),
      onChanged: widget.onChanged,
      decoration: _buildInputDecoration(context),
    );
  }

  InputDecoration _buildInputDecoration(BuildContext context) {
    return InputDecoration(
      fillColor: const Color(0xff0A122F),
      filled: true,
      hintText: "Message Here",
      hintStyle: const TextStyle(color: Colors.white54),
      contentPadding: const EdgeInsets.all(5),
      prefixIcon: _buildPrefixIcon(context),
      suffixIcon: _buildSuffixIcon(context),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _buildPrefixIcon(BuildContext context) {
    return IconButton(
      onPressed: () => _handlePrefixIconPress(),
      icon: FaIcon(
        show ? FontAwesomeIcons.keyboard : FontAwesomeIcons.faceSmile,
        color: const Color(0xff8D6AEE),
      ),
    );
  }

  Widget _buildSuffixIcon(BuildContext context) {
    return IconButton(
      onPressed: () => _handleSuffixIconPress(),
      icon: const FaIcon(
        FontAwesomeIcons.paperclip,
        color: Color(0xff8D6AEE),
      ),
    );
  }

  void _handlePrefixIconPress() {
    if (show) {
      widget.focusNode.requestFocus();
    } else {
      showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => EmojiButtonSheet(
          onEmojiTap: () {
            Navigator.pop(context);
            widget.toggleEmojiPicker();
          },
          onStickerTap: () {
            Navigator.pop(context);
            widget.toggleStickerPicker();
          },
          onGifTap: () {
            Navigator.pop(context);
            widget.toggleGifPicker();
          },
        ),
      );
    }
  }

  void _handleSuffixIconPress() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => FileButtonSheet(
        chatId: widget.chatId,
        senderId: widget.senderId,
        senderName: widget.userName,
        parentMessage: widget.parentMessage,
        isReplying: widget.isReplying,
        isForward: false,
        forwardedFromUserId: null,
        context: context,
        handleOncancelReply: widget.handleOncancelReply,
      ),
    );
  }
}
