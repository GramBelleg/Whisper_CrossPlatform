import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whisper/components/message.dart';
import 'package:whisper/modules/button-sheet.dart';
import 'package:whisper/modules/custom-app-bar.dart';
import 'package:whisper/modules/emoji-button-sheet.dart';
import 'package:whisper/modules/emoji-select.dart';
import 'package:whisper/modules/own-message-card.dart';
import 'package:whisper/modules/recieved-message-card.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:whisper/services/fetch-messages.dart';
import 'package:whisper/services/shared-preferences.dart';

class ChatPage extends StatefulWidget {
  static const String id = 'chat_page'; // Define the static id here

  final int ChatID;
  final String userName;
  final String userImage;

  const ChatPage({
    super.key,
    required this.userName,
    required this.userImage,
    required this.ChatID,
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
  List<int> isSelected = [];
  late IO.Socket socket;
  List<ChatMessage> fetchedmessages = []; // fetch messages
  List<Message> messages = [];
  List<RecievedMessageCard> recievedmessages = [];
  @override
  void initState() {
    super.initState();
    connect();
    loadMessages();
    // Add a listener to the focusNode to hide the emoji picker when the text field is focused
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

    // Listen for loading existing messages
    socket.on('loadMessages', (data) {
      print("Loading messages: $data");

      // Update the UI with the existing messages
      setState(() {
        for (var msg in data) {
          recievedmessages.add(RecievedMessageCard(
            message: msg['message'],
            time: msg['time'],
          ));
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller
    focusNode.dispose(); // Dispose of the focusNode
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
    if (_scrollController2.hasClients) {
      // Assuming the last message is stored in a variable called `messages`
      String lastMessage = messages.isNotEmpty ? messages.last.data : '';

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

  Future<void> loadMessages() async {
    try {
      List<ChatMessage> chatMessages = await fetchChatMessages(widget.ChatID);
      //print(chatMessages);
      print("jjj");
      setState(() {
        // Transform the fetched messages into the Message class used in your app
        for (var chatMessage in chatMessages) {
          // Check if the senderId is 7, and use that to determine the message type
          bool isSentByCurrentUser = chatMessage.senderId == 7;

          // Format the time for the message
          String formattedTime =
              '${chatMessage.createdAt.hour.toString().padLeft(2, '0')}:${chatMessage.createdAt.minute.toString().padLeft(2, '0')}';

          // Add the message in your app's format
          messages.add(
            Message(
                chatMessage.content, // Use the content from the fetched message
                formattedTime, // Use the formatted time
                isSentByCurrentUser, // True if sent by current user (senderId == 7)
                MessageStatus.sent),
          );
        }
      });

      // After messages have been updated, ensure the UI has rebuilt, then scroll to bottom
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom(0);
      });
    } catch (e) {
      print("Error loading messages: $e");
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

  void connect() {
    // Replace with your server's IP and port
    socket = IO.io("http://172.20.192.1:5000", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });

    socket.connect();

    // Listen for successful connection
    socket.on('connect', (_) {
      print("Connected to server");
    });

    // Listen for incoming messages from the server
    socket.on('receive', (data) {
      print("Message received: $data");
      //print("hey");
      DateTime now = DateTime.now();
      String formattedTime =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

      // Update the UI with the received message
      setState(() {
        messages.add(
            Message(data['content'], formattedTime, false, MessageStatus.sent));
        _scrollToBottom(40);
      });
    });

    // You need to update your UI with the received message
    // For example, you can add the message to a List and rebuild the chat

    // Emit a test message when connected
    //socket.emit('/sendmessage', "Client connected");
  }

  void _sendMessage(String inputMessage) {
    if (inputMessage.isNotEmpty) {
      // Get the current time
      DateTime now = DateTime.now();

      // Format the time manually
      String formattedTime =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

      // Define the message structure
      const int chatId = 4;
      Map<String, dynamic> messageData = {
        'content': inputMessage,
        'chatId': chatId,
        'type': 'TEXT',
        'forwarded': false,
        'selfDestruct': true,
        'expiresAfter': 5, // in minutes
        'parentMessageId': null
      };

      // Emit the message via socket
      socket.emit('send', messageData);
      print('Message sent: $messageData');

      // Update your UI with the new message
      setState(() {
        messages.add(
            Message(inputMessage, formattedTime, true, MessageStatus.sent));
      });
    }
    _scrollToBottom(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                child: ListView.builder(
                  controller: _scrollController2,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final messageData = messages[index];
                    return messageData.sent
                        ? GestureDetector(
                            onLongPress: () {
                              setState(() {
                                isSelected.add(
                                    index); // Add the index to isSelected list
                              });
                            },
                            onTap: () {
                              setState(() {
                                // Check if the index exists in the isSelected list
                                if (isSelected.contains(index)) {
                                  // If it exists, remove it
                                  isSelected.remove(index);
                                }
                              });
                            },
                            child: OwnMessageCard(
                              message: messageData.data,
                              time: messageData.time,
                              status: messageData.status,
                              isSelected: isSelected.contains(index),
                            ),
                          )
                        : RecievedMessageCard(
                            message: messageData.data, time: messageData.time);
                  },
                ),
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
                                fillColor:
                                    const Color(0xff0A122F), // Background color
                                filled:
                                    true, // Enable filling the background color
                                hintText: "Message Here",
                                hintStyle:
                                    const TextStyle(color: Colors.white54),
                                contentPadding: const EdgeInsets.all(5),
                                prefixIcon: IconButton(
                                  onPressed: () {
                                    if (show) {
                                      focusNode.requestFocus();
                                      show != show;

                                      print("daaaaaaaaa");
                                    } else {
                                      showModalBottomSheet(
                                          backgroundColor: Colors.transparent,
                                          context: context,
                                          builder: (builder) =>
                                              EmojiButtonSheet(
                                                  onEmojiTap: () {
                                                    // Hide the button sheet
                                                    Navigator.pop(context);
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
                                        backgroundColor: Colors.transparent,
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
                                  borderSide:
                                      BorderSide.none, // Remove the border line
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      10), // Set border radius for focused state
                                  borderSide:
                                      BorderSide.none, // Remove the border line
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      10), // Set border radius for enabled state
                                  borderSide:
                                      BorderSide.none, // Remove the border line
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
                                  _sendMessage(_controller.text);
                                  _controller
                                      .clear(); // Clear the text field after sending
                                  setState(() {
                                    _isTyping = false; // Reset typing status
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
      ),
    );
  }
}
