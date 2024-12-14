import 'package:flutter/material.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:whisper/components/helpers.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/cubit/user_story_cubit.dart';
import 'package:whisper/cubit/user_story_state.dart';
import 'package:whisper/keys/main_chats_keys.dart';
import 'package:whisper/models/user.dart';
import 'package:whisper/pages/story_page.dart';
import 'package:whisper/components/buttons_sheet_for_add_story.dart';
import 'package:whisper/pages/my_stories_screen.dart';
import '../components/archived_chats_button.dart';
import '../components/chat_card.dart';
import '../components/chat_list.dart';
import 'archived_chats_page.dart';
import 'search_page.dart';

class MainChats extends StatefulWidget {
  static const String id = '/main_chats_page';
  const MainChats({super.key});
  @override
  _MainChatsState createState() => _MainChatsState();
}

class _MainChatsState extends State<MainChats> {
  final ScrollController _scrollController = ScrollController();
  final ChatList chatList = ChatList();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        300,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildDraggableHome(),
    );
  }

  Widget _buildDraggableHome() {
    return DraggableHome(
      leading: const Icon(Icons.arrow_back_ios), //icon button "add key"
      title: _buildTitle(),
      actions: _buildActions(),
      curvedBodyRadius: 18,
      body: [_buildBody()],
      headerExpandedHeight: 0.21,
      headerWidget: _headerWidget(context),
      headerBottomBar: _headerBottomBar(),
      fullyStretchable: true,
      expandedBody: const SearchPage(),
      stretchMaxHeight: 0.8,
      backgroundColor: firstNeutralColor,
      appBarColor: firstSecondaryColor,
      scrollController: _scrollController,
    );
  }

  Widget _buildTitle() {
    return Text(
      "Chats",
      style: TextStyle(
        color: secondNeutralColor,
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
    );
  }

  List<Widget> _buildActions() {
    return [
      GestureDetector(
        key: MainChatsKeys.editButton,
        onTap: () {
          print('Edit tapped');
        },
        child: Text(
          "Edit",
          style: TextStyle(
            color: highlightColor,
            fontSize: 16,
          ),
        ),
      ),
      IconButton(
        key: MainChatsKeys.addStoryInActionsButton,
        icon: SizedBox(
          width: 23.0,
          height: 23.0,
          child: Image.asset(
            "assets/images/addStoryFirstNeutralColor_Icon (3).png",
            fit: BoxFit.cover,
          ),
        ),
        onPressed: () {
          _addStory();
        },
      ),
    ];
  }

  Widget _headerWidget(BuildContext context) {
    return BlocBuilder<UserStoryCubit, UserStoryState>(
      builder: (context, state) {
        if (state is UserStoryLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UserStoryLoaded) {
          final users = state.users;
          final myUser = state.me;

          return Container(
            padding: const EdgeInsets.symmetric(vertical: 40.0),
            color: primaryColor,
            child: SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: users.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _buildMyStoryWidget(myUser);
                  } else {
                    return _buildUserStoryWidget(
                        users[index - 1], users, index - 1);
                  }
                },
              ),
            ),
          );
        } else if (state is UserStoryError) {
          return Center(
            child:
                Text(state.message, style: const TextStyle(color: Colors.red)),
          );
        } else {
          return const Center(
            child: Text('No stories available'),
          );
        }
      },
    );
  }

  Widget _buildMyStoryWidget(User? myUser) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        key: Key("${myUser?.userName}_story"),
        onTap: () {
          if (myUser?.stories.isEmpty ?? true) {
            // Add story logic
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShowMyStories(),
              ),
            );
          }
        },
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                _buildStoryGradient(myUser?.stories.isNotEmpty ?? false),
                CircleAvatar(
                  backgroundColor: firstSecondaryColor,
                  radius: 28,
                  child: myUser?.stories.isEmpty ?? true
                      ? const Text('+', style: TextStyle(fontSize: 40))
                      : CircleAvatar(
                          backgroundImage: NetworkImage(
                            myUser?.profilePic ??
                                'https://ui-avatars.com/api/?background=0a122f&size=100&color=fff&name=${formatName(myUser!.userName)}',
                          ),
                        ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              myUser?.stories.isEmpty ?? true ? "Add Story" : "My Story",
              style: TextStyle(
                  color: secondNeutralColor, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserStoryWidget(User user, List<User> users, int userIndex) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        key: Key("${user.userName}_story"),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  StoryPage(users: users, userIndex: userIndex),
            ),
          );
        },
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                _buildStoryGradient(!user.areAllStoriesViewed()),
                CircleAvatar(
                  backgroundImage: NetworkImage(user.profilePic),
                  radius: 28,
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              user.userName,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryGradient(bool isNew) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: isNew
            ? const LinearGradient(colors: [Colors.purple, Colors.orange])
            : const LinearGradient(colors: [Colors.grey, Colors.white]),
      ),
    );
  }

  Widget _headerBottomBar() {
    return Row(
      children: [
        const Spacer(),
        Expanded(
          flex: 9,
          child: GestureDetector(
            key: MainChatsKeys.searchGestureDetector,
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SearchPage()));
            },
            child: _buildSearchBar(),
          ),
        ),
        IconButton(
          key: MainChatsKeys.addStoryInHeaderButton,
          icon: SizedBox(
            width: 23.0,
            height: 23.0,
            child: Image.asset(
              "assets/images/addStoryFirstNeutralColor_Icon (2).png",
              fit: BoxFit.cover,
            ),
          ),
          onPressed: () {
            _addStory();
          },
        ),
      ],
    );
  }

  void _addStory() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => ImagePickerButtonSheetForStory(),
    );
  }

  Widget _buildBody() {
    return FutureBuilder<Widget>(
      future: _getChatBody(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return snapshot.data!;
        }
      },
    );
  }

  Future<Widget> _getChatBody() async {
    await chatList.initializeChats();
    print("fetch chats");
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: chatList.activeChats.length,
          itemBuilder: (context, index) {
            return _buildSlidableChatCard(chatList.activeChats[index], index);
          },
        ),
      ],
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
            key: MainChatsKeys.deleteButton,
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
            key: MainChatsKeys.muteButton,
            onPressed: (_) {
              print('Muted ${chat['userName']}');
            },
            backgroundColor: Colors.grey,
            foregroundColor: Colors.white,
            icon: Icons.volume_off,
            label: 'Mute',
          ),
          SlidableAction(
            key: MainChatsKeys.pinButton,
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
        chatId: chat['chatid'],
        userName: chat['userName'],
        lastMessage: chat['lastMessage'],
        time: chat['time'],
        avatarUrl: chat['avatarUrl'],
        isRead: chat['isRead'],
        isOnline: chat['isOnline'],
        isSent: chat['isSent'],
        messageType: chat['messageType'],
        isPinned: chat['isPinned'],
        isMuted: chat['isMuted'],
      ),
    );
  }

  void _deleteChat(Map<String, dynamic> chat) {
    chatList.deleteChat(chat);
    setState(() {});
  }

  void _muteChat(Map<String, dynamic> chat) {
    // to do
    //chatList.toggleMute(chat);

    setState(() {});
  }

  Widget _buildSearchBar() {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: secondNeutralColor,
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.center, // Center both icon and text
        children: [
          const Icon(Icons.search, color: Colors.black45),
          const SizedBox(width: 8.0),
          Text(
            "Search",
            style: TextStyle(color: Colors.black45, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
