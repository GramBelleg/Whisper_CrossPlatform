import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
  @override
  void initState() {
    super.initState();
    // Add a listener to the focusNode to hide the emoji picker when the text field is focused
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          show = false; // Hide emoji picker when the text field is focused
        });
      }
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
              ListView(), // Chat messages go here
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
                                  onPressed: _toggleEmojiPicker,
                                  icon: FaIcon(
                                    show
                                        ? FontAwesomeIcons.keyboard
                                        : FontAwesomeIcons.smile,
                                    color: const Color(
                                        0xff8D6AEE), // Consistent icon color
                                  ),
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {},
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
                            child: FaIcon(
                              _isTyping
                                  ? FontAwesomeIcons.paperPlane
                                  : FontAwesomeIcons.microphone,
                              color: Color(0xff8D6AEE),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Display emoji picker if `show` is true
                    show ? emojiselect() : Container()
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

  Widget emojiselect() {
    return EmojiPicker(onBackspacePressed: () {
      setState(() {
        String currentText = _controller.text;

        // Check if there is text to delete
        if (currentText.isNotEmpty) {
          // Remove the last character safely
          // Use runes to handle Unicode characters
          var runes = currentText.runes.toList();
          runes.removeLast(); // Remove the last character

          // Update the controller's text
          _controller.text = String.fromCharCodes(runes);

          // Update the cursor position to be at the end of the new text
          _controller.selection = TextSelection.fromPosition(
              TextPosition(offset: _controller.text.length));
        }
      });
    }, onEmojiSelected: (category, emoji) {
      setState(() {
        _controller.text += emoji.emoji; // Add emoji to text field
        _scrollToBottom();
        _isTyping = true; // Set typing status to true when an emoji is added
        // Set the cursor to the end after adding the emoji
        _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: _controller.text.length));
      });
    });
  }
}
