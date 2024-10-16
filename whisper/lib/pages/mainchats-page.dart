import 'package:flutter/material.dart';
import 'package:draggable_home/draggable_home.dart';
import '../components/tap-bar.dart';

class MainChats extends StatefulWidget {
  static const String id = 'main_chats_page';
  const MainChats({super.key});

  @override
  _MainChatsState createState() => _MainChatsState();
}

class _MainChatsState extends State<MainChats> {
  int _selectedIndex = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: buildBottomNavigationBar(
        _selectedIndex,
        (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: DraggableHome(
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                // Event when "Edit" is tapped
                print('Edit tapped'); //To Do Replace with desired action
              },
              child: const Text(
                "Edit",
                style: TextStyle(
                  color: Color(0xff8D6AEE),
                  fontSize: 16,
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
                    fontSize: 24,
                  ),
                ),
              ),
            ),
          ],
        ),

        headerWidget: headerWidget(context), // Call updated headerWidget
        body: [
          _body(), // Call the _body method for the draggable content
        ],
        fullyStretchable: true,
        backgroundColor: const Color(0xFF0A122F),
        appBarColor: const Color(0xFF0A122F),
        scrollController: _scrollController, // Set the ScrollController
      ),
    );
  }

  Widget headerWidget(BuildContext context) {
    return Container();
  }

  Widget _body() {
    return Container();
  }
}
