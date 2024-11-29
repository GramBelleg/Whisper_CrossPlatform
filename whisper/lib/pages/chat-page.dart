import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:whisper/components/custom-chat-text-field.dart';
import 'package:whisper/components/reply-preview.dart';
import 'package:whisper/cubit/messages-cubit.dart';
import 'package:whisper/cubit/messages-state.dart';
import 'package:whisper/global-cubit-provider.dart';
import 'package:whisper/models/chat-messages.dart';
import 'package:whisper/models/parent-message.dart';
import 'package:whisper/modules/button-sheet.dart';
import 'package:whisper/modules/custom-app-bar.dart';
import 'package:whisper/modules/emoji-button-sheet.dart';
import 'package:whisper/modules/emoji-select.dart';
import 'package:whisper/modules/message-list.dart';
import 'package:whisper/modules/own-message/file-message-card.dart';
import 'package:whisper/modules/receive-message/forwarded-received-message-card.dart';
import 'package:whisper/modules/receive-message/normal-received-message-card.dart';
import 'package:whisper/modules/own-message/forwarded-message-card.dart';
import 'package:whisper/modules/own-message/normal-message-card.dart';
import 'package:whisper/modules/own-message/own-message.dart';
import 'package:whisper/modules/own-message/replied-message-card.dart';
import 'package:whisper/modules/receive-message/replied-received-message-card.dart';
import 'package:whisper/services/fetch-messages.dart';

class ChatPage extends StatefulWidget {
  static const String id = 'chat_page'; // Define the static id here
  final int ChatID;
  final String userName;
  final String userImage;
  final String? token;
  final int? senderId;

  const ChatPage({
    super.key,
    required this.userName,
    required this.userImage,
    required this.ChatID,
    required this.token,
    required this.senderId,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController _controller = TextEditingController();
  TextAlign _textAlign = TextAlign.left; // Default text alignment
  TextDirection _textDirection = TextDirection.ltr; // Default text direction
  bool _isTyping = false;
  bool show = false; // Tracks if the emoji picker is visible
  FocusNode focusNode = FocusNode(); // FocusNode for the TextFormField
  ScrollController _scrollController = ScrollController();
  ScrollController _scrollController2 = ScrollController();
  final GlobalKey<FormFieldState<String>> _textFieldKey =
      GlobalKey<FormFieldState<String>>();
  int lastVisibleMessageIndex = 0;
  List<int> isSelectedList = [];
  List<ChatMessage> messages = [];
  ParentMessage? _replyingTo; // Stores the message being replied to
  bool _isReplying = false; // Tracks if in reply mode
  double paddingSpaceForReplay = 0;

  @override
  void initState() {
    super.initState();
    GlobalCubitProvider.messagesCubit.loadMessages(widget.ChatID);
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          show = false;
          isSelectedList.clear();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    focusNode.dispose();
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
      _isTyping = text.isNotEmpty;
    });
  }

  void _toggleEmojiPicker() {
    if (show) {
      focusNode.requestFocus();
    } else {
      focusNode.unfocus();
    }
    setState(() {
      show = !show;
      isSelectedList.clear();
    });
  }

  void clearIsSelected() {
    setState(() {
      isSelectedList.clear();
    });
  }

