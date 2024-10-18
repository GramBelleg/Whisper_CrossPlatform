import 'package:flutter/material.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../components/archived-button.dart';
import '../components/chat-card.dart';
import '../components/chats.dart';
import '../components/tap-bar.dart';
import '../components/stories-widget.dart';
import 'archived-page.dart';
import 'search-page.dart';

class MainChats extends StatefulWidget {
  static const String id = 'main_chats_page';
  const MainChats({super.key});

  @override
  _MainChatsState createState() => _MainChatsState();
}

class _MainChatsState extends State<MainChats> {
  int _selectedIndex = 0;
  final ScrollController _scrollController = ScrollController();
  final ChatList chatList = ChatList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: buildBottomNavigationBar(
        _selectedIndex,
        (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: DraggableHome(
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                print('Edit tapped');
              },
              child: const Text(
                "Edit",
                style: TextStyle(
                  color: Color(0xff8D6AEE),
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 20),
            const Expanded(
              child: Center(
                child: Text(
                  "Chats",
                  style: TextStyle(
                    color: Color(0xff8D6AEE),
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: SizedBox(
              width: 20.0,
              height: 20.0,
              child: Image.asset(
                "assets/images/IconStory.png",
                fit: BoxFit.cover,
              ),
            ),
            onPressed: () {
              _scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
          ),
        ],
        headerWidget: headerWidget(context),
        body: [
          _body(),
        ],
        fullyStretchable: true,
        expandedBody: const SearchPage(), // Update this line
        backgroundColor: const Color(0xFF0A122F),
        appBarColor: const Color(0xFF0A122F),
        scrollController: _scrollController,
      ),
    );
  }

  Widget headerWidget(BuildContext context) {
    return Container(
      color: const Color(0xff8D6AEE),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(50.0),
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
          Flexible(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: sampleUsers.length,
              itemBuilder: (context, index) {
                final user = sampleUsers[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
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
                          backgroundImage: NetworkImage(user.imageUrl),
                          radius: 30,
                        ),
                        const SizedBox(height: 5),
                        Text(user.userName),
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
          const SizedBox(height: 0),
          // Search Bar
          GestureDetector(
            onTap: () {
              // Navigate to the search page when the search bar is tapped
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchPage()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(60.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 2.0,
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Center the contents
                  children: [
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 10),
                    Text(
                      "Search",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // New Archived Chats Button, shown only if there are archived chats
          if (chatList.archivedChats.isNotEmpty)
            ArchivedChatsButton(
              archivedChats: chatList.archivedChats,
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArchivedChatsPage(
                      archivedChats: chatList.archivedChats,
                      chatList: chatList,
                    ),
                  ),
                );
                setState(() {});
              },
            ),
          const SizedBox(height: 0),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: chatList.activeChats.length,
            itemBuilder: (context, index) {
              return _buildSlidableChatCard(chatList.activeChats[index], index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSlidableChatCard(Map<String, dynamic> chat, int index) {
    return Slidable(
      key: ValueKey(chat['userName']),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(
          onDismissed: () {
            setState(() {
              chatList.archiveChat(chat);
            });
          },
        ),
        children: [
          SlidableAction(
            onPressed: (_) {
              setState(() {
                chatList.deleteChat(chat);
              });
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
          SlidableAction(
            onPressed: (_) {
              setState(() {
                chatList.archiveChat(chat);
                chatList.unpinChat(chat);
              });
            },
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.archive,
            label: 'Archive',
          ),
        ],
      ),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) {
              print('Muted ${chat['userName']}');
            },
            backgroundColor: Colors.grey,
            foregroundColor: Colors.white,
            icon: Icons.volume_off,
            label: 'Mute',
          ),
          SlidableAction(
            onPressed: (_) {
              setState(() {
                if (chat['isPinned']) {
                  chatList.unpinChat(chat);
                } else {
                  chatList.pinChat(chat);
                }
              });
            },
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            icon: chat['isPinned'] ? Icons.push_pin : Icons.push_pin_outlined,
            label: chat['isPinned'] ? 'Unpin' : 'Pin',
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
        messageType: chat['messageType'],
        isPinned: chat['isPinned'],
      ),
    );
  }
}
