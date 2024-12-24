import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:whisper/components/chat_card.dart';
import 'package:whisper/components/contact_card.dart'; // Import new card for contacts
import 'package:whisper/components/helpers.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/cubit/chats_cubit.dart';
import 'package:whisper/models/chat.dart';
import 'package:whisper/models/chat_message.dart';
import 'package:whisper/services/read_file.dart';
import 'package:whisper/services/search_services.dart';
import 'package:whisper/services/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final List<String> choices = [
    "DM",
    "GROUP",
    "CHANNEL",
    "CONTACT",
    "MESSAGES"
  ];
  String selectedChoice = "DM"; // Default choice
  String searchQuery = ""; // Track search input

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Search",
          style: TextStyle(
            color: secondNeutralColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: firstSecondaryColor,
        iconTheme: const IconThemeData(
          color: secondNeutralColor, // Sets the back arrow color
        ),
      ),
      body: Container(
        color: firstSecondaryColor, // Set background color for the page
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value; // Update search query
                  });
                },
                style: TextStyle(
                  color: secondNeutralColor, // Change text color here
                ),
                decoration: InputDecoration(
                  hintText: "Search",
                  hintStyle: TextStyle(color: secondNeutralColor),
                  filled: true,
                  fillColor: primaryColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.search, color: secondNeutralColor),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal, // Enable horizontal scrolling
                child: Row(
                  children: choices.map((choice) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ChoiceChip(
                        label: Text(choice),
                        selected: selectedChoice == choice,
                        onSelected: (bool isSelected) {
                          if (isSelected) {
                            setState(() {
                              selectedChoice = choice;
                            });
                          }
                        },
                        selectedColor: selectColor,
                        backgroundColor: secondNeutralColor,
                        labelStyle: TextStyle(
                          color: selectedChoice == choice
                              ? secondNeutralColor
                              : firstNeutralColor,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            Expanded(
              child: _buildSearchResults(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(BuildContext context) {
    if (selectedChoice == "CONTACT") {
      return FutureBuilder<List<dynamic>>(
        future: chatsGlobalSearch(searchQuery),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            List<dynamic> chats = snapshot.data!;
            return ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                return _buildContactCard(chats[index], index);
              },
            );
          } else {
            return Center(child: Text("NO $selectedChoice FOUND"));
          }
        },
      );
    } else if (selectedChoice == "MESSAGES") {
      return FutureBuilder<List<dynamic>>(
        future: loadMessagewithfilter(searchQuery),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            List<dynamic> messages = snapshot.data!;
            return ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return _buildMessageCard(messages[index], index);
              },
            );
          } else {
            return Center(child: Text("NO $selectedChoice FOUND"));
          }
        },
      );
    }

    return BlocBuilder<ChatListCubit, List<Chat>>(
      builder: (context, chatList) {
        List<Chat> filteredChats = [];

        switch (selectedChoice) {
          case "DM":
            filteredChats = chatList.where((chat) {
              return chat.type == selectedChoice &&
                  chat.userName
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase());
            }).toList();
            break;
          case "GROUP":
            filteredChats = chatList.where((chat) {
              return chat.type == selectedChoice &&
                  chat.userName
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase());
            }).toList();
            break;
          case "CHANNEL":
            filteredChats = chatList.where((chat) {
              return chat.type == selectedChoice &&
                  chat.userName
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase());
            }).toList();
            break;
        }

        return filteredChats.isEmpty
            ? Center(
                child: Text(
                  'You do not have $selectedChoice',
                  style: TextStyle(fontSize: 18, color: secondNeutralColor),
                ),
              )
            : ListView.builder(
                itemCount: filteredChats.length,
                itemBuilder: (context, index) {
                  return _buildSlidableChatCard(filteredChats[index], index);
                },
              );
      },
    );
  }

  Future<List<dynamic>> loadMessagewithfilter(String searchQuery) async {
    List<dynamic> filteredMessages = [];
    final chatList = context
        .read<ChatListCubit>()
        .state; // Get the chat list from the ChatListCubit

    for (var chat in chatList) {
      try {
        // Load cached messages for each chat by chatId
        List<ChatMessage> messages = await loadCachedMessages(chat.chatId);

        for (var message in messages) {
          // Safely access message content
          String messageContent = message.content;

          // Filter messages based on the search query
          if (messageContent
              .toLowerCase()
              .contains(searchQuery.toLowerCase())) {
            if (message.type == "TEXT" ||
                message.type == "IMAGE" ||
                message.type == "VIDEO") {
              // Safely handle sender info
              String senderUserName = message.sender?.userName ?? 'Unknown';
              String? senderProfilePic = message.sender?.profilePic;

              // Generate presigned URL if needed
              String? presignedUrl = senderProfilePic != null
                  ? await generatePresignedUrl(senderProfilePic)
                  : null;

              // Decide the profile picture URL
              String profilePicUrl = senderProfilePic == null ||
                      senderProfilePic.isEmpty
                  ? "https://ui-avatars.com/api/?background=8d6aee&size=1500&color=fff&name=${formatName(senderUserName)}"
                  : isValidUrl(senderProfilePic)
                      ? senderProfilePic
                      : (presignedUrl?.isNotEmpty ?? false)
                          ? presignedUrl!
                          : "https://ui-avatars.com/api/?background=8d6aee&size=1500&color=fff&name=${formatName(senderUserName)}";

              // Safely handle media
              String? mediaUrl = message.media != null
                  ? await getImageUrl(message.media!)
                  : null;

              // Create a filtered message object
              var filteredMessage = {
                'content': messageContent,
                'media': mediaUrl,
                'type': message.type,
                'sender': {
                  'userName': senderUserName,
                  'profilePic': profilePicUrl,
                },
              };

              filteredMessages.add(filteredMessage);
            }
          }
        }
      } catch (error) {
        print("Error loading messages for chatId ${chat.chatId}: $error");
      }
    }

    print("Filtered messages: $filteredMessages");
    return filteredMessages;
  }

  Widget _buildSlidableChatCard(Chat chat, int index) {
    return Slidable(
      key: ValueKey(chat.userName),
      child: ChatCard(
        chat: chat,
      ),
    );
  }

  Widget _buildContactCard(dynamic chat, int index) {
    return Slidable(
      key: ValueKey(chat['name']),
      child: ContactCard(
        chat: chat,
      ),
    );
  }

  Widget _buildMessageCard(dynamic message, int index) {
    return Slidable(
      key: ValueKey(message['content']),
      child: MessageCard(
        content: message['content'],
        media: message['media'],
        type: message['type'],
        senderUserName: message['sender']['userName'],
        senderProfilePic: message['sender']['profilePic'],
      ),
    );
  }
}