  void _handleMessagesState(BuildContext context, MessagesState state) {
    if (state is MessagesLoading) {
      print("loading");
    } else if (state is MessageFetchedSuccessfully) {
      setState(() {
        messages = state.messages;
        messages = messages.reversed.toList();
      });
    } else if (state is MessageFetchedWrong) {
      print("erroor");
    } else if (state is MessageSent) {
      setState(() {
        if (state.message.chatId == widget.ChatID) {
          messages.insert(0, state.message);
        }
      });
    } else if (state is MessageReceived) {
      print("received");
      setState(() {
        paddingSpaceForReplay = 0;
        _isReplying = false;
      });
      DateTime receivedTime = state.message.time!.toLocal();
      int index = messages.indexWhere((msg) => msg.sentAt == receivedTime);
      if (state.message.chatId == widget.ChatID) {
        if (index != -1) {
          setState(() {
            messages[index] = state.message;
          });
        } else {
          setState(() {
            messages.insert(0, state.message);
          });
        }
      }
    } else if (state is MessagesDeletedSuccessfully) {
      setState(() {
        messages.removeWhere((msg) => state.deletedIds.contains(msg.id));
      });
    } else if (state is MessagesDeleteError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting message: ${state.error}')),
      );
    }
  }

  double getContainerHeight(BuildContext context) {
    double height;
    if (show) {
      height = MediaQuery.of(context).size.height - 400;
    } else if (MediaQuery.of(context).viewInsets.bottom != 0) {
      height = MediaQuery.of(context).size.height - 450;
    } else {
      height = MediaQuery.of(context).size.height - 145;
    }
    return height;
  }

  void handleLongPressSelection(ChatMessage messageData) {
    setState(() {
      if (!isSelectedList.contains(messageData.id!)) {
        isSelectedList.add(messageData.id!);
      }
    });
  }

  void handleOnTapSelection(ChatMessage messageData) {
    setState(() {
      if (isSelectedList.contains(messageData.id!)) {
        isSelectedList.remove(messageData.id!);
      } else if (!isSelectedList.isEmpty) {
        isSelectedList.add(messageData.id!);
      }
    });
  }

  void handleOnRightSwipe(ChatMessage messageData) {
    setState(() {
      _isReplying = true;
      _replyingTo = ParentMessage(
          id: messageData.id!,
          content: messageData.content,
          senderName: messageData.sender!.userName);
      paddingSpaceForReplay = 70;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          isSelected: isSelectedList,
          userImage: widget.userImage,
          userName: widget.userName,
          clearSelection: clearIsSelected,
          chatId: widget.ChatID,
          chatViewModel: ChatViewModel(),
        ),
        body: BlocProvider<MessagesCubit>.value(
          value: GlobalCubitProvider.messagesCubit,
          child: BlocListener<MessagesCubit, MessagesState>(
              listener: (context, state) {
                _handleMessagesState(context, state);
              },
              child: Container(
                color: const Color(0xff0a254a),
                child: WillPopScope(
                  child: Stack(
                    children: [
                      SvgPicture.asset(
                        'assets/images/chat-page-back-ground-image.svg',
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.fill, //Todo check in disktop
                      ),
                      Column(
                        children: [
                          Container(
                            height: getContainerHeight(context),
                            child: Padding(
                                padding: EdgeInsets.only(
                                    bottom: paddingSpaceForReplay),
                                child: MessageList(
                                  scrollController: _scrollController2,
                                  messages: messages,
                                  onLongPress: handleLongPressSelection,
                                  onTap: handleOnTapSelection,
                                  onRightSwipe: handleOnRightSwipe,
                                  isSelectedList: isSelectedList,
                                  senderId: widget.senderId!,
                                )),
                          ),
                        ],
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
                                setState(() {
                                  _isReplying = false;
                                  _replyingTo = null;
                                  paddingSpaceForReplay = 0;
                                });
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width - 55,
                                  child: Card(
                                      margin: const EdgeInsets.only(
                                          left: 5, right: 5, bottom: 8),
                                      child: CustomChatTextField(
                                        scrollController: _scrollController,
                                        focusNode: focusNode,
                                        controller: _controller,
                                        onChanged: _updateTextProperties,
                                        textAlign: _textAlign,
                                        textDirection: _textDirection,
                                        toggleEmojiPicker: _toggleEmojiPicker,
                                        chatId: widget.ChatID,
                                        senderId: widget.senderId!,
                                        userName: widget.userName,
                                        parentMessage: _replyingTo,
                                        isReplying: _isReplying,
                                      )),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 5),
                                  child: CircleAvatar(
                                    radius: 24,
                                    backgroundColor: Color(0xff0A122F),
                                    child: IconButton(
                                      onPressed: () {
                                        if (_isTyping) {
                                          GlobalCubitProvider.messagesCubit
                                              .sendMessage(
                                            content: _controller.text,
                                            chatId: widget.ChatID,
                                            senderId: widget.senderId!,
                                            parentMessage: _replyingTo,
                                            senderName: widget.userName,
                                            isReplying: _isReplying,
                                            isForward: false,
                                          );
                                          _controller.clear();
                                          setState(() {
                                            _isTyping = false;
                                            _isReplying = false;
                                            _replyingTo = null;
                                          });
                                        } else {}
                                      },
                                      icon: FaIcon(
                                        _isTyping
                                            ? FontAwesomeIcons.paperPlane
                                            : FontAwesomeIcons.microphone,
                                        color: Color(0xff8D6AEE),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            show
                                ? EmojiSelect(
                                    controller: _controller,
                                    scrollController: _scrollController,
                                    onTypingStatusChanged: (isTyping) {
                                      setState(() {
                                        _isTyping = isTyping;
                                      });
                                    })
                                : Container()
                          ],
                        ),
                      ),
                    ],
                  ),
                  onWillPop: () {
                    if (show) {
                      setState(() {
                        show = false;
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
