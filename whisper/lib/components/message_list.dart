import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/keys/message_list_keys.dart';
import 'package:whisper/components/audio_message_card.dart';
import 'package:whisper/components/own-message/forwarded_audio_message_card.dart';
import 'package:whisper/components/own-message/forwarded_voice_message_card.dart';
import 'package:whisper/components/own-message/sent_audio_message_card.dart';
import 'package:whisper/components/receive-message/received_audio_message_card.dart';
import 'package:whisper/components/receive-message/received_forwarded_audio_message_card.dart';
import 'package:whisper/components/receive-message/received_forwarded_voice_message.dart';
import 'package:whisper/components/receive-message/received_voice_message_card.dart';
import 'package:whisper/components/own-message/forwarded_gif_message_card.dart';
import 'package:whisper/components/own-message/forwarded_sticker_message_card.dart';
import 'package:whisper/components/own-message/sent_gif_message_card.dart';
import 'package:whisper/components/own-message/sent_sticker_message_card.dart';
import 'package:whisper/components/receive-message/received_forwarded_gif_message_card.dart';
import 'package:whisper/components/receive-message/received_forwarded_sticker_message_card.dart';
import 'package:whisper/components/receive-message/received_gif_message_card.dart';
import 'package:whisper/components/receive-message/received_sticker_message_card.dart';
import 'package:whisper/components/sticker_message_card.dart';
import 'package:whisper/models/chat_message.dart';
import 'package:whisper/components/own-message/forwarded_file_message_card.dart';
import 'package:whisper/components/own-message/replied_file_message_card.dart';
import 'package:whisper/components/own-message/file_message_card.dart';
import 'package:whisper/components/own-message/forwarded_image_message_card.dart';
import 'package:whisper/components/own-message/forwarded_video_message_card.dart';
import 'package:whisper/components/own-message/forwarded_message_card.dart';
import 'package:whisper/components/own-message/replied_image_message_card.dart';
import 'package:whisper/components/own-message/image_message_card.dart';
import 'package:whisper/components/own-message/normal_message_card.dart';
import 'package:whisper/components/own-message/own_message.dart';
import 'package:whisper/components/own-message/replied_message_card.dart';
import 'package:whisper/components/own-message/replied_video_message_card.dart';
import 'package:whisper/components/own-message/video_message_card.dart';
import 'package:whisper/components/own-message/sent_voice_message_card.dart';
import 'package:whisper/components/receive-message/file_received_message_card.dart';
import 'package:whisper/components/receive-message/forwarded_received_video_message_card.dart';
import 'package:whisper/components/receive-message/forwarded_file_received_message_card.dart';
import 'package:whisper/components/receive-message/forwarded_received_image_message_card.dart';
import 'package:whisper/components/receive-message/forwarded_received_message_card.dart';
import 'package:whisper/components/receive-message/image_received_message_card.dart';
import 'package:whisper/components/receive-message/normal_received_message_card.dart';
import 'package:whisper/components/receive-message/replied_image_received_message_card.dart';
import 'package:whisper/components/receive-message/replied_received_video_message_card.dart';
import 'package:whisper/components/receive-message/file_replied_received_message_card.dart';
import 'package:whisper/components/receive-message/replied-received-message-card.dart';
import 'package:whisper/components/receive-message/video_received_message_card.dart';

class MessageList extends StatefulWidget {
  final List<ChatMessage> messages;
  final ValueChanged<ChatMessage> onLongPress;
  final ValueChanged<ChatMessage> onTap;
  final ValueChanged<ChatMessage> onRightSwipe;
  final List<int> isSelectedList;
  final int senderId;
  final PlayerController playerController;
  final Function(String) onPlay;

  const MessageList({
    required this.messages,
    required this.onLongPress,
    required this.onTap,
    required this.isSelectedList,
    required this.senderId,
    required this.onRightSwipe,
    required this.playerController,
    required this.onPlay,
  });

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  late List<ChatMessage> previousMessages;
  ItemScrollController itemScrollController = ItemScrollController();
  @override
  void initState() {
    super.initState();
    previousMessages = List.from(widget.messages);
  }

  @override
  void didUpdateWidget(covariant MessageList oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Detect if a new message was added
    if (widget.messages.length > previousMessages.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (itemScrollController.isAttached) {
          itemScrollController.jumpTo(
            index: 0, // Scroll to the first item (most recent message)
          );
        }
      });

