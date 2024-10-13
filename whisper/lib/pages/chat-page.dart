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

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller
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
        child: Stack(
          children: [
            SvgPicture.asset(
              'assets/images/chat-page-back-ground-image.svg',
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            ListView(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 55,
                    child: Card(
                      margin:
                          const EdgeInsets.only(left: 5, right: 5, bottom: 8),
                      child: TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 5,
                        controller: _controller,
                        textAlign: _textAlign, // Set text alignment
                        textDirection: _textDirection, // Set text direction
                        style: const TextStyle(color: Colors.white),
                        onChanged:
                            _updateTextProperties, // Update text alignment on change
                        decoration: InputDecoration(
                          fillColor:
                              const Color(0xff0A122F), // Background color
                          filled: true, // Enable filling the background color
                          hintText: "Message Here",
                          hintStyle: const TextStyle(color: Colors.white54),
                          contentPadding: const EdgeInsets.all(5),
                          prefixIcon: IconButton(
                            onPressed: () {
                              print("hello");
                            },
                            icon: const FaIcon(
                              FontAwesomeIcons.smile,
                              color: Color(0xff8D6AEE), // Consistent icon color
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
            ),
          ],
        ),
      ),
    );
  }
}
