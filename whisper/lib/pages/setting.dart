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
}
