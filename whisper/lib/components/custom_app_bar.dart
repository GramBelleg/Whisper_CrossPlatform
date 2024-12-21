import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/keys/custom_app_bar_keys.dart';
import 'package:whisper/models/chat.dart';
import 'package:whisper/pages/forward_menu.dart';
import 'package:whisper/services/calls_service.dart';
import 'package:whisper/pages/group_info.dart';
import 'package:whisper/services/fetch_chat_messages.dart';
import 'package:whisper/view-models/custom_app_bar_view_model.dart';
import '../pages/call_page.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final List<int> isSelected; // List of selected message IDs
  //final String? userImage;
  //final String userName;
  //final int chatId;
  Chat chat;
  final VoidCallback? clearSelection;
  final ChatViewModel chatViewModel; // Add ChatViewModel to the constructor
  final bool editable;
  // final String chatType;
  // final bool isAdmin;
  final bool deleteDisable;
  CustomAppBar({
    super.key,
    required this.isSelected,
    // required this.userImage,
    // required this.userName,
    required this.clearSelection,
    required this.chatViewModel, // Initialize ChatViewModel
    // required this.chatId,
    required this.editable,
    required this.chat,
    // required this.chatType,
    // required this.chatType,
    // required this.isAdmin,
    required this.deleteDisable,
  });

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  late CustomAppBarViewModel viewModel;
  @override
  void initState() {
    super.initState();
    viewModel = CustomAppBarViewModel();
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete these items?'),
          actions: <Widget>[
            TextButton(
              key: Key(CustomAppBarKeys.deleteForMeButton),
              onPressed: () {
                _deleteForMe(context); // Handle "Delete for Me" action
              },
              child: Text('Delete for Me'),
            ),
            TextButton(
              key: Key(CustomAppBarKeys.deleteForEveryoneButton),
              onPressed: () {
                _deleteForEveryone(
                    context); // Handle "Delete for Everyone" action
              },
              child: Text('Delete for Everyone'),
            ),
            TextButton(
              key: Key(CustomAppBarKeys.cancelButton),
              onPressed: () {
                Navigator.of(context).pop(); // Handle "Cancel" action
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _deleteForMe(BuildContext context) async {
    if (widget.isSelected.isNotEmpty) {
      try {
        // Call the deleteMessage method from the MessagesCubit

        await viewModel.deleteMessagesForMe(
            widget.chat.chatId, widget.isSelected);

        // Clear the selection after deletion
        if (widget.clearSelection != null) {
          widget.clearSelection!();
        }

        Navigator.of(context).pop(); // Close the dialog
      } catch (e) {
        // Handle any errors that occur during deletion
        print('Error deleting messages: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting messages: $e')),
        );
      }
    } else {
      Navigator.of(context)
          .pop(); // Close the dialog if no messages are selected
    }
  }

  void _deleteForEveryone(BuildContext context) async {
    if (widget.isSelected.isNotEmpty) {
      try {
        await viewModel.deleteMessagesForEveryone(
            widget.chat.chatId, widget.isSelected);
        if (widget.clearSelection != null) {
          widget.clearSelection!();
        }

        Navigator.of(context).pop();
      } catch (e) {
        print('Error deleting messages for everyone: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting messages for everyone: $e')),
        );
      }
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.isSelected.isNotEmpty
        ? AppBar(
            iconTheme: IconThemeData(
              color: primaryColor, // Color for the icons
            ),
            backgroundColor: firstNeutralColor,
            leadingWidth: 100,
            leading: Row(
              children: [
                IconButton(
                  key: Key(CustomAppBarKeys.backButton),
                  icon: const Icon(
                    Icons.arrow_back,
                  ), // Back arrow icon
                  onPressed: () {
                    setState(() {
                      if (widget.clearSelection != null) {
                        widget.clearSelection!();
                      }
                    });
                  },
                ),
                Text(
                  '${widget.isSelected.length}', // Display size of isSelected
                  style: TextStyle(color: primaryColor, fontSize: 18),
                ),
              ],
            ),
            actions: [
              if (widget.isSelected.length == 1) ...[],
              !widget.deleteDisable
                  ? IconButton(
                      key: Key(CustomAppBarKeys.deleteIcon),
                      onPressed: () {
                        _showDeleteDialog(context);
                      },
                      icon: const Icon(
                        Icons.delete,
                      ), // Garbage icon
                    )
                  : Container(),
              IconButton(
                key: Key(CustomAppBarKeys.forwardIcon),
                onPressed: () {
                  // Add forward action here
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => ForwardMenu(
                      text: "Forward",
                      onClearSelection: widget.clearSelection!,
                      selectedMessageIds: widget.isSelected,
                      isForward: true,
                    ),
                  );
                },
                icon: const Icon(
                  Icons.forward,
                ), // Forward icon
              ),
              if (widget.isSelected.length == 1 &&
                  !(!widget.editable && widget.deleteDisable)) ...[
                PopupMenuButton<String>(
                  key: Key(CustomAppBarKeys.popupMenu),
                  onSelected: (value) {
                    // Handle menu selection
                    if (value == 'Pin') {
                      // Handle pin action
                    } else if (value == 'Edit') {
                      viewModel.editMessage(
                        widget.isSelected.first,
                      );
                      if (widget.clearSelection != null) {
                        widget.clearSelection!();
                      }
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      key: Key(CustomAppBarKeys.popupPin),
                      value: 'Pin',
                      child: Text('Pin'),
                      //todo if messages is pin make text unpin
                    ),
                    if (widget.editable)
                      const PopupMenuItem(
                        key: Key(CustomAppBarKeys.popupEdit),
                        value: 'Edit',
                        child: Text('Edit'),
                      ),
                  ],
                ),
              ],
            ],
          )
        : AppBar(
            iconTheme: IconThemeData(
              color: primaryColor, // Default color for icons
            ),
            backgroundColor: firstNeutralColor,
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
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.blueGrey,
                  backgroundImage: widget.chat.avatarUrl != null
                      ? NetworkImage(widget.chat.avatarUrl!)
                      : null,
                  child: widget.chat.avatarUrl == null
                      ? const Icon(Icons.person)
                      : null,
                ),
              ],
            ),
            title: InkWell(
              onTap: () {
                // print("aaaaaaaa ${widget.chat.t},,${widget.isAdmin}");
                if (widget.chat.type == 'GROUP' ||
                    widget.chat.type == 'CHANNEL') {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          GroupInfo(
                        isChannel: widget.chat.type == 'CHANNEL',
                        isChannelAdmin: widget.chat.isAdmin &&
                            widget.chat.type == 'CHANNEL',
                        isGroupAdmin:
                            widget.chat.isAdmin && widget.chat.type == 'GROUP',
                        groupName: widget.chat.userName,
                        profilePicture: widget.chat.avatarUrl,
                        groupId: widget.chat.chatId,
                      ),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        const begin = Offset(0.0, 1.0); // Start from bottom
                        const end = Offset.zero; // End at original position
                        const curve = Curves.ease;

                        var tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));
                        var offsetAnimation = animation.drive(tween);

                        return SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        );
                      },
                    ),
                  );
                }
              },
              child: Container(
                margin: const EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.chat.userName,
                        style:
                            const TextStyle(fontSize: 19, color: Colors.white)),
                    Text("last seen today at ${widget.chat.lastSeen}",
                        style: TextStyle(fontSize: 13, color: Colors.white)),
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
                onPressed: () async {
                  String callToken =
                      await CallsService.makeACall(context, widget.chat.chatId);
                  print("CHAT ID : ${widget.chat.chatId}");
                  print("CALL TOKEEN : $callToken");
                  Navigator.pushNamed(
                    context,
                    Call.id,
                    arguments: {
                      'token': callToken,
                      'chatId': "chat-${widget.chat.chatId}",
                    },
                  );
                },
                icon: const FaIcon(FontAwesomeIcons.phone),
              ),
            ],
          );
  }
}
