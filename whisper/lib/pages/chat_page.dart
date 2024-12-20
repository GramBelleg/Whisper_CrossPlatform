import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whisper/components/custom_chat_text_field.dart';
import 'package:whisper/components/gif_picker.dart';
import 'package:whisper/components/reply_preview.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/components/sticker_picker.dart';
import 'package:whisper/cubit/messages_cubit.dart';
import 'package:whisper/cubit/messages_state.dart';
// import 'package:whisper/global_cubit_provider.dart';
import 'package:whisper/keys/chat_page_keys.dart';
import 'package:whisper/global_cubits/global_cubit_provider.dart';
import 'package:whisper/models/chat_message.dart';
import 'package:whisper/models/chat_message_manager.dart';
import 'package:whisper/models/parent_message.dart';
import 'package:whisper/components/custom_app_bar.dart';
import 'package:whisper/components/emoji_select.dart';
import 'package:whisper/components/message_list.dart';
import 'package:whisper/services/fetch_chat_messages.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:path_provider/path_provider.dart';
import 'package:whisper/services/upload_file.dart';
import 'package:vibration/vibration.dart';

class ChatPage extends StatefulWidget {
  static const String id = 'chat_page'; // Define the static id here
  final int ChatID;
  final String userName;
  final String? userImage;
  final String? token;
  final int? senderId;
  final String? chatType;
  final bool isAdmin;
  const ChatPage({
    super.key,
    required this.userName,
    required this.userImage,
    required this.ChatID,
    required this.token,
    required this.senderId,
    required this.chatType,
    required this.isAdmin,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  TextAlign _textAlign = TextAlign.left; // Default text alignment
  TextDirection _textDirection = TextDirection.ltr; // Default text direction
  bool _isTyping = false;
  bool showEmojiPicker = false; // Tracks if the emoji picker is visible
  bool showGifPicker = false; // Tracks if the gif picker is visible
  bool showStickerPicker = false; // Tracks if the sticker picker is visible
  FocusNode focusNode = FocusNode(); // FocusNode for the TextFormField
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollController2 = ScrollController();
  final GlobalKey<FormFieldState<String>> _textFieldKey =
      GlobalKey<FormFieldState<String>>();
  int lastVisibleMessageIndex = 0;
  List<int> isSelectedList = [];
  ChatMessageManager chatMessageManager = ChatMessageManager();
  ParentMessage? _replyingTo; // Stores the message being replied to
  bool _isReplying = false; // Tracks if in reply mode
  double paddingSpaceForReplay = 0;

  // Voice Recording Utilities
  bool _isRecording = false;
  String? currentlyPlayingBlobName;
  RecorderController recorderController = RecorderController();
  bool _isEditing = false;
  String _editingMessage = "";
  int _editingMessageId = 0;
  late PlayerController globalPlayerController;

  @override
  void initState() {
    super.initState();
    GlobalCubitProvider.messagesCubit.loadMessages(widget.ChatID);
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          showEmojiPicker = false;
          showGifPicker = false;
          showStickerPicker = false;
          isSelectedList.clear();
        });
      }
    });
    globalPlayerController = PlayerController();
  }

  @override
  void dispose() {
    _controller.dispose();
    focusNode.dispose();
    recorderController.dispose();
    globalPlayerController.dispose();
    super.dispose();
  }

  void _updateTextProperties(String text) {
    if (text.isNotEmpty && RegExp(r'[\u0600-\u06FF]').hasMatch(text)) {
      setState(() {
        _textAlign = TextAlign.right;
        _textDirection = TextDirection.rtl;
      });
    } else {
      setState(() {
        _textAlign = TextAlign.left;
        _textDirection = TextDirection.ltr;
      });
    }
    setState(() {
      _isTyping = text.trim() != '';
    });
    _editingMessage = "";
  }

  void _toggleEmojiPicker() {
    if (showEmojiPicker) {
      focusNode.requestFocus();
    } else {
      focusNode.unfocus();
    }
    setState(() {
      showEmojiPicker = !showEmojiPicker;
      showGifPicker = false;
      showStickerPicker = false;
      isSelectedList.clear();
    });
  }

  void _toggleGifPicker() {
    if (showGifPicker) {
      focusNode.requestFocus();
    } else {
      focusNode.unfocus();
    }
    setState(() {
      showGifPicker = !showGifPicker;
      showEmojiPicker = false;
      showStickerPicker = false;
      isSelectedList.clear();
    });
  }

  void _toggleStickerPicker() {
    if (showStickerPicker) {
      focusNode.requestFocus();
    } else {
      focusNode.unfocus();
    }
    setState(() {
      showStickerPicker = !showStickerPicker;
      showEmojiPicker = false;
      showGifPicker = false;
      isSelectedList.clear();
    });
  }

  void clearIsSelected() {
    setState(() {
      isSelectedList.clear();
    });
  }

  double getContainerHeight(BuildContext context) {
    double height;
    if (showEmojiPicker) {
      height = MediaQuery.of(context).size.height - 400;
    } else if (MediaQuery.of(context).viewInsets.bottom != 0) {
      height = MediaQuery.of(context).size.height - 450;
    } else {
      height = MediaQuery.of(context).size.height - 145;
    }
    return height;
  }

  void handleLongPressSelection(ChatMessage messageData) {
    if (messageData.id != null) {
      setState(() {
        if (!isSelectedList.contains(messageData.id!)) {
          isSelectedList.add(messageData.id!);
        }
      });
    }
  }

  void handleOnTapSelection(ChatMessage messageData) {
    if (messageData.id != null) {
      setState(() {
        if (isSelectedList.contains(messageData.id!)) {
          isSelectedList.remove(messageData.id!);
        } else if (!isSelectedList.isEmpty) {
          isSelectedList.add(messageData.id!);
        }
      });
    }
  }

  void handleOnRightSwipe(ChatMessage messageData) {
    setState(() {
      _isReplying = true;
      _replyingTo = ParentMessage(
          id: messageData.id!,
          content: messageData.content,
          senderName: messageData.sender!.userName);
    });
  }

  void handleOncancelReply() {
    print("cancel reply");
    setState(() {
      _isReplying = false;
      _replyingTo = null;
      paddingSpaceForReplay = 0;
    });
  }

  void handleSendMessage() {
    if (_isTyping) {
      GlobalCubitProvider.messagesCubit.sendMessage(
        content: _controller.text.trim(),
        chatId: widget.ChatID,
        senderId: widget.senderId!,
        parentMessage: _replyingTo,
        senderName: widget.userName,
        isReplying: _isReplying,
        isForward: false,
        type: "TEXT",
      );
      setState(() {
        _isTyping = false;
      });
      _controller.clear();
      handleOncancelReply();
    } else {}
  }

  void handleEditMessage() {
    if (_controller.text.trim() == '') {
      Vibration.vibrate(duration: 200);
      return;
    }
    GlobalCubitProvider.messagesCubit.emitEditMessage(
      _editingMessageId,
      widget.ChatID,
      _controller.text.trim(),
    );
    handleCancelEditing();
  }

  void handleEditingMessage(String content, int messageId) {
    _isEditing = true;
    _editingMessage = content;
    _editingMessageId = messageId;
  }

  void handleCancelEditing() {
    setState(() {
      _isEditing = false;
      _editingMessage = "";
      _editingMessageId = 0;
      _controller.clear();
    });
  }

  void startRecording() async {
    try {
      bool permission = await recorderController.checkPermission();
      final downloadsDirectory = await getExternalStorageDirectory();
      if (permission) {
        await recorderController.record(
          path:
              '${downloadsDirectory!.path}/whisper_record_${DateTime.now().millisecondsSinceEpoch}.m4a',
          bitRate: 128000,
          sampleRate: 44100,
        );
      }
    } catch (e) {
      if (kDebugMode) print("Failed to start recording: $e");
    }
  }

  void stopRecording() async {
    final path = await recorderController.stop();
    if (kDebugMode) print("Recording saved at: $path");
    // Send the audio file or save it in the chat
    if (path != null) {
      final blobName = await uploadFile(path);
      if (kDebugMode) print("UPLOADED FILE NOW WITH BLOBNAME = $blobName");
      if (blobName != 'Failed') {
        GlobalCubitProvider.messagesCubit.sendMessage(
          extension: path.split('.').last,
          content: blobName,
          chatId: widget.ChatID,
          senderId: widget.senderId!,
          parentMessage: _replyingTo,
          senderName: widget.userName,
          isReplying: _isReplying,
          isForward: false,
          type: "VM",
          media: blobName,
        );
      }
    }
  }

  void onPlay(String blobName) {
    if (currentlyPlayingBlobName != null &&
        currentlyPlayingBlobName != blobName) {
      globalPlayerController.pausePlayer();
    }
    setState(() {
      currentlyPlayingBlobName = blobName;
    });
  }

  void handleGifSend(String gifUrl) async {
    GlobalCubitProvider.messagesCubit.sendMessage(
      extension: "gif",
      content: gifUrl,
      chatId: widget.ChatID,
      senderId: widget.senderId!,
      parentMessage: _replyingTo,
      senderName: widget.userName,
      isReplying: _isReplying,
      isForward: false,
      type: "GIF",
      media: gifUrl, //TODO: recheck this
    );
    setState(() {
      showGifPicker = true;
    });
  }

  void handleStickerSend(String blobName) async {
    GlobalCubitProvider.messagesCubit.sendMessage(
      extension: "sticker",
      content: blobName,
      chatId: widget.ChatID,
      senderId: widget.senderId!,
      parentMessage: _replyingTo,
      senderName: widget.userName,
      isReplying: _isReplying,
      isForward: false,
      type: "STICKER",
      media: blobName, //TODO: recheck this
    );
    setState(() {
      showStickerPicker = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          isAdmin: widget.isAdmin,
          isSelected: isSelectedList,
          userImage: widget.userImage,
          userName: widget.userName,
          clearSelection: clearIsSelected,
          chatId: widget.ChatID,
          chatViewModel: ChatViewModel(),
          deleteDisable:
              widget.chatType == "CHANNEL" && widget.isAdmin == false,
          editable: isSelectedList.length == 1 &&
              isSelectedList.first != null &&
              chatMessageManager.messages.any((message) =>
                  message.id == isSelectedList.first &&
                  message.sender?.id == widget.senderId &&
                  chatMessageManager.messages
                          .firstWhere((msg) => msg.id == message.id)
                          .type ==
                      "TEXT"),
          chatType: widget.chatType!,
        ),
        body: BlocProvider<MessagesCubit>.value(
          value: GlobalCubitProvider.messagesCubit,
          child: BlocListener<MessagesCubit, MessagesState>(
              listener: (context, state) {
                setState(() {
                  chatMessageManager.handleMessagesState(
                      context,
                      state,
                      widget.ChatID,
                      widget.userName,
                      widget.senderId!,
                      handleOncancelReply,
                      handleCancelEditing,
                      handleEditingMessage);
                });
              },
              child: Container(
                color: const Color(0xff0a254a),
                child: WillPopScope(
                  child: Stack(children: [
                    SvgPicture.asset(
                      'assets/images/chat-page-back-ground-image.svg',
                      fit: BoxFit.cover,
                    ),
                    Column(
                      children: [
                        Expanded(
                          // height: getContainerHeight(context),
                          child: Padding(
                              padding: EdgeInsets.only(
                                  bottom: paddingSpaceForReplay),
                              child: MessageList(
                                // scrollController: _scrollController2,
                                messages: chatMessageManager.messages,
                                onLongPress: handleLongPressSelection,
                                onTap: handleOnTapSelection,
                                onRightSwipe: handleOnRightSwipe,
                                isSelectedList: isSelectedList,
                                senderId: widget.senderId!,
                                playerController: globalPlayerController,
                                onPlay: onPlay,
                                isChannel: widget.chatType == "CHANNEL",
                              )),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ReplyPreview(
                                isReplying: _isReplying,
                                senderName: widget.userName,
                                content: _replyingTo?.content ?? '',
                                onCancelReply: () {
                                  handleOncancelReply();
                                },
                              ),
                              (!widget.isAdmin && widget.chatType == "CHANNEL")
                                  ? Container()
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              55,
                                          child: Card(
                                              margin: const EdgeInsets.only(
                                                  left: 5, right: 5, bottom: 8),
                                              child: _isRecording
                                                  ? AudioWaveforms(
                                                      recorderController:
                                                          recorderController,
                                                      size: Size(
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                          50.0),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            firstNeutralColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      waveStyle: WaveStyle(
                                                        waveColor: primaryColor,
                                                        extendWaveform: true,
                                                        showMiddleLine: false,
                                                      ),
                                                    )
                                                  : CustomChatTextField(
                                                      key: Key(ChatPageKeys
                                                          .textField),
                                                      scrollController:
                                                          _scrollController,
                                                      focusNode: focusNode,
                                                      controller: _controller,
                                                      onChanged:
                                                          _updateTextProperties,
                                                      textAlign: _textAlign,
                                                      textDirection:
                                                          _textDirection,
                                                      toggleEmojiPicker:
                                                          _toggleEmojiPicker,
                                                      toggleGifPicker:
                                                          _toggleGifPicker,
                                                      toggleStickerPicker:
                                                          _toggleStickerPicker,
                                                      chatId: widget.ChatID,
                                                      senderId:
                                                          widget.senderId!,
                                                      userName: widget.userName,
                                                      parentMessage:
                                                          _replyingTo,
                                                      isReplying: _isReplying,
                                                      handleOncancelReply:
                                                          handleOncancelReply,
                                                      isEditing: _isEditing,
                                                      editingMessage:
                                                          _editingMessage,
                                                      handleCancelEditing:
                                                          handleCancelEditing,
                                                    )),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(bottom: 5),
                                          child: CircleAvatar(
                                            radius: 24,
                                            backgroundColor: firstNeutralColor,
                                            child: _isRecording && !_isTyping
                                                ? IconButton(
                                                    key: Key(ChatPageKeys
                                                        .stopRecordButton),
                                                    onPressed: () {
                                                      setState(() {
                                                        stopRecording();
                                                        _isRecording = false;
                                                      });
                                                    },
                                                    icon: FaIcon(
                                                      FontAwesomeIcons.stop,
                                                      color: primaryColor,
                                                    ),
                                                  )
                                                : _isEditing
                                                    ? IconButton(
                                                        key: Key(ChatPageKeys
                                                            .editMessageButton),
                                                        onPressed: () {
                                                          handleEditMessage();
                                                        },
                                                        icon: FaIcon(
                                                          FontAwesomeIcons
                                                              .check,
                                                          color: primaryColor,
                                                        ),
                                                      )
                                                    : _isTyping
                                                        ? IconButton(
                                                            key: Key(ChatPageKeys
                                                                .sendButton),
                                                            onPressed: () {
                                                              handleSendMessage();
                                                            },
                                                            icon: FaIcon(
                                                              FontAwesomeIcons
                                                                  .paperPlane,
                                                              color:
                                                                  primaryColor,
                                                            ),
                                                          )
                                                        : IconButton(
                                                            key: Key(ChatPageKeys
                                                                .recordButton),
                                                            onPressed: () {
                                                              setState(() {
                                                                startRecording();
                                                                _isRecording =
                                                                    true;
                                                                _isTyping =
                                                                    false;
                                                              });
                                                            },
                                                            icon: FaIcon(
                                                              FontAwesomeIcons
                                                                  .microphone,
                                                              color:
                                                                  primaryColor,
                                                            ),
                                                          ),
                                          ),
                                        ),
                                      ],
                                    ),
                              showEmojiPicker
                                  ? EmojiSelect(
                                      key: Key(ChatPageKeys.emojiPicker),
                                      controller: _controller,
                                      scrollController: _scrollController,
                                      onTypingStatusChanged: (isTyping) {
                                        setState(() {
                                          _isTyping = isTyping;
                                        });
                                      })
                                  : showGifPicker
                                      ? GifPicker(onGifSelected: handleGifSend)
                                      : showStickerPicker
                                          ? StickerPicker(
                                              onStickerSelected:
                                                  handleStickerSend)
                                          : Container()
                            ],
                          ),
                        ),
                      ],
                    ),
                  ]),
                  onWillPop: () {
                    if (showEmojiPicker | showGifPicker | showStickerPicker) {
                      setState(() {
                        showEmojiPicker = false;
                        showGifPicker = false;
                        showStickerPicker = false;
                      });
                    } else {
                      Navigator.pop(context);
                    }
                    return Future.value(false);
                  },
                ),
              )),
        ));
  }
}
