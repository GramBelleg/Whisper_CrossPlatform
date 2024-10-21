import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../components/chat-card.dart';
import '../components/chats.dart'; // Ensure you import your ChatList class here

class ArchivedChatsPage extends StatefulWidget {
  final List<Map<String, dynamic>> archivedChats;
  final ChatList chatList; // ChatList is passed to manage pinning

  const ArchivedChatsPage({
    Key? key,
    required this.archivedChats,
    required this.chatList, // Update constructor
  }) : super(key: key);

  @override
  _ArchivedChatsPageState createState() => _ArchivedChatsPageState();
}

class _ArchivedChatsPageState extends State<ArchivedChatsPage> {
  late List<Map<String, dynamic>> _archivedChats;

  @override
  void initState() {
    super.initState();
    _archivedChats = List.from(widget.archivedChats);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A122F),
      appBar: AppBar(
        title: const Text(
          'Archived Chats',
          style: TextStyle(color: Color(0xff8D6AEE)),
        ),
        backgroundColor: const Color(0xFF0A122F),
        iconTheme: const IconThemeData(color: Color(0xff8D6AEE)),
      ),
      body: ListView.builder(
        itemCount: _archivedChats.length,
        itemBuilder: (context, index) {
          return _buildSlidableChatCard(_archivedChats[index], index);
        },
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
              // Unarchive the chat
              chat['isArchived'] = false;
              _archivedChats.removeAt(index); // Remove from archived chats
            });
          },
        ),
        children: [
          SlidableAction(
            onPressed: (_) {
              setState(() {
                _archivedChats.removeAt(index);
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
                // Unarchive the chat
                chat['isArchived'] = false;
                _archivedChats.removeAt(index); // Remove from archived chats
                //widget.chatList.unpinChat(chat);
              });
            },
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            icon: Icons.unarchive,
            label: 'Unarchive',
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
        //isPinned: chat['isPinned'], // Pass the pinned status to ChatCard
      ),
    );
  }
}
