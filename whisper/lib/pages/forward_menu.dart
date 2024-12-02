import 'package:flutter/material.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/global_cubit_provider.dart';
import 'package:whisper/pages/chat_page.dart';
import 'package:whisper/services/fetch_message_by_id.dart';
import 'package:whisper/services/friend_service.dart';
import 'package:whisper/services/shared_preferences.dart';
import 'package:whisper/components/forward_menu_header.dart';
import 'package:whisper/components/friend_list_item.dart';
import 'package:whisper/components/select_friends_chip.dart';
import '../models/friend.dart';

class ForwardMenu extends StatefulWidget {
  final VoidCallback onClearSelection;
  final List<int> selectedMessageIds;

  const ForwardMenu({
    required this.onClearSelection,
    required this.selectedMessageIds,
    Key? key,
  }) : super(key: key);

  @override
  _ForwardMenuState createState() => _ForwardMenuState();
}

class _ForwardMenuState extends State<ForwardMenu> {
  final FriendService _friendService = FriendService();
  final TextEditingController _searchController = TextEditingController();

  List<Friend> _friends = [];
  List<int> _selectedFriendIndexes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFriends();
  }

  Future<void> _loadFriends() async {
    try {
      final friends = await _friendService.fetchFriends();
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

        // Forward all selected messages to the current friend
        await _forwardMessagesToFriend(
          friend: friend,
          selectedMessageIds: widget.selectedMessageIds,
          senderId: senderId!,
        );
      }

      // Navigate appropriately after forwarding
      _navigateAfterForwarding(token, senderId);
    } catch (e) {
      debugPrint('Error forwarding messages: $e');
    } finally {
      widget.onClearSelection();
    }
  }

  Future<void> _forwardMessagesToFriend({
    required Friend friend,
    required List<int> selectedMessageIds,
    required int senderId,
  }) async {
    for (final messageId in selectedMessageIds) {
      try {
        final message = await fetchMessage(messageId);
        GlobalCubitProvider.messagesCubit.sendMessage(
            content: message.content,
            chatId: friend.id,
            senderId: senderId,
            parentMessage: message.parentMessage,
            senderName: friend.name,
            isReplying: false,
            isForward: true,
            forwardedFromUserId: message.sender?.id,
            media: message.media,
            type: message.type,
            extension: message.extension);
        debugPrint("Message forwarded to: ${friend.name}");
      } catch (e) {
        debugPrint(
            'Failed to forward message $messageId to ${friend.name}: $e');
      }
    }
  }

  void _navigateAfterForwarding(String? token, int? senderId) {
    if (_selectedFriendIndexes.length == 1 && _friends.length != 1) {
      final friend = _friends[_selectedFriendIndexes.first];
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatPage(
            userName: friend.name,
            userImage: friend.icon,
            ChatID: friend.id,
            token: token,
            senderId: senderId,
          ),
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  List<Friend> get _filteredFriends {
    final query = _searchController.text.toLowerCase();
    return _friends
        .where((friend) => friend.name.toLowerCase().contains(query))
        .toList();
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
            const ForwardMenuHeader(),
            _buildSearchBar(),
            SelectedFriendsChip(
                selectedIndexes: _selectedFriendIndexes,
                friends: _filteredFriends),
            const Divider(color: Colors.white),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
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
        onPressed: _forwardMessages,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          backgroundColor: primaryColor,
        ),
        child: const Text("Forward"),
      ),
    );
  }
}