      // Update the previousMessages list
      previousMessages = List.from(widget.messages);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScrollablePositionedList.builder(
      reverse: true,
      itemScrollController: itemScrollController,
      itemCount: widget.messages.length,
      itemBuilder: (context, index) {
        final messageData = widget.messages[index];
        return SwipeTo(
          key: ValueKey('${MessageListKeys.swipeKeyPrefix}${messageData.id}'),
          iconColor: primaryColor,
          onRightSwipe: (details) {
            widget.onRightSwipe(messageData);
          },
          child: GestureDetector(
            key: ValueKey('${MessageListKeys.tapKeyPrefix}${messageData.id}'),
            onLongPress: () => widget.onLongPress(messageData),
            onTap: () {
              if (messageData.parentMessage?.id != null &&
                  widget.isSelectedList.isEmpty) {
                int parentIndex = widget.messages.indexWhere(
                  (message) => message.id == messageData.parentMessage?.id,
                );

                if (parentIndex != -1) {
                  itemScrollController.scrollTo(
                    index: parentIndex,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              }
              widget.onTap(messageData);
            },
            child: messageData.sender!.id == widget.senderId
                ? _buildSenderMessage(messageData)
                : _buildReceiverMessage(messageData),
          ),
        );
      },
    );
  }

  Widget _buildSenderMessage(ChatMessage messageData) {
    if (messageData.forwarded == true && messageData.media == null) {
      return ForwardedMessageCard(
        message: messageData.content,
        time: messageData.time!,
        status: MessageStatus.sent,
        isSelected: messageData.id != null &&
            widget.isSelectedList.contains(messageData.id!),
        messageSenderName: messageData.forwardedFrom!.userName,
      );
    } else if (messageData.forwarded == true &&
        messageData.media != null &&
        messageData.media!.isNotEmpty &&
        messageData.type == "DOC") {
      return ForwardedFileMessageCard(
        blobName: messageData.media!,
        message: messageData.content,
        time: messageData.time!,
        isSelected: messageData.id != null &&
            widget.isSelectedList.contains(messageData.id!),
        forwardedSenderName: messageData.forwardedFrom!.userName,
        status: MessageStatus.sent,
      );
    } else if (messageData.forwarded == true &&
        messageData.media != null &&
        messageData.media!.isNotEmpty &&
        messageData.type == "IMAGE") {
      return ForwardedImageMessageCard(
        blobName: messageData.media!,
        message: messageData.content,
        time: messageData.time!,
        isSelected: messageData.id != null &&
            widget.isSelectedList.contains(messageData.id!),
        forwardedSenderName: messageData.forwardedFrom!.userName,
        status: MessageStatus.sent,
      );
    } else if (messageData.forwarded == true &&
        messageData.media != null &&
        messageData.media!.isNotEmpty &&
        messageData.type == "VIDEO") {
      return ForwardedVideoMessageCard(
        blobName: messageData.media!,
        message: messageData.content,
        time: messageData.time!,
        isSelected: messageData.id != null &&
            widget.isSelectedList.contains(messageData.id!),
        forwardedSenderName: messageData.forwardedFrom!.userName,
        status: MessageStatus.sent,
      );
    } else if (messageData.forwarded == true &&
        messageData.media != null &&
        messageData.media!.isNotEmpty &&
        messageData.type == "VM") {
      debugPrint("FORWARDED VOICE MESSAGE HERE");
      return ForwardedVoiceMessageCard(
        blobName: messageData.media!,
        message: messageData.content,
        time: messageData.time!,
        isSelected: messageData.id != null &&
            widget.isSelectedList.contains(messageData.id!),
        senderName: messageData.forwardedFrom!.userName,
        status: MessageStatus.sent,
      );
    } else if (messageData.forwarded == true &&
        messageData.media != null &&
        messageData.media!.isNotEmpty &&
        messageData.type == "AUDIO") {
      debugPrint("FORWARDED AUDIO MESSAGE HERE");
      return ForwardedAudioMessageCard(
        blobName: messageData.media!,
        message: messageData.content,
        time: messageData.time!,
        isSelected: messageData.id != null &&
            widget.isSelectedList.contains(messageData.id!),
        senderName: messageData.forwardedFrom!.userName,
        status: MessageStatus.sent,
      );
    } else if (messageData.forwarded == true &&
        messageData.media != null &&
        messageData.media!.isNotEmpty &&
        messageData.type == "GIF") {
      if (kDebugMode) print("RECEIVED GIF MESSAGE HERE");
      if (kDebugMode)
        print("media=${messageData.media}, type=${messageData.type}");
      return ForwardedGifMessageCard(
        blobName: messageData.media!,
        message: messageData.content,
        time: messageData.time!,
        status: MessageStatus.sent,
        isSelected: messageData.id != null &&
            widget.isSelectedList.contains(messageData.id!),
        senderName: messageData.forwardedFrom!.userName,
      );
    } else if (messageData.forwarded == true &&
        messageData.media != null &&
        messageData.media!.isNotEmpty &&
        messageData.type == "STICKER") {
      if (kDebugMode) print("RECEIVED STICKER MESSAGE HERE");
      if (kDebugMode)
        print("media=${messageData.media}, type=${messageData.type}");
      return ForwardedStickerMessageCard(
        blobName: messageData.media!,
        message: messageData.content,
        time: messageData.time!,
        status: MessageStatus.sent,
        isSelected: messageData.id != null &&
            widget.isSelectedList.contains(messageData.id!),
        senderName: messageData.forwardedFrom!.userName,
      );
    } else if (messageData.parentMessage != null && messageData.media == null) {
      print(
          "aaaaaa${messageData.content}, ${messageData.time!},${messageData.id != null && widget.isSelectedList.contains(messageData.id!)},${messageData.parentMessage!.content},${messageData.parentMessage!.senderName}");
      return RepliedMessageCard(
        message: messageData.content,
        time: messageData.time!,
        status: MessageStatus.sent,
        isSelected: messageData.id != null &&
            widget.isSelectedList.contains(messageData.id!),
        repliedContent: messageData.parentMessage!.content,
        repliedSenderName: messageData.parentMessage!.senderName,
      );
    } else if (messageData.parentMessage != null &&
        messageData.media != null &&
        messageData.media!.isNotEmpty &&
        messageData.type == "DOC") {
      return RepliedFileMessageCard(
        blobName: messageData.media!,
        message: messageData.content,
        time: messageData.time!,
        isSelected: messageData.id != null &&
            widget.isSelectedList.contains(messageData.id!),
        repliedContent: messageData.parentMessage!.content,
        repliedSenderName: messageData.parentMessage!.senderName,
        status: MessageStatus.sent,
      );
    } else if (messageData.parentMessage != null &&
        messageData.media != null &&
        messageData.media!.isNotEmpty &&
        messageData.type == "IMAGE") {
      return RepliedImageMessageCard(
        blobName: messageData.media!,
        message: messageData.content,
        time: messageData.time!,
        isSelected: messageData.id != null &&
            widget.isSelectedList.contains(messageData.id!),
        repliedContent: messageData.parentMessage!.content,
        repliedSenderName: messageData.parentMessage!.senderName,
        status: MessageStatus.sent,
      );
    } else if (messageData.parentMessage != null &&
        messageData.media != null &&
        messageData.media!.isNotEmpty &&
        messageData.type == "VIDEO") {
      return RepliedVideoMessageCard(
        blobName: messageData.media!,
        message: messageData.content,
        time: messageData.time!,
        isSelected: messageData.id != null &&
            widget.isSelectedList.contains(messageData.id!),
        repliedContent: messageData.parentMessage!.content,
        repliedSenderName: messageData.parentMessage!.senderName,
        status: MessageStatus.sent,
      );
    } else if (messageData.media != null &&
        messageData.media!.isNotEmpty &&
        messageData.type == "DOC") {
      return FileMessageCard(
        message: messageData.content,
        time: messageData.time!,
        status: MessageStatus.sent,
        isSelected: messageData.id != null &&
            widget.isSelectedList.contains(messageData.id!),
        blobName: messageData.media!,
      );
    } else if (messageData.media != null &&
        messageData.media!.isNotEmpty &&
        (messageData.type == "IMAGE")) {
      return ImageMessageCard(
        message: messageData.content,
        time: messageData.time!,
        status: MessageStatus.sent,
        isSelected: messageData.id != null &&
            widget.isSelectedList.contains(messageData.id!),
        blobName: messageData.media!,
      );
    } else if (messageData.media != null &&
        messageData.media!.isNotEmpty &&
        (messageData.type == "VIDEO")) {
      return VideoMessageCard(
        message: messageData.content,
        time: messageData.time!,
        status: MessageStatus.sent,
        isSelected: messageData.id != null &&
            widget.isSelectedList.contains(messageData.id!),
        blobName: messageData.media!,
      );
    } else if (messageData.media != null &&
        messageData.media!.isNotEmpty &&
        messageData.type == "VM") {
      debugPrint("RECEIVED VOICE MESSAGE HERE");
      debugPrint("media=${messageData.media}, type=${messageData.type}");
      return SentVoiceMessageCard(
        blobName: messageData.media!,
        message: messageData.content,
        time: messageData.time!,
        status: MessageStatus.sent,
        isSelected: messageData.id != null &&
            widget.isSelectedList.contains(messageData.id!),
      );
    } else if (messageData.media != null &&
        messageData.media!.isNotEmpty &&
        messageData.type == "AUDIO") {
      debugPrint("RECEIVED AUDIO MESSAGE HERE");
      debugPrint("media=${messageData.media}, type=${messageData.type}");
      return SentAudioMessageCard(
        blobName: messageData.media!,
        message: messageData.content,
        time: messageData.time!,
        status: MessageStatus.sent,
        isSelected: messageData.id != null &&
            widget.isSelectedList.contains(messageData.id!),
      );
    } else if (messageData.media != null &&
        messageData.media!.isNotEmpty &&
        messageData.type == "GIF") {
      if (kDebugMode) print("RECEIVED GIF MESSAGE HERE");
      if (kDebugMode)
        print("media=${messageData.media}, type=${messageData.type}");
      return SentGifMessageCard(
        blobName: messageData.media!,
        message: messageData.content,
        time: messageData.time!,
        status: MessageStatus.sent,
        isSelected: messageData.id != null &&
            widget.isSelectedList.contains(messageData.id!),
      );
    } else if (messageData.media != null &&
        messageData.media!.isNotEmpty &&
        messageData.type == "STICKER") {
      if (kDebugMode) print("RECEIVED STICKER MESSAGE HERE");
      if (kDebugMode)
        print("media=${messageData.media}, type=${messageData.type}");
      return SentStickerMessageCard(
        blobName: messageData.media!,
        message: messageData.content,
        time: messageData.time!,
        status: MessageStatus.sent,
        isSelected: messageData.id != null &&
            widget.isSelectedList.contains(messageData.id!),
      );
    } else {
      if (kDebugMode) print("RECEIVED NORMAL MESSAGE HERE");
      if (kDebugMode)
        print("media=${messageData.media}, type=${messageData.type}");
      return NormalMessageCard(
        message: messageData.content,
        time: messageData.time!,
        status: MessageStatus.sent,
        isSelected: messageData.id != null &&
            widget.isSelectedList.contains(messageData.id!),
      );
    }
  }

  Widget _buildReceiverMessage(ChatMessage messageData) {
    if (messageData.forwarded == true && messageData.media == null) {
      return ForwardedReceivedMessageCard(
        senderName: messageData.sender!.userName,
        message: messageData.content,
        time: messageData.time!,
        status: MessageStatus.sent,
        isSelected: messageData.id != null &&
            widget.isSelectedList.contains(messageData.id!),
        messageSenderName: messageData.forwardedFrom!.userName,
      );
    } else if (messageData.forwarded == true &&
        messageData.media != null &&
        messageData.media!.isNotEmpty &&
        (messageData.type == "DOC")) {
      return ForwardedFileReceivedMessageCard(
        senderName: messageData.sender!.userName,
        blobName: messageData.media!,
        message: messageData.content,
        time: messageData.time!,
        isSelected: messageData.id != null &&
            widget.isSelectedList.contains(messageData.id!),
        messageSenderName: messageData.forwardedFrom!.userName,
        status: MessageStatus.sent,
      );
    } else if (messageData.forwarded == true &&
        messageData.media != null &&
        messageData.media!.isNotEmpty &&
        (messageData.type == "IMAGE")) {
      return ForwardedReceivedImageMessageCard(
        senderName: messageData.sender!.userName,
        blobName: messageData.media!,
        message: messageData.content,
        time: messageData.time!,
        status: MessageStatus.sent,
        isSelected: messageData.id != null &&
            widget.isSelectedList.contains(messageData.id!),
        messageSenderName: messageData.forwardedFrom!.userName,
      );
    } else if (messageData.forwarded == true &&
        messageData.media != null &&
        messageData.media!.isNotEmpty &&
        (messageData.type == "VIDEO")) {
      return ForwardedReceivedVideoMessageCard(
        senderName: messageData.sender!.userName,
        blobName: messageData.media!,
        message: messageData.content,
        time: messageData.time!,
        status: MessageStatus.sent,
        isSelected: messageData.id != null &&
            widget.isSelectedList.contains(messageData.id!),
        messageSenderName: messageData.forwardedFrom!.userName,
      );
    } else if (messageData.forwarded == true &&
        messageData.media != null &&
        messageData.media!.isNotEmpty &&
        (messageData.type == "VM")) {
      return ReceivedForwardedVoiceMessage(
        blobName: messageData.media!,
        message: messageData.content,
        time: messageData.time!,
        status: MessageStatus.sent,
        isSelected: messageData.id != null &&
            widget.isSelectedList.contains(messageData.id!),
        senderName: messageData.forwardedFrom!.userName,
      );
    } else if (messageData.forwarded == true &&
        messageData.media != null &&
        messageData.media!.isNotEmpty &&
        (messageData.type == "AUDIO")) {
      return ReceivedForwardedAudioMessageCard(
        blobName: messageData.media!,
        message: messageData.content,
        time: messageData.time!,
        status: MessageStatus.sent,
        isSelected: messageData.id != null &&
            widget.isSelectedList.contains(messageData.id!),
        senderName: messageData.forwardedFrom!.userName,
      );
    } else if (messageData.forwarded == true &&
        messageData.media != null &&
        messageData.media!.isNotEmpty &&
        (messageData.type == "GIF")) {
      return ReceivedForwardedGifMessageCard(
        blobName: messageData.media!,
        message: messageData.content,
        time: messageData.time!,
        status: MessageStatus.sent,
        isSelected: messageData.id != null &&
            widget.isSelectedList.contains(messageData.id!),
        senderName: messageData.forwardedFrom!.userName,
      );
    } else if (messageData.forwarded == true &&
        messageData.media != null &&
        messageData.media!.isNotEmpty &&
        (messageData.type == "STICKER")) {
      return ReceivedForwardedStickerMessageCard(
        blobName: messageData.media!,
        message: messageData.content,
        time: messageData.time!,
        status: MessageStatus.sent,
        isSelected: messageData.id != null &&
            widget.isSelectedList.contains(messageData.id!),
        senderName: messageData.forwardedFrom!.userName,
      );
    } else if (messageData.parentMessage != null && messageData.media == null) {
      return RepliedReceivedMessageCard(
        senderName: messageData.sender!.userName,
        message: messageData.content,
        time: messageData.time!,
        status: MessageStatus.sent,
        isSelected: messageData.id != null &&
            widget.isSelectedList.contains(messageData.id!),
        repliedContent: messageData.parentMessage!.content,
        repliedSenderName: messageData.parentMessage!.senderName,
      );
    } else if (messageData.parentMessage != null &&
        messageData.media != null &&
        messageData.media!.isNotEmpty &&
        (messageData.type == "DOC")) {
      return FileRepliedReceivedMessageCard(
        senderName: messageData.sender!.userName,
        blobName: messageData.media!,
        message: messageData.content,
        time: messageData.time!,
        isSelected: messageData.id != null &&
            widget.isSelectedList.contains(messageData.id!),
        repliedContent: messageData.parentMessage!.content,
        repliedSenderName: messageData.parentMessage!.senderName,
        status: MessageStatus.sent,
      );
    } else if (messageData.parentMessage != null &&
        messageData.media != null &&
        messageData.media!.isNotEmpty &&
        (messageData.type == "IMAGE")) {
      return RepliedImageReceivedMessageCard(
        senderName: messageData.sender!.userName,
        blobName: messageData.media!,
        message: messageData.content,
        time: messageData.time!,
        status: MessageStatus.sent,
        isSelected: messageData.id != null &&
            widget.isSelectedList.contains(messageData.id!),
        repliedContent: messageData.parentMessage!.content,
        repliedSenderName: messageData.parentMessage!.senderName,
      );
    } else if (messageData.parentMessage != null &&
        messageData.media != null &&
        messageData.media!.isNotEmpty &&
        (messageData.type == "VIDEO")) {
      return RepliedReceivedVideoMessageCard(
        senderName: messageData.sender!.userName,
        blobName: messageData.parentMessage!.media!,
        message: messageData.content,
        time: messageData.time!,
        status: MessageStatus.sent,
        isSelected: messageData.id != null &&
            widget.isSelectedList.contains(messageData.id!),
        repliedContent: messageData.parentMessage!.content,
        repliedSenderName: messageData.parentMessage!.senderName,
      );
    } else if (messageData.media != null &&
        messageData.media!.isNotEmpty &&
        (messageData.type == "DOC")) {
      return FileReceivedMessageCard(
        senderName: messageData.sender!.userName,
        message: messageData.content,
        time: messageData.time!,
        status: MessageStatus.sent,
        isSelected: messageData.id != null &&
            widget.isSelectedList.contains(messageData.id!),
        blobName: messageData.media!,
      );
    } else if (messageData.media != null &&
        messageData.media!.isNotEmpty &&
        (messageData.type == "IMAGE")) {
      return ImageReceivedMessageCard(
        senderName: messageData.sender!.userName,
        message: messageData.content,
        time: messageData.time!,
        status: MessageStatus.sent,
        isSelected: messageData.id != null &&
            widget.isSelectedList.contains(messageData.id!),
        blobName: messageData.media!,
      );
    } else if (messageData.media != null &&
        messageData.media!.isNotEmpty &&
        (messageData.type == "VIDEO")) {
      return VideoReceivedMessageCard(
        senderName: messageData.sender!.userName,
        message: messageData.content,
        time: messageData.time!,
        status: MessageStatus.sent,
        isSelected: messageData.id != null &&
            widget.isSelectedList.contains(messageData.id!),
        blobName: messageData.media!,
      );
    } else if (messageData.media != null &&
        messageData.media!.isNotEmpty &&
        messageData.type == "VM") {
      debugPrint("RECEIVED VOICE MESSAGE HERE");
      debugPrint("media=${messageData.media}, type=${messageData.type}");
      return ReceivedVoiceMessageCard(
        senderName: messageData.sender!.userName,
        blobName: messageData.media!,
        message: messageData.content,
        time: messageData.time!,
        status: MessageStatus.sent,
        isSelected: messageData.id != null &&
            widget.isSelectedList.contains(messageData.id!),
      );
    } else if (messageData.media != null &&
        messageData.media!.isNotEmpty &&
        messageData.type == "AUDIO") {
      debugPrint("RECEIVED AUDIO MESSAGE HERE");
      debugPrint("media=${messageData.media}, type=${messageData.type}");
      return ReceivedAudioMessageCard(
        senderName: messageData.sender!.userName,
        blobName: messageData.media!,
        message: messageData.content,
        time: messageData.time!,
        status: MessageStatus.sent,
        isSelected: messageData.id != null &&
            widget.isSelectedList.contains(messageData.id!),
      );
    } else if (messageData.media != null &&
        messageData.media!.isNotEmpty &&
        (messageData.type == "GIF")) {
      return ReceivedGifMessageCard(
        senderName: messageData.sender!.userName,
        message: messageData.content,
        time: messageData.time!,
        status: MessageStatus.sent,
        isSelected: messageData.id != null &&
            widget.isSelectedList.contains(messageData.id!),
        blobName: messageData.media!,
      );
    } else if (messageData.media != null &&
        messageData.media!.isNotEmpty &&
        (messageData.type == "STICKER")) {
      return ReceivedStickerMessageCard(
        senderName: messageData.sender!.userName,
        message: messageData.content,
        time: messageData.time!,
        status: MessageStatus.sent,
        isSelected: messageData.id != null &&
            widget.isSelectedList.contains(messageData.id!),
        blobName: messageData.media!,
      );
    } else {
      return NormalReceivedMessageCard(
        senderName: messageData.sender!.userName,
        message: messageData.content,
        time: messageData.time!,
        status: MessageStatus.sent,
        isSelected: messageData.id != null &&
            widget.isSelectedList.contains(messageData.id!),
      );
    }
  }
}
