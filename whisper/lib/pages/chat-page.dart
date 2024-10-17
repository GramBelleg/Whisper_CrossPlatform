import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whisper/modules/emoji-select.dart';
import 'package:whisper/modules/own-message-card.dart';
import 'package:whisper/modules/recieved-message-card.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatPage extends StatefulWidget {
  static const String id = 'chat_page'; // Define the static id here

  const ChatPage({super.key});

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
  final ImagePicker _picker = ImagePicker();
  late IO.Socket socket;
  List<OwnMessageCard> messages = [];
  List<RecievedMessageCard> recievedmessages = [];
  @override
  void initState() {
    super.initState();
    connect();
    // Add a listener to the focusNode to hide the emoji picker when the text field is focused
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          show = false; // Hide emoji picker when the text field is focused
        });
      }
    });
// Listen for incoming messages from the server
    socket.on('receiveMessage', (data) {
      print("Message received: $data");

      // Update the UI with the received message
      setState(() {
        recievedmessages.add(RecievedMessageCard(
          message:
              data['message'], // Assuming the server sends { message, time }
          time: data['time'],
        ));
      });
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
    });
  }

  void _scrollToBottom() {
    // Check if the scroll controller is attached and has listeners
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  void connect() {
    // Replace with your server's IP and port
    socket = IO.io("http://192.168.1.11:5000", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });

    socket.connect();

    // Listen for successful connection
    socket.on('connect', (_) {
      print("Connected to server");
    });

    // Listen for incoming messages from the server
    socket.on('receiveMessage', (data) {
      print("Message received: $data");

      // You need to update your UI with the received message
      // For example, you can add the message to a List and rebuild the chat
    });

    // Emit a test message when connected
    socket.emit('/sendmessage', "Client connected");
  }

  void _sendMessage(String message) {
    if (message.isNotEmpty) {
      // Get the current time
      DateTime now = DateTime.now();

      // Format the time manually
      String formattedTime =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

      // Emit the message via socket
      socket.emit('/sendmessage', message);
      print('Message sent: $message');

      // Here you can update your UI with the new message
      // For example, adding it to your chat messages list
      setState(() {
        messages.add(OwnMessageCard(
          message: message,
          time: formattedTime,
          status: MessageStatus.sent, // Mark as sent
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Color(0xff8D6AEE), // Set the desired color for the icons
        ),
        backgroundColor: const Color(0xff0A122F),
        leadingWidth: 100,
        titleSpacing: 0,
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.arrowLeft),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            const CircleAvatar(
              radius: 20,
              backgroundColor: Colors.blueGrey,
              backgroundImage: AssetImage("assets/images/el-gayar.jpg"),
            ),
          ],
        ),
        title: InkWell(
          onTap: () {},
          child: Container(
            margin: const EdgeInsets.all(5),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("zeyad alaa el din said",
                    style: TextStyle(fontSize: 19, color: Colors.white)),
                Text("last seen today at 12:05",
                    style: TextStyle(fontSize: 13, color: Colors.white))
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const FaIcon(FontAwesomeIcons.magnifyingGlass),
          ),
          IconButton(
            onPressed: () {},
            icon: const FaIcon(FontAwesomeIcons.phone),
          ),
          PopupMenuButton<String>(
            onSelected: (String result) {
              print(result);
            },
            icon: const FaIcon(FontAwesomeIcons.ellipsisV),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'View Contact',
                child: Text('View Contact'),
              ),
              const PopupMenuItem<String>(
                value: 'Media, Links, and Docs',
                child: Text('Media, Links, and Docs'),
              ),
              const PopupMenuItem<String>(
                value: 'Search',
                child: Text('Search'),
              ),
              const PopupMenuItem<String>(
                value: 'Mute Notifications',
                child: Text('Mute Notifications'),
              ),
              const PopupMenuItem<String>(
                value: 'Wallpaper',
                child: Text('Wallpaper'),
              ),
              const PopupMenuItem<String>(
                value: 'More',
                child: Text('More'),
              ),
            ],
          )
        ],
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
                height: MediaQuery.of(context).size.height - 145,
                child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final messageData = messages[index];
                    return messageData;
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
                                    } else {
                                      showModalBottomSheet(
                                          backgroundColor: Colors.transparent,
                                          context: context,
                                          builder: (builder) =>
                                              buttonSheetforemojies());
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
                                        builder: (builder) => buttonSheet());
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

  Widget buttonSheetforemojies() {
    return Container(
      height: MediaQuery.of(context).size.height / 5,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: EdgeInsets.all(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
          child: Column(
            children: [
              Row(
                children: [
                  iconCreation(
                    FontAwesomeIcons.smile,
                    "emoji",
                    Colors.indigo,
                    () {
                      // Hide the button sheet
                      Navigator.pop(context);
                      // Show the emoji picker
                      _toggleEmojiPicker();
                    },
                  ),
                  Spacer(flex: 1),
                  iconCreation(
                    Icons.sticky_note_2,
                    "sticker",
                    Colors.pink,
                    () {
                      // Add sticker functionality here
                    },
                  ),
                  Spacer(flex: 1),
                  iconCreation(
                    Icons.gif,
                    "gif",
                    Colors.purple,
                    () {
                      // Add gif functionality here
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buttonSheet() {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: EdgeInsets.all(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
          child: Column(
            children: [
              Row(
                children: [
                  iconCreation(Icons.insert_drive_file, "Document",
                      Colors.indigo, _pickFile),
                  Spacer(flex: 1),
                  iconCreation(Icons.camera_alt, "Camera", Colors.pink,
                      _pickImageFromCamera),
                  Spacer(flex: 1),
                  iconCreation(Icons.insert_photo, "Gallery", Colors.purple,
                      _pickImageFromGallery),
                ],
              ),
              Spacer(flex: 1),
              Row(
                children: [
                  iconCreation(
                      Icons.headset, "Audio", Colors.orange, _pickAudio),
                  Spacer(flex: 1),
                  iconCreation(
                      Icons.location_pin, "Location", Colors.teal, () {}),
                  Spacer(flex: 1),
                  iconCreation(Icons.person, "Contacts", Colors.blue, () {}),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget iconCreation(IconData icon, String text, Color color, Function onTap) {
    return InkWell(
      onTap: () => onTap(), // Call the function passed as a parameter
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            child: Icon(
              icon,
              size: 29,
              color: Colors.white,
            ),
            backgroundColor: color,
          ),
          Text(text),
        ],
      ),
    );
  }

  void _pickFile() async {
    // Use FilePicker to pick a file
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      // Get the selected file
      String? filePath = result.files.single.path;
      String? fileName = result.files.single.name;

      // You can now send the file or show a message with the file name
      print("File selected: $fileName at $filePath");

      // Add logic to send the file or display it in the chat
      // For example:
      // _sendFile(filePath);
    } else {
      // User canceled the picker
      print("File selection canceled");
    }
  }

  void _pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      // You can now send the captured image or show a message with the file name
      print("Image captured: ${image.name} at ${image.path}");

      // For example, you can send the image in the chat
      // _sendImage(image.path);
    } else {
      print("Camera image selection canceled");
    }
  }

  void _pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // You can now send the selected image or show a message with the file name
      print("Image selected: ${image.name} at ${image.path}");

      // For example, you can send the image in the chat
      // _sendImage(image.path);
    } else {
      print("Gallery image selection canceled");
    }
  }

  void _pickAudio() async {
    // Use FilePicker to pick an audio file
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (result != null) {
      // Get the selected audio file
      String? filePath = result.files.single.path;
      String? fileName = result.files.single.name;

      // You can now send the audio file or show a message with the file name
      print("Audio selected: $fileName at $filePath");

      // Add logic to send the audio or display it in the chat
      // For example:
      // _sendAudio(filePath);
    } else {
      // User canceled the picker
      print("Audio selection canceled");
    }
  }

  Widget _iconButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            child: Icon(
              icon,
              size: 29,
              color: Colors.white,
            ),
            backgroundColor: Color(0xff8D6AEE),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
