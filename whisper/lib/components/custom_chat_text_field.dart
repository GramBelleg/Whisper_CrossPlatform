import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/keys/custom_chat_text_field_keys.dart';
import 'package:whisper/keys/file_button_sheet_keys.dart';
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
  final bool isEditing;
  final String editingMessage;
  final VoidCallback handleCancelEditing;

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
    required this.isEditing,
    required this.editingMessage,
    required this.handleCancelEditing,
    Key? key,
  }) : super(key: key);

  @override
  _CustomChatTextFieldState createState() => _CustomChatTextFieldState();
}

class _CustomChatTextFieldState extends State<CustomChatTextField> {
  bool show = false;
  @override
  void initState() {
    super.initState();
    // Set the initial text to the editing message if in editing mode
    if (widget.editingMessage.isNotEmpty) {
      widget.controller.text = widget.editingMessage;
    }
  }

  @override
  void didUpdateWidget(covariant CustomChatTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.editingMessage.isNotEmpty) {
      widget.controller.text = widget.editingMessage;
    }
  }

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
      fillColor: firstNeutralColor,
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
        color: primaryColor,
      ),
      key: Key(CustomChatTextFieldKeys.prefixIcon), // Key added
    );
  }

  Widget _buildSuffixIcon(BuildContext context) {
    return !widget.isEditing
        ? IconButton(
            onPressed: () => _handleSuffixIconPress(),
            icon: FaIcon(
              FontAwesomeIcons.paperclip,
              color: primaryColor,
            ),
            key: Key(CustomChatTextFieldKeys.filePickerButton),
          )
        : IconButton(
            key: Key(CustomChatTextFieldKeys.cancelEditing),
            onPressed: () {
              widget.controller.clear();
              widget.handleCancelEditing();
            },
            icon: FaIcon(
              FontAwesomeIcons.xmark,
              color: primaryColor,
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
        key: Key(FileButtonSheetKeys.fileButtonSheet),
      ),
    );
  }
}
