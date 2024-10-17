import 'package:flutter/material.dart';
import 'package:draggable_home/draggable_home.dart';
import '../components/tap-bar.dart';
import '../components/stories-widget.dart';

class MainChats extends StatefulWidget {
  static const String id = 'main_chats_page'; // Define the static id here
  const MainChats({super.key});

  @override
  _MainChatsState createState() => _MainChatsState();
}

class _MainChatsState extends State<MainChats> {
  int _selectedIndex = 0; // Initialize the selected index
  final ScrollController _scrollController =
      ScrollController(); // Create a ScrollController

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: buildBottomNavigationBar(
        _selectedIndex,
        (index) {
          setState(() {
            _selectedIndex = index; // Update the selected index
          });
        },
      ),
      body: DraggableHome(
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                // Event when "Edit" is tapped
                print('Edit tapped'); // Replace with desired action
              },
              child: const Text(
                "Edit",
                style: TextStyle(
                  color: Color(0xff8D6AEE), // Edit text color
                  fontSize: 16, // Edit text size
                ),
              ),
            ),
            const SizedBox(width: 20), // Space between "Edit" and "Chats"
            const Expanded(
              child: Center(
                child: Text(
                  "Chats",
                  style: TextStyle(
                    color: Color(0xff8D6AEE),
                    fontWeight: FontWeight.bold,
                    fontSize: 24, // Increased font size
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: SizedBox(
              width: 20.0, // Set custom width
              height: 20.0, // Set custom height
              child: Image.asset(
                "assets/images/IconStory.png",
                fit: BoxFit.cover,
              ),
            ),
            onPressed: () {
              // Scroll to the top of the body
              _scrollController.animateTo(
                0, // Scroll to the top
                duration:
                    const Duration(milliseconds: 300), // Animation duration
                curve: Curves.easeInOut, // Animation curve
              );
            },
          ),
        ],
        headerWidget: headerWidget(context), // Call updated headerWidget
        body: [
          _body(), // Call the _body method for the draggable content
        ],
        fullyStretchable: true,
        expandedBody: const StoryPage(userIndex: 0, withCloseIcon: false),
        backgroundColor: const Color(0xFF0A122F),
        appBarColor: const Color(0xFF0A122F),
        scrollController: _scrollController, // Set the ScrollController
      ),
    );
  }

  Widget headerWidget(BuildContext context) {
    return Container(
      color: const Color(0xff8D6AEE),
      child: Column(
        children: [
          // Header title
          Padding(
            padding: const EdgeInsets.all(50.0), // Add padding around the title
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Stories",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Story circles using 'stories_for_flutter'
          Flexible(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: sampleUsers.length, // Number of users
              itemBuilder: (context, index) {
                final user = sampleUsers[index]; // Get the current user
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to the user's stories when tapped
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StoryPage(userIndex: index),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              user.imageUrl), // Display the user's image
                          radius: 30,
                        ),
                        const SizedBox(height: 5),
                        Text(user.userName), // Display the user's name
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _body() {
    return Container();
  }
}
