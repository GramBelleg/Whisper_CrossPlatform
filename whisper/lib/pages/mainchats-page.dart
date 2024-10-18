import 'package:flutter/material.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../components/chat-card.dart';
import '../components/tap-bar.dart';
import '../components/stories-widget.dart';

class MainChats extends StatefulWidget {
  static const String id = 'main_chats_page'; // Define the static id here
  const MainChats({super.key});

  @override
  _MainChatsState createState() => _MainChatsState();
}

class _MainChatsState extends State<MainChats> {
  int _selectedIndex = 0; // Initialize the selected index
  final ScrollController _scrollController =
      ScrollController(); // Create a ScrollController
  final ChatList chatList = ChatList(); // Create an instance of ChatList

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: buildBottomNavigationBar(
        _selectedIndex,
        (index) {
          setState(() {
            _selectedIndex = index; // Update the selected index
          });
        },
      ),
      body: DraggableHome(
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                // Event when "Edit" is tapped
                print('Edit tapped'); // Replace with desired action
              },
              child: const Text(
                "Edit",
                style: TextStyle(
                  color: Color(0xff8D6AEE), // Edit text color
                  fontSize: 16, // Edit text size
                ),
              ),
            ),
            const SizedBox(width: 20), // Space between "Edit" and "Chats"
            const Expanded(
              child: Center(
                child: Text(
                  "Chats",
                  style: TextStyle(
                    color: Color(0xff8D6AEE),
                    fontWeight: FontWeight.bold,
                    fontSize: 24, // Increased font size
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: SizedBox(
              width: 20.0, // Set custom width
              height: 20.0, // Set custom height
              child: Image.asset(
                "assets/images/IconStory.png",
                fit: BoxFit.cover,
              ),
            ),
            onPressed: () {
              // Scroll to the top of the body
              _scrollController.animateTo(
                0, // Scroll to the top
                duration:
                    const Duration(milliseconds: 300), // Animation duration
                curve: Curves.easeInOut, // Animation curve
              );
            },
          ),
        ],
        headerWidget: headerWidget(context), // Call updated headerWidget
        body: [
          _body(), // Call the _body method for the draggable content
        ],
        fullyStretchable: true,
        expandedBody: const StoryPage(userIndex: 0, withCloseIcon: false),
        backgroundColor: const Color(0xFF0A122F),
        appBarColor: const Color(0xFF0A122F),
        scrollController: _scrollController, // Set the ScrollController
      ),
    );
  }

  Widget headerWidget(BuildContext context) {
    return Container(
      color: const Color(0xff8D6AEE),
      child: Column(
        children: [
          // Header title
          const Padding(
            padding: EdgeInsets.all(50.0), // Add padding around the title
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Stories",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Story circles using 'stories_for_flutter'
          Flexible(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: sampleUsers.length, // Number of users
              itemBuilder: (context, index) {
                final user = sampleUsers[index]; // Get the current user
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to the user's stories when tapped
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StoryPage(userIndex: index),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              user.imageUrl), // Display the user's image
                          radius: 30,
                        ),
                        const SizedBox(height: 5),
                        Text(user.userName), // Display the user's name
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Center(
            child: Text(
              "Chats",
              style: TextStyle(
                color: Color(0xff8D6AEE),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          ListView.builder(
            physics:
                const NeverScrollableScrollPhysics(), // Prevent scrolling of inner ListView
            shrinkWrap: true, // Take up only the required height
            itemCount: chatList
                .chatData.length, // Use the length of the chat data list
            itemBuilder: (context, index) {
              final chat = chatList.chatData[index];

              // Pass a parameter indicating whether the chat is archived
              bool isArchived = chat['isArchived'] ?? false;

              // Call the new function to generate each Slidable chat card with the archived status
              return _buildSlidableChatCard(chat, index, isArchived);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSlidableChatCard(
      Map<String, dynamic> chat, int index, bool isArchived) {
    return Slidable(
      key: ValueKey(chat['userName']), // Use a unique key for each Slidable

      // Left Action Pane for Delete and Archive/Unarchive
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(onDismissed: () {
          if (isArchived) {
            print('Unarchived ${chat['userName']}');
          } else {
            print('Archived ${chat['userName']}');
          }
          isArchived = !isArchived;
        }),
        children: [
          SlidableAction(
            onPressed: (_) {
              // Handle delete action
              setState(() {
                chatList.chatData.removeAt(index); // Remove chat
              });
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
          SlidableAction(
            onPressed: (_) {
              if (isArchived) {
                // Handle unarchive action
                print('Unarchived ${chat['userName']}');
                // Implement the unarchive functionality as needed
              } else {
                // Handle archive action
                print('Archived ${chat['userName']}');
                // Implement the archive functionality as needed
              }
            },
            backgroundColor: isArchived ? Colors.blue : Colors.green,
            foregroundColor: Colors.white,
            icon: isArchived ? Icons.unarchive : Icons.archive,
            label: isArchived ? 'Unarchive' : 'Archive',
          ),
        ],
      ),

      // Right Action Pane for Pin and Mute
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) {
              // Handle pin action
              print('Pinned ${chat['userName']}');
              // Implement the pin functionality as needed
            },
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            icon: Icons.push_pin,
            label: 'Pin',
          ),
          SlidableAction(
            onPressed: (_) {
              // Handle mute action
              print('Muted ${chat['userName']}');
              // Implement the mute functionality as needed
            },
            backgroundColor: Colors.grey,
            foregroundColor: Colors.white,
            icon: Icons.volume_off,
            label: 'Mute',
          ),
        ],
      ),

      child: ChatCard(
        userName: chat['userName'],
        lastMessage: chat['lastMessage'],
        time: chat['time'],
        avatarUrl: chat['avatarUrl'],
        isRead: chat['isRead'],
        isOnline: chat['isOnline'],
        isSent: chat['isSent'],
        messageType: chat['messageType'], // Pass the message type
      ),
    );
  }
}

class ChatList {
  final List<Map<String, dynamic>> chatData = [
    {
      'userName': 'Alice',
      'lastMessage': 'Hey! How are you?',
      'time': '10:00 AM',
      'avatarUrl': 'assets/images/el-gayar.jpg',
      'isRead': true,
      'isOnline': false,
      'isSent': true,
      'messageType': MessageType.text,
      'isArchived': false,
    },
    {
      'userName': 'Bob',
      'lastMessage': 'Sent you a picture!',
      'time': '11:00 AM',
      'avatarUrl': 'assets/images/el-gayar.jpg',
      'isRead': false,
      'isOnline': true,
      'isSent': true,
      'messageType': MessageType.image,
      'isArchived': false,
    },
    {
      'userName': 'Charlie',
      'lastMessage': 'Let’s catch up this weekend.',
      'time': '12:00 PM',
      'avatarUrl': 'assets/images/el-gayar.jpg',
      'isRead': true,
      'isOnline': false,
      'isSent': true,
      'messageType': MessageType.text,
      'isArchived': false,
    },
    {
      'userName': 'Diana',
      'lastMessage': '🎥 Video call?',
      'time': '1:00 PM',
      'avatarUrl': 'assets/images/el-gayar.jpg',
      'isRead': true,
      'isOnline': true,
      'isSent': false,
      'messageType': MessageType.video,
      'isArchived': false,
    },
    {
      'userName': 'Ethan',
      'lastMessage': 'Here is the document you requested.',
      'time': '2:00 PM',
      'avatarUrl': 'assets/images/el-gayar.jpg',
      'isRead': true,
      'isOnline': false,
      'isSent': true,
      'messageType': MessageType.text,
      'isArchived': false,
    },
    {
      'userName': 'Fiona',
      'lastMessage': 'Let’s go for a run tomorrow.',
      'time': '3:30 PM',
      'avatarUrl': 'assets/images/el-gayar.jpg',
      'isRead': false,
      'isOnline': true,
      'isSent': false,
      'messageType': MessageType.text,
      'isArchived': false,
    },
    {
      'userName': 'George',
      'lastMessage': 'Are you joining the meeting?',
      'time': '4:00 PM',
      'avatarUrl': 'assets/images/el-gayar.jpg',
      'isRead': true,
      'isOnline': false,
      'isSent': true,
      'messageType': MessageType.text,
      'isArchived': false,
    },
    {
      'userName': 'Hannah',
      'lastMessage': 'Just finished my assignment!',
      'time': '5:15 PM',
      'avatarUrl': 'assets/images/el-gayar.jpg',
      'isRead': true,
      'isOnline': false,
      'isSent': true,
      'messageType': MessageType.text,
      'isArchived': false,
    },
    {
      'userName': 'Ian',
      'lastMessage': '🎉 Happy Birthday!',
      'time': '6:30 PM',
      'avatarUrl': 'assets/images/el-gayar.jpg',
      'isRead': false,
      'isOnline': true,
      'isSent': false,
      'messageType': MessageType.gif,
      'isArchived': false,
    },
    {
      'userName': 'Julia',
      'lastMessage': 'Do you have time to chat later?',
      'time': '7:45 PM',
      'avatarUrl': 'assets/images/el-gayar.jpg',
      'isRead': true,
      'isOnline': false,
      'isSent': true,
      'messageType': MessageType.text,
      'isArchived': false,
    },
    {
      'userName': 'Kevin',
      'lastMessage': 'Check out this funny video!',
      'time': '8:30 PM',
      'avatarUrl': 'assets/images/el-gayar.jpg',
      'isRead': false,
      'isOnline': true,
      'isSent': false,
      'messageType': MessageType.video,
      'isArchived': false,
    },
    {
      'userName': 'Liam',
      'lastMessage': 'Got your message, will reply soon.',
      'time': '9:00 PM',
      'avatarUrl': 'assets/images/el-gayar.jpg',
      'isRead': true,
      'isOnline': false,
      'isSent': true,
      'messageType': MessageType.text,
      'isArchived': false,
    },
    {
      'userName': 'Mia',
      'lastMessage': 'Audio message sent.',
      'time': '10:00 PM',
      'avatarUrl': 'assets/images/el-gayar.jpg',
      'isRead': false,
      'isOnline': true,
      'isSent': true,
      'messageType': MessageType.soundRecord,
      'isArchived': false,
    },
    {
      'userName': 'Nora',
      'lastMessage': 'This message has been deleted.',
      'time': '10:15 PM',
      'avatarUrl': 'assets/images/el-gayar.jpg',
      'isRead': true,
      'isOnline': false,
      'isSent': true,
      'messageType': MessageType.deletedMessage,
      'isArchived': false,
    },
    {
      'userName': 'Oliver',
      'lastMessage': 'Look at this cool sticker!',
      'time': '10:30 PM',
      'avatarUrl': 'assets/images/el-gayar.jpg',
      'isRead': false,
      'isOnline': true,
      'isSent': false,
      'messageType': MessageType.sticker,
      'isArchived': false,
    },
  ];
}
