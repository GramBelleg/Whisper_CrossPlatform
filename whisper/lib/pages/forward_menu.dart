import 'package:flutter/material.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/global_cubits/global_cubit_provider.dart';
import 'package:whisper/global_cubits/global_groups_provider.dart';
import 'package:whisper/keys/forward_menu_keys.dart';
import 'package:whisper/models/chat.dart';
import 'package:whisper/pages/chat_page.dart';
import 'package:whisper/services/fetch_message_by_id.dart';
import 'package:whisper/services/friend_service.dart';
import 'package:whisper/services/shared_preferences.dart';
import 'package:whisper/components/forward_menu_header.dart';
import 'package:whisper/components/friend_list_item.dart';
import 'package:whisper/components/select_friends_chip.dart';
import '../models/friend.dart';

class ForwardMenu extends StatefulWidget {
  final VoidCallback? onClearSelection;
  final List<int>? selectedMessageIds;
  final bool isForward;
  final String? text;
  final int? groupId;
  const ForwardMenu({
    required this.onClearSelection,
    required this.selectedMessageIds,
    required this.text,
    required this.isForward,
    this.groupId,
    Key? key,
  }) : super(key: key);

  @override
  _ForwardMenuState createState() => _ForwardMenuState();
}

class _ForwardMenuState extends State<ForwardMenu> {
  final FriendService _friendService = FriendService();
  final TextEditingController _searchController = TextEditingController();

  List<Chat> _friends = [];
  List<int> _selectedFriendIndexes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFriends();
  }

  Future<void> _loadFriends() async {
    try {
      final friends = widget.isForward
          ? await _friendService.fetchFriends()
          : await _friendService.fetchMembers(widget.groupId!);
      setState(() {
        _friends = friends;
      });
    } catch (e) {
      debugPrint('Error loading friends: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleFriendSelection(int index) {
    setState(() {
      _selectedFriendIndexes.contains(index)
          ? _selectedFriendIndexes.remove(index)
          : _selectedFriendIndexes.add(index);
    });
  }

  Future<void> _forwardMessages() async {
    if (_selectedFriendIndexes.isEmpty) {
      debugPrint("No friends selected.");
      return;
    }

    try {
      final token = await getToken();
      final senderId = await getId();

      for (final index in _selectedFriendIndexes) {
        final friend = _friends[index];
        print("aaaaaaaaaaaay 7aga");
        // Forward all selected messages to the current friend
        await _forwardMessagesToFriend(
          friend: friend,
          selectedMessageIds: widget.selectedMessageIds!,
          senderId: senderId!,
        );
      }

      // Navigate appropriately after forwarding
      _navigateAfterForwarding(token, senderId);
    } catch (e) {
      debugPrint('Error ${widget.text}ing messages: $e');
    } finally {
      widget.onClearSelection!();
    }
  }

  Future<void> _forwardMessagesToFriend({
    required Chat friend,
    required List<int> selectedMessageIds,
    required int senderId,
  }) async {
    for (final messageId in selectedMessageIds) {
      try {
        final message = await fetchMessage(messageId);
        GlobalCubitProvider.messagesCubit.sendMessage(
            content: message.content,
            chatId: friend.chatId,
            senderId: senderId,
            parentMessage: null,
            senderName: friend.userName,
            isReplying: false,
            isForward: true,
            forwardedFromUserId: message.sender?.id,
            media: message.media,
            type: message.type,
            extension: message.extension);
        debugPrint(
            "Message  forwareded ${widget.text}ed to: ${friend.userName}");
      } catch (e) {
        debugPrint(
            'Failed to ${widget.text} message $messageId to ${friend.userName}: $e');
      }
    }
  }

  void _navigateAfterForwarding(String? token, int? senderId) {
    if (_selectedFriendIndexes.length == 1 && _friends.length != 1) {
      final friend = _friends[_selectedFriendIndexes.first];
      Navigator.pop(context);
      Navigator.pop(context);
      //i think it should be twice
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatPage(
            chat: friend,
            token: token,
            senderId: senderId,
          ),
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  List<Chat> get _filteredFriends {
    final query = _searchController.text.toLowerCase();
    return _friends
        .where((friend) => friend.userName.toLowerCase().contains(query))
        .toList();
  }

  Future<void> addMembersToGroup() async {
    try {
      print("selectedFriendIndexes: ${_selectedFriendIndexes.length}");
      for (final friendIndex in _selectedFriendIndexes) {
        final friend = _friends[friendIndex];
        print("friend: $friend");
        GlobalGroupsProvider.groupsCubit.addUserToGroup(
          groupId: widget.groupId!,
          userId: friend.othersId,
          userName: friend.userName,
          profilePic: friend.avatarUrl,
        );
      }

      Navigator.pop(context);
    } catch (e) {
      debugPrint('Error adding members to group: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: firstNeutralColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ForwardMenuHeader(
                text: widget.isForward ? "Forward to..." : "ADD members"),
            _buildSearchBar(),
            SelectedFriendsChip(
                key: ForwardMenuKeys.selectedFriendChip,
                selectedIndexes: _selectedFriendIndexes,
                friends: _filteredFriends),
            const Divider(color: Colors.white),
            _isLoading
                ? const Center(
                    key: ForwardMenuKeys.loadingIndicator,
                    child: CircularProgressIndicator())
                : _buildFriendList(),
            _buildForwardButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        key: ForwardMenuKeys.searchBar,
        controller: _searchController,
        decoration: const InputDecoration(
          labelText: 'Search Friends...',
          labelStyle: TextStyle(color: Colors.white),
          suffixIcon: Icon(Icons.search, color: Colors.white),
        ),
        style: const TextStyle(color: Colors.white),
        onChanged: (_) => setState(() {}), // Update filtered list dynamically
      ),
    );
  }

  Widget _buildFriendList() {
    return Flexible(
      child: ListView.builder(
        key: ForwardMenuKeys.friendList,
        shrinkWrap: true,
        itemCount: _filteredFriends.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedFriendIndexes.contains(index);
          return FriendListItem(
            friend: _filteredFriends[index],
            isSelected: isSelected,
            onTap: () => _toggleFriendSelection(index),
          );
        },
      ),
    );
  }

  Widget _buildForwardButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        key: ForwardMenuKeys.forwardButton,
        onPressed: widget.isForward ? _forwardMessages : addMembersToGroup,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          backgroundColor: primaryColor,
        ),
        child: Text("${widget.text}"),
      ),
    );
  }
}
