import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/cubit/messages-cubit.dart';
import 'package:whisper/global-cubit-provider.dart';
import 'package:whisper/pages/chat-page.dart';
import 'package:whisper/services/fetch-message-by-id.dart';
import 'package:whisper/services/friend-service.dart';
import 'package:whisper/services/shared-preferences.dart';
import 'package:whisper/widget/forward-menu-header.dart';
import 'package:whisper/widget/friend-list-item.dart';
import 'package:whisper/widget/selected-friends-chip.dart';
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
      final token = await GetToken();
      final senderId = await GetId();

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
        final message =
            await fetchMessage(messageId); // Fetch the message details
        GlobalCubitProvider.messagesCubit.sendMessage(
              content: message.content, // Message content
              chatId: friend.id, // Chat ID of the friend
              senderId: senderId, // Current sender's ID
              parentMessage: message.parentMessage, // Parent message (if any)
              senderName: friend.name, // Friend's name
              isReplying: false, // Is it a reply?
              isForward: true, // Is it a forwarded message?
              forwardedFromUserId:
                  message.sender?.id, // Original sender's ID (if applicable)
            );
        debugPrint("Message forwarded to: ${friend.name}");
      } catch (e) {
        debugPrint(
            'Failed to forward message $messageId to ${friend.name}: $e');
      }
    }
  }

  void _navigateAfterForwarding(String? token, int? senderId) {
    if (_selectedFriendIndexes.length == 1) {
      final friend = _friends[_selectedFriendIndexes.first];
      Navigator.pop(context); // Close the forward menu
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
      Navigator.pop(context); // Close the forward menu
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
