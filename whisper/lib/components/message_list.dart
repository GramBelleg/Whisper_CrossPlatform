import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/cubit/search_chat_cubit.dart';
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
  final bool isChannel;

  const MessageList({
    required this.messages,
    required this.onLongPress,
    required this.onTap,
    required this.isSelectedList,
    required this.senderId,
    required this.onRightSwipe,
    required this.playerController,
    required this.onPlay,
    required this.isChannel,
  });

  @override
  State<MessageList> createState() => _MessageListState();
}

// Extension to capitalize the first letter of a string
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

class _MessageListState extends State<MessageList> {
  late List<ChatMessage> previousMessages;
  ItemScrollController itemScrollController = ItemScrollController();
  String searchQuery = '';
  List<int> searchResults = [];
  int currentSearchIndex = -1;
  String selectedMediaType = 'all';
  TextEditingController searchController = TextEditingController();
  bool wasSearchOpen = false;

  @override
  void initState() {
    super.initState();
    previousMessages = List.from(widget.messages);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void resetSearch() {
    searchQuery = '';
    searchResults = [];
    currentSearchIndex = -1;
    selectedMediaType = 'all';
    searchController.clear();
  }

  void searchMessages(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      // Store results in chronological order
      searchResults = query.isEmpty
          ? []
          : widget.messages
              .asMap()
              .entries
              .where((entry) {
                bool matchesQuery =
                    entry.value.content.toLowerCase().contains(searchQuery);
                bool matchesType = selectedMediaType == 'all' ||
                    entry.value.type.toLowerCase() == selectedMediaType;
                return matchesQuery && matchesType;
              })
              .map((entry) => entry.key)
              .toList();

      // Sort results by message timestamp
      searchResults.sort((a, b) {
        DateTime timeA = widget.messages[a].sentAt ?? DateTime.now();
        DateTime timeB = widget.messages[b].sentAt ?? DateTime.now();
        return timeB.compareTo(timeA); // Newest first
      });

      currentSearchIndex = searchResults.isNotEmpty ? 0 : -1;
    });

    if (searchResults.isNotEmpty) {
      scrollToCurrentResult();
    }
  }

  void scrollToCurrentResult() {
    if (currentSearchIndex >= 0 && currentSearchIndex < searchResults.length) {
      itemScrollController.scrollTo(
        index: searchResults[currentSearchIndex],
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: 0.3, // Position the message 30% from the top
      );
    }
  }

  void navigateToResult(int direction) {
    if (searchResults.isEmpty) return;

    setState(() {
      currentSearchIndex =
          (currentSearchIndex + direction) % searchResults.length;
      if (currentSearchIndex < 0) currentSearchIndex = searchResults.length - 1;
    });

    scrollToCurrentResult();
  }

  Widget _buildMessageItem(ChatMessage messageData, int index) {
    bool isSearchResult = searchResults.contains(index);
    bool isCurrentResult =
        searchResults.isNotEmpty && index == searchResults[currentSearchIndex];

    return Container(
      decoration: BoxDecoration(
        border: isCurrentResult
            ? Border.all(color: primaryColor, width: 2.0)
            : null,
        borderRadius: BorderRadius.circular(8.0),
        color: isSearchResult && !isCurrentResult
            ? primaryColor.withOpacity(0.1)
            : null,
      ),
      child: SwipeTo(
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
          child: messageData.sender!.id == widget.senderId && !widget.isChannel
              ? _buildSenderMessage(messageData)
              : _buildReceiverMessage(messageData),
        ),
      ),
    );
  }

  Widget _buildSearchNavigation() {
    if (searchResults.isEmpty) return Container();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_upward, color: primaryColor),
            onPressed: () => navigateToResult(1),
            tooltip: 'Previous result',
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              '${currentSearchIndex + 1} of ${searchResults.length}',
              style: TextStyle(color: primaryColor),
            ),
          ),
          IconButton(
            icon: Icon(Icons.arrow_downward, color: primaryColor),
            onPressed: () => navigateToResult(-1),
            tooltip: 'Next result',
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String type, IconData icon) {
    bool isSelected = selectedMediaType == type;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: FilterChip(
        selected: isSelected,
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : primaryColor,
            ),
            SizedBox(width: 4),
            Text(
              type.capitalize(),
              style: TextStyle(
                color: isSelected ? Colors.white : primaryColor,
              ),
            ),
          ],
        ),
        selectedColor: primaryColor,
        backgroundColor: Colors.transparent,
        side: BorderSide(color: primaryColor),
        onSelected: (bool selected) {
          setState(() {
            selectedMediaType = selected ? type : 'all';
            searchMessages(searchQuery);
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<SearchChatCubit, SearchChatState>(
          builder: (context, state) {
            if (state.isSearch != wasSearchOpen) {
              wasSearchOpen = state.isSearch;
              if (!state.isSearch) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    resetSearch();
                  });
                });
              }
            }

            if (!state.isSearch) {
              return Container();
            }

            return Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Row(
                    children: [
                      _buildFilterButton('text', Icons.text_fields),
                      _buildFilterButton('image', Icons.image),
                      _buildFilterButton('video', Icons.video_library),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search messages...',
                      prefixIcon: Icon(Icons.search, color: primaryColor),
                      suffixIcon: searchResults.isNotEmpty
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.arrow_upward,
                                      color: primaryColor),
                                  onPressed: () => navigateToResult(-1),
                                  tooltip: 'Previous result',
                                ),
                                Text(
                                  '${currentSearchIndex + 1}/${searchResults.length}',
                                  style: TextStyle(color: primaryColor),
                                ),
                                IconButton(
                                  icon: Icon(Icons.arrow_downward,
                                      color: primaryColor),
                                  onPressed: () => navigateToResult(1),
                                  tooltip: 'Next result',
                                ),
                              ],
                            )
                          : null,
                      hintStyle: TextStyle(color: primaryColor),
                    ),
                    style: TextStyle(color: primaryColor),
                    onChanged: searchMessages,
                  ),
                ),
              ],
            );
          },
        ),
        Expanded(
          child: ScrollablePositionedList.builder(
            reverse: true,
            itemScrollController: itemScrollController,
            itemCount: widget.messages.length,
            itemBuilder: (context, index) {
              return _buildMessageItem(widget.messages[index], index);
            },
          ),
        ),
      ],
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
