import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final List<int> isSelected;
  final String userImage;
  final String userName;
  final VoidCallback? clearSelection;

  CustomAppBar({
    required this.isSelected,
    required this.userImage,
    required this.userName,
    required this.clearSelection,
  });

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return !widget.isSelected.isEmpty
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
              if (widget.isSelected.length == 1) ...[
                IconButton(
                  onPressed: () {
                    // Add reply action here
                  },
                  icon: const Icon(
                    Icons.reply,
                  ), // Reply icon
                ),
              ],
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
                  // Add delete/garbage action here
                },
                icon: const Icon(
                  Icons.delete,
                ), // Garbage icon
              ),
              IconButton(
                onPressed: () {
                  // Add forward action here
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
