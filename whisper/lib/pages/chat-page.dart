import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whisper/bloc/chat-bloc.dart';
import 'package:whisper/bloc/chat-event.dart';
import 'package:whisper/bloc/chat-state.dart';
import 'package:whisper/modules/button-sheet.dart';
import 'package:whisper/modules/custom-app-bar.dart';
import 'package:whisper/modules/emoji-button-sheet.dart';
import 'package:whisper/modules/emoji-select.dart';
import 'package:whisper/modules/own-message-card.dart';
import 'package:whisper/modules/recieved-message-card.dart';
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
  late ChatBloc _chatBloc;
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
  List<int> isSelected = [];
  // late IO.Socket socket;
  List<ChatMessage> fetchedmessages = []; // fetch messages
  List<ChatMessage> messages = [];

  List<RecievedMessageCard> recievedmessages = [];
  List<DateTime> sendMessagesTime = [];

  @override
  void initState() {
    super.initState();
    _chatBloc = ChatBloc();
    if (widget.token != null && widget.token!.isNotEmpty) {
      try {
        _chatBloc.add(ConnectSocket(widget.token!));
      } catch (e) {
        print("Error connecting to socket: $e");
      }
    } else {
      print("Token is null or empty");
    }

    _chatBloc.add(LoadMessages(widget.ChatID!)); // Load previous messages

    // Listen for incoming messages
    _chatBloc.stream.listen((state) {
      if (state is MessagesLoaded) {
        setState(() {
          messages = state.messages; // Update the messages state
        });
      } else if (state is MessageAdded) {
        print("message receive ${state.message}");
        setState(() {
          // messages.add(state.message); // Add new message to the list
        });
      } else if (state is MessageUpdated) {
        print("message receive ${state.message}");
        // Update existing message in the list if necessary
        int index = messages.indexWhere((msg) => msg.id == state.message.id);
        if (index != -1) {
          setState(() {
            messages[index] = state.message; // Update the message
          });
        }
      }
      _scrollToBottom(messages.length * 75);
    });

    // Scroll to the bottom on widget build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom(0);
    });

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          show = false; // Hide emoji picker when the text field is focused
          isSelected.clear();
        });
      }
    });
