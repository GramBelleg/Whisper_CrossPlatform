import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:whisper/pages/blocked-users.dart';
import 'package:whisper/pages/profile-picture-settings.dart';
import 'package:whisper/pages/visibilitySettings.dart';

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

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$text copied to clipboard!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFF0A122F),
        appBar: AppBar(
          backgroundColor: Color(0xFF0A122F),
          actions: isEditing
              ? [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextButton(
                      onPressed: _saveChanges,
                      child: Text(
                        "Done",
                        style:
                            TextStyle(color: Color(0xff8D6AEE), fontSize: 18),
                      ),
                    ),
                  ),
                ]
              : [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        isEditing = true; // Enter edit mode
                      });
                    },
                  ),
                ],
          title: isEditing
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: _cancelEdit,
                      child: Text(
                        "Cancel",
                        style:
                            TextStyle(color: Color(0xff8D6AEE), fontSize: 18),
                      ),
                    ),
                    SizedBox(width: 60), // Placeholder for alignment
                  ],
                )
              : null,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _buildProfileSection(),
              if (isEditing)
                _buildEditFields(), // Show edit fields if in editing mode
              if (!isEditing) ...[
                SizedBox(height: 30),
                _buildInfoRow(
                    context, phoneController.text, 'Phone', Icons.phone),
                _buildInfoRow(
                    context, usernameController.text, 'Username', Icons.person),
                _buildInfoRow(
                    context, emailController.text, 'Email', Icons.email),
              ],
              if (!isEditing) SizedBox(height: 8),
              if (!isEditing) Divider(color: Colors.grey),
              if (!isEditing) SizedBox(height: 8),
              if (!isEditing) ...[
                Text(
                  "Privacy Settings",
                  style: TextStyle(
                    color: Color(0xff8D6AEE),
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                    height: 16), // Add vertical space between title and buttons
                // Privacy Settings buttons
                _buildPrivacyCard(
                  'Visibility Settings',
                  FontAwesomeIcons.eye,
                  const VisibilitySettingsPage(),
                ),
                _buildPrivacyCard(
                  'Blocked Users',
                  FontAwesomeIcons.userSlash,
                  const BlockedUsersPage(),
                ),
                _buildPrivacyCard(
                  'Who can see my profile picture?',
                  FontAwesomeIcons.image,
                  const ProfilePictureSettingsPage(),
                ),
              ]
            ]),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.bottomRight,
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
              if (!isEditing)
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xff8D6AEE),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.add, size: 24),
                    color: Colors.white,
                    onPressed: () {
                      // Add functionality to upload a profile picture
                    },
                  ),
                ),
            ],
          ),
          // Show the button for setting a new photo in edit mode
          if (isEditing)
            PopupMenuButton<String>(
              onSelected: (value) {
                // Handle the selected option
                print("Selected: $value");
                // You can replace this print statement with your actual logic
                if (value == 'Camera') {
                  // Logic to take a photo
                } else if (value == 'Gallery') {
                  // Logic to select a photo from the gallery
                } else if (value == 'Remove') {
                  // Logic to remove the profile photo
                }
              },
              itemBuilder: (BuildContext context) => [
                PopupMenuItem<String>(
                  value: 'Camera',
                  child: Text('Take Photo'),
                ),
                PopupMenuItem<String>(
                  value: 'Gallery',
                  child: Text('Select from Gallery'),
                ),
                PopupMenuItem<String>(
                  value: 'Remove',
                  child: Text('Remove Photo'),
                ),
              ],
              child: TextButton(
                onPressed: null, // Disable button click handling
                style: TextButton.styleFrom(
                  foregroundColor: Color(0xff8D6AEE), // Set the text color
                  backgroundColor: Colors.transparent,
                ),
                child: Text(
                  "Set New Photo",
                  style: TextStyle(
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),

          SizedBox(height: 16),
          // Display either the name as a TextField or as text based on editing mode
          if (isEditing)
            TextField(
              controller: nameController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff8D6AEE))),
              ),
            )
          else ...[
            Text(
              nameController.text,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            SizedBox(height: 4),
            Text(
              isOnline ? 'Online' : 'Offline',
              style:
                  TextStyle(color: isOnline ? Color(0xFF4CB9CF) : Colors.grey),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEditFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: usernameController,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Username',
            labelStyle: TextStyle(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xff8D6AEE))),
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: phoneController,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Phone Number',
            labelStyle: TextStyle(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xff8D6AEE))),
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: emailController,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Email',
            labelStyle: TextStyle(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xff8D6AEE))),
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: bioController,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Bio',
            labelStyle: TextStyle(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xff8D6AEE))),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(
      BuildContext context, String value, String label, IconData icon) {
    return InkWell(
      onTap: () => _copyToClipboard(value), // Copy value to clipboard on tap
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 13.0),
        child: Row(
          children: [
            Icon(icon,
                color: Colors.grey, size: 20), // Add icon for each info row
            SizedBox(width: 8), // Spacing between icon and text
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyCard(String setting, IconData icon, Widget targetPage) {
    return SizedBox(
      child: Card(
        color: Color(0xFF1A1E2D),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        child: InkWell(
          onTap: () {
            // Navigate to the target page when tapped
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => targetPage),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(icon, color: Colors.grey),
                    SizedBox(width: 8),
                    Text(
                      setting,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],
                ),
                Icon(Icons.arrow_forward_ios, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveChanges() {
    // Save changes logic here
    setState(() {
      isEditing = false; // Exit edit mode
    });
  }

  void _cancelEdit() {
    setState(() {
      isEditing = false; // Exit edit mode
    });
  }
}
