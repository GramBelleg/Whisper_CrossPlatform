import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whisper/pages/forward-menu.dart';
import 'package:whisper/cubit/messages-cubit.dart';
import 'package:whisper/services/fetch-messages.dart';
import 'package:whisper/view-models/custom-app-bar-view-model.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final List<int> isSelected; // List of selected message IDs
  final String userImage;
  final String userName;
  final int chatId;
  final VoidCallback? clearSelection;
  final ChatViewModel chatViewModel; // Add ChatViewModel to the constructor

  const CustomAppBar({
    super.key,
    required this.isSelected,
    required this.userImage,
    required this.userName,
    required this.clearSelection,
    required this.chatViewModel, // Initialize ChatViewModel
    required this.chatId,
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
              onPressed: () {
                _deleteForMe(context); // Handle "Delete for Me" action
              },
              child: Text('Delete for Me'),
            ),
            TextButton(
              onPressed: () {
                _deleteForEveryone(
                    context); // Handle "Delete for Everyone" action
              },
              child: Text('Delete for Everyone'),
            ),
            TextButton(
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

        await viewModel.deleteMessagesForMe(widget.chatId, widget.isSelected);

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
            widget.chatId, widget.isSelected);
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
      Navigator.of(context)
          .pop(); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.isSelected.isNotEmpty
        ? AppBar(
            iconTheme: const IconThemeData(
              color: Color(0xff8D6AEE), // Color for the icons
            ),
            backgroundColor: const Color(0xff0A122F),
            leadingWidth: 100,
            leading: Row(
              children: [
                IconButton(
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
                  style:
                      const TextStyle(color: Color(0xff8D6AEE), fontSize: 18),
                ),
              ],
            ),
            actions: [
              if (widget.isSelected.length == 1) ...[],
              IconButton(
                onPressed: () {
                  // Add favorite action here
                },
                icon: const Icon(
                  Icons.favorite,
                ), // Favorite icon
              ),
              IconButton(
                onPressed: () {
                  // Show the delete dialog when the delete icon is pressed
                  _showDeleteDialog(context);
                },
                icon: const Icon(
                  Icons.delete,
                ), // Garbage icon
              ),
              IconButton(
                onPressed: () {
                  // Add forward action here
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => ForwardMenu(
                      onClearSelection: widget.clearSelection!,
                      selectedMessageIds: widget.isSelected,
                    ),
                  );
                },
                icon: const Icon(
                  Icons.forward,
                ), // Forward icon
              ),
              if (widget.isSelected.length == 1) ...[
                PopupMenuButton<String>(
                  onSelected: (value) {
                    // Handle menu selection
                    if (value == 'Info') {
                      // Handle info action
                    } else if (value == 'Pin') {
                      // Handle pin action
                    } else if (value == 'Edit') {
                      // Handle edit action
                    } else if (value == 'Copy') {
                      // Handle copy action
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'Info',
                      child: Text('Info'),
                    ),
                    const PopupMenuItem(
                      value: 'Pin',
                      child: Text('Pin'),
                      //todo if messages is pin make text unpin
                    ),
                    const PopupMenuItem(
                      value: 'Edit',
                      child: Text('Edit'),
                    ),
                    const PopupMenuItem(
                      value: 'Copy',
                      child: Text('Copy'),
                    ),
                  ],
                ),
              ],
            ],
          )
        : AppBar(
            iconTheme: const IconThemeData(
              color: Color(0xff8D6AEE), // Default color for icons
            ),
            backgroundColor: const Color(0xff0A122F),
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
                  backgroundImage: AssetImage(widget.userImage),
                ),
              ],
            ),
            title: InkWell(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.userName,
                        style:
                            const TextStyle(fontSize: 19, color: Colors.white)),
                    const Text("last seen today at 12:05",
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
                onPressed: () {},
                icon: const FaIcon(FontAwesomeIcons.phone),
              ),
              PopupMenuButton<String>(
                onSelected: (String result) {
                  print(result);
                },
                icon: const FaIcon(FontAwesomeIcons.ellipsisV),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'View Contact',
                    child: Text('View Contact'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Media, Links, and Docs',
                    child: Text('Media, Links, and Docs'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Search',
                    child: Text('Search'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Mute Notifications',
                    child: Text('Mute Notifications'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Wallpaper',
                    child: Text('Wallpaper'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'More',
                    child: Text('More'),
                  ),
                ],
              ),
            ],
          );
  }
}