// Listen for incoming messages from the server
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom(0);
    });
  }

  @override
  void dispose() {
    _chatBloc.close();
    _controller.dispose(); // Dispose of the controller
    focusNode.dispose(); // Dispose of the focusNode

    if (_chatBloc.socket!.connected) {
      _chatBloc.socket?.disconnect();
    }
    super.dispose();
  }

  void _updateTextProperties(String text) {
    // Update text alignment and direction based on the content
    if (text.isNotEmpty && RegExp(r'[\u0600-\u06FF]').hasMatch(text)) {
      setState(() {
        _textAlign = TextAlign.right; // Right to Left for Arabic
        _textDirection = TextDirection.rtl; // Set text direction to RTL
      });
    } else {
      setState(() {
        _textAlign = TextAlign.left; // Left to Right for English
        _textDirection = TextDirection.ltr; // Set text direction to LTR
      });
    }

    // Update the typing status based on the text input
    setState(() {
      _isTyping = text.isNotEmpty; // Check if the text field is not empty
    });

    // Calculate the number of lines in the text field
    int numberOfLines =
        (text.split('\n').length).clamp(1, 5); // Minimum 1, maximum 5
    double additionalHeight = numberOfLines * 40; // Height for the lines

    // Calculate the new scroll position based on the additional height
    if (_scrollController2.hasClients) {
      double lastMessagePosition =
          _scrollController2.position.maxScrollExtent + 100 + additionalHeight;

      // Animate scroll to the last message considering the additional height
      _scrollController2.animateTo(
        lastMessagePosition,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // Toggle emoji picker and keyboard
  void _toggleEmojiPicker() {
    if (show) {
      focusNode.requestFocus(); // Show the keyboard when hiding emoji picker
    } else {
      focusNode.unfocus(); // Hide the keyboard when showing emoji picker
    }
    setState(() {
      show = !show; // Toggle the emoji picker
      isSelected.clear();
    });
  }

  void _scrollToBottom(double additional) {
    // Check if the first scroll controller is attached and has clients
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }

    // Check if the second scroll controller is attached and has clients
    if (_scrollController.hasClients) {
      // Assuming the last message is stored in a variable called `messages`
      String lastMessage = messages.isNotEmpty ? messages.last.content : '';

      // Count the number of lines in the last message
      int lastMessageLines = lastMessage.split('\n').length;

      // Calculate additional height based on the number of lines and the passed additional value
      double additionalHeight = (lastMessageLines * 50) +
          40 +
          additional; // Assuming each line takes 50 pixels

      print(additionalHeight);

      // Calculate the target scroll position
      double targetPosition =
          _scrollController2.position.maxScrollExtent + additionalHeight;

      // Scroll to the target position
      _scrollController2.animateTo(
        targetPosition,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void clearIsSelected() {
    setState(() {
      isSelected.clear();
    });
  }

  void _getTextFieldPosition() {
    // Check if the key has a current context
    if (_textFieldKey.currentContext != null) {
      final RenderBox renderBox =
          _textFieldKey.currentContext!.findRenderObject() as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero); // Get the position
      print("TextField Position: ${position.dx}, ${position.dy}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => _chatBloc,
        child: Scaffold(
            appBar: CustomAppBar(
              isSelected: isSelected,
              userImage: widget.userImage,
              userName: widget.userName,
              clearSelection: clearIsSelected,
            ),
            body: Container(
              color: const Color(0xff0a254a),
              child: WillPopScope(
                child: Stack(
                  children: [
                    SvgPicture.asset(
                      'assets/images/chat-page-back-ground-image.svg',
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      height: show
                          ? MediaQuery.of(context).size.height - 400
                          : MediaQuery.of(context).viewInsets.bottom != 0
                              ? MediaQuery.of(context).size.height - 450
                              : MediaQuery.of(context).size.height - 145,
                      child: BlocBuilder<ChatBloc, SocketState>(
                          builder: (context, state) {
                        return ListView.builder(
                          controller: _scrollController2,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final messageData = messages[index];
                            print(messageData.content);
                            return messageData.senderId == widget.senderId
                                ? GestureDetector(
                                    onLongPress: () {
                                      setState(() {
                                        isSelected.add(messageData
                                            .id!); // Add the index to isSelected list
                                      });
                                    },
                                    onTap: () {
                                      setState(() {
                                        // Check if the index exists in the isSelected list
                                        if (isSelected
                                            .contains(messageData.id!)) {
                                          // If it exists, remove it
                                          isSelected.remove(messageData.id!);
                                        }
                                      });
                                    },
                                    child: OwnMessageCard(
                                      message: messageData.content,
                                      time: messageData.time!,
                                      status: MessageStatus
                                          .sent, // need modification
                                      isSelected:
                                          isSelected.contains(messageData.id!),
                                    ),
                                  )
                                : RecievedMessageCard(
                                    message: messageData.content,
                                    time: messageData.time!);
                          },
                        );
                      }),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width - 55,
                                child: Card(
                                  margin: const EdgeInsets.only(
                                      left: 5, right: 5, bottom: 8),
                                  child: TextFormField(
                                    onTap: () {
                                      _scrollToBottom(200);
                                    },
                                    scrollController: _scrollController,

                                    focusNode: focusNode,
                                    textAlignVertical: TextAlignVertical.center,
                                    keyboardType: TextInputType.multiline,
                                    minLines: 1,
                                    maxLines: 5,
                                    controller: _controller,
                                    textAlign: _textAlign, // Set text alignment
                                    textDirection:
                                        _textDirection, // Set text direction
                                    style: const TextStyle(color: Colors.white),
                                    onChanged:
                                        _updateTextProperties, // Update text alignment on change
                                    decoration: InputDecoration(
                                      fillColor: const Color(
                                          0xff0A122F), // Background color
                                      filled:
                                          true, // Enable filling the background color
                                      hintText: "Message Here",
                                      hintStyle: const TextStyle(
                                          color: Colors.white54),
                                      contentPadding: const EdgeInsets.all(5),
                                      prefixIcon: IconButton(
                                        onPressed: () {
                                          if (show) {
                                            focusNode.requestFocus();
                                            show != show;

                                            print("daaaaaaaaa");
                                          } else {
                                            showModalBottomSheet(
                                                backgroundColor:
                                                    Colors.transparent,
                                                context: context,
                                                builder: (builder) =>
                                                    EmojiButtonSheet(
                                                        onEmojiTap: () {
                                                          // Hide the button sheet
                                                          Navigator.pop(
                                                              context);
                                                          // Show the emoji picker

                                                          _toggleEmojiPicker();
                                                          _scrollToBottom(170);
                                                        },
                                                        onStickerTap: () {},
                                                        onGifTap: () {}));
                                          }
                                        },
                                        icon: FaIcon(
                                          show
                                              ? FontAwesomeIcons.keyboard
                                              : FontAwesomeIcons.smile,
                                          color: const Color(
                                              0xff8D6AEE), // Consistent icon color
                                        ),
                                      ),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          showModalBottomSheet(
                                              backgroundColor:
                                                  Colors.transparent,
                                              context: context,
                                              builder: (builder) =>
                                                  FileButtonSheet());
                                        },
                                        icon: const FaIcon(
                                          FontAwesomeIcons.paperclip,
                                          color: Color(0xff8D6AEE),
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            10), // Set border radius to 10
                                        borderSide: BorderSide
                                            .none, // Remove the border line
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            10), // Set border radius for focused state
                                        borderSide: BorderSide
                                            .none, // Remove the border line
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            10), // Set border radius for enabled state
                                        borderSide: BorderSide
                                            .none, // Remove the border line
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 5),
                                child: CircleAvatar(
                                  radius: 24,
                                  backgroundColor: Color(0xff0A122F),
                                  child: IconButton(
                                    onPressed: () {
                                      if (_isTyping) {
                                        print("hey");
                                        _chatBloc.add(SendMessage(
                                            _controller.text,
                                            widget.ChatID,
                                            widget.senderId));

                                        _controller
                                            .clear(); // Clear the text field after sending
                                        setState(() {
                                          _isTyping =
                                              false; // Reset typing status
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
                          // Display emoji picker if `show` is true
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
            )));
  }
}
