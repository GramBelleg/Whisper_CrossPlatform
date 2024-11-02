import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final bool isOnline = true; // Change to false to test offline status
  bool isEditing = false; // Track if in edit mode

  final TextEditingController nameController =
      TextEditingController(text: 'Amr Saad');
  final TextEditingController usernameController =
      TextEditingController(text: 'User123');
  final TextEditingController phoneController =
      TextEditingController(text: '+012222222');
  final TextEditingController emailController =
      TextEditingController(text: 'maroo@gmail.com');
  final TextEditingController bioController =
      TextEditingController(); // Bio can be set later

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFF0A122F),
        appBar: AppBar(
          backgroundColor: Color(0xFF0A122F),
          title: Text('Settings'),
        ),
        body: Container(),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 70,
            backgroundColor: Colors.grey,
            child: ClipOval(
              child: Image.asset(
                'assets/images/el-gayar.jpg', // Replace with your image asset path
                fit: BoxFit.cover,
                width: 140,
                height: 140,
              ),
            ),
          ),
          // Display name and online status
          Text(
            nameController.text,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          SizedBox(height: 4),
          Text(
            isOnline ? 'Online' : 'Offline',
            style: TextStyle(color: isOnline ? Color(0xFF4CB9CF) : Colors.grey),
          ),
        ],
      ),
    );
  }
}
