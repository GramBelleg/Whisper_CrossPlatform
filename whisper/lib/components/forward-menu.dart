import 'package:flutter/material.dart';
import 'package:whisper/services/chats-services.dart';
import 'package:whisper/services/shared-preferences.dart';
import '../pages/chat-page.dart'; // Import your ChatPage

class ForwardMenu extends StatefulWidget {
  final VoidCallback clearSelection;

  ForwardMenu({
    required this.clearSelection,
  });

  @override
  _ForwardMenuState createState() => _ForwardMenuState();
}

class _ForwardMenuState extends State<ForwardMenu> {
  List<Map<String, dynamic>> friends = [];
  bool isLoading = true;
  List<int> selectedFriends = [];
  TextEditingController searchController = TextEditingController();
  final Color firstNeutralColor = Color(0xff0a122f);
  final Color primaryColor = Color(0xff8d6aee);

  @override
  void initState() {
    super.initState();
    loadFriends();
  }

  Future<void> loadFriends() async {
    try {
      List<dynamic> chats = await fetchChats();

      setState(() {
        friends = chats.map((chat) {
          return {
            "name": chat["other"]['userName'] ?? 'User${chat['id']}',
            "icon": chat['other']['profilePic'] ?? 'assets/images/el-gayar.jpg',
            'id': chat['id']
          };
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      print('Error loading friends: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _selectFriend(int index) {
    setState(() {
      if (selectedFriends.contains(index)) {
        selectedFriends.remove(index);
      } else {
        selectedFriends.add(index);
      }
    });
  }

  List<Map<String, dynamic>> get filteredFriends {
    return friends.where((friend) {
      return friend["name"]
          .toLowerCase()
          .contains(searchController.text.toLowerCase());
    }).toList();
  }

  Future<void> _handleForwardAction() async {
    if (selectedFriends.length > 1) {
      print("More than one friend selected. Please select only one.");
      Navigator.pop(context); // Close the dialog
    } else if (selectedFriends.length == 1) {
      int selectedIndex = selectedFriends.first;
      String userName = filteredFriends[selectedIndex]["name"];
      String avatarUrl = filteredFriends[selectedIndex]["icon"];
      int chatId =
          friends[selectedIndex]['id']; // Assuming you have the chat ID

      String? token = await GetToken();
      int? senderId = await GetId();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatPage(
            userName: userName,
            userImage: avatarUrl,
            ChatID: chatId,
            token: token,
            senderId: senderId,
          ),
        ),
      );
    } else {
      print("No friends selected.");
    }

    widget.clearSelection();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: firstNeutralColor,
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Forward to...",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: 'Search Friends...',
                  labelStyle: TextStyle(color: Colors.white),
                  suffixIcon: Icon(Icons.search, color: Colors.white),
                ),
                style: TextStyle(color: Colors.white),
                onChanged: (query) {
                  setState(() {});
                },
              ),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: selectedFriends.map((index) {
                return Container(
                  width: (MediaQuery.of(context).size.width - 40) / 2,
                  child: Chip(
                    label: Text(
                      filteredFriends[index]["name"],
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: primaryColor,
                  ),
                );
              }).toList(),
            ),
            Divider(color: Colors.white),
            if (isLoading)
              Center(child: CircularProgressIndicator())
            else
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredFriends.length,
                  itemBuilder: (context, index) {
                    bool isSelected = selectedFriends.contains(index);
                    return GestureDetector(
                      onLongPress: () => _selectFriend(index),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? firstNeutralColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: filteredFriends[index]["icon"]
                                    is String
                                ? (filteredFriends[index]["icon"]
                                        .startsWith('assets/')
                                    ? AssetImage(filteredFriends[index]["icon"])
                                    : NetworkImage(
                                        filteredFriends[index]["icon"]))
                                : null,
                            child: filteredFriends[index]["icon"] is String
                                ? null
                                : Icon(Icons.person),
                          ),
                          title: Text(
                            filteredFriends[index]["name"],
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: isSelected
                              ? Icon(Icons.check_box, color: primaryColor)
                              : Icon(Icons.check_box_outline_blank,
                                  color: Colors.white),
                          onTap: () {
                            _selectFriend(index);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _handleForwardAction,
                child: Text("Forward"),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
