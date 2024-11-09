import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/cubit/visibility_cubit.dart';
import 'package:whisper/keys/visibility_settings_keys.dart';
import 'package:whisper/components/user-state.dart'; // Your UserState model
import 'package:whisper/cubit/profile-setting-cubit.dart';
import 'package:whisper/pages/blocked-users.dart';
import 'package:whisper/pages/profile-picture-settings.dart';
import 'package:whisper/pages/visibilitySettings.dart';
import 'package:whisper/utils/visibility_utils.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Load user state when the page is built
    context.read<SettingsCubit>().loadUserState();

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<SettingsCubit, SettingsState>(
              builder: (context, state) {
                if (state is SettingsInitial) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is SettingsLoaded) {
                  return SettingsContent(
                    userState: state.userState,
                    isEditing: state.isEditing,
                  );
                }
                return const Center(child: Text("An error occurred."));
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsContent extends StatefulWidget {
  final UserState? userState;
  final bool isEditing;

  const SettingsContent(
      {Key? key, required this.userState, required this.isEditing})
      : super(key: key);

  @override
  _SettingsContentState createState() => _SettingsContentState();
}

class _SettingsContentState extends State<SettingsContent> {
  late TextEditingController nameController;
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController bioController;
  late TextEditingController phoneController;

  String usernameError = '';
  String emailError = '';

  // Success indicators for each field
  bool isNameUpdated = false;
  bool isUsernameUpdated = false;
  bool isPhoneUpdated = false;
  bool isEmailUpdated = false;
  bool isBioUpdated = false;

  // Initialize text controllers
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.userState?.name);
    usernameController =
        TextEditingController(text: widget.userState?.username);
    emailController = TextEditingController(text: widget.userState?.email);
    bioController = TextEditingController(text: widget.userState?.bio);
    phoneController =
        TextEditingController(text: widget.userState?.phoneNumber);
  }

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    bioController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  // Save changes method with success indicators
  Future<void> _saveChanges(BuildContext context) async {
    bool success = true;

    if (nameController.text != widget.userState?.name) {
      isNameUpdated =
          await context.read<SettingsCubit>().updateName(nameController.text);
      success &= isNameUpdated;
    }

    if (usernameController.text != widget.userState?.username) {
      isUsernameUpdated = await context
          .read<SettingsCubit>()
          .updateUsername(usernameController.text);
      success &= isUsernameUpdated;
    }

    if (phoneController.text != widget.userState?.phoneNumber) {
      isPhoneUpdated = await context
          .read<SettingsCubit>()
          .updatePhoneNumber(phoneController.text);
      success &= isPhoneUpdated;
    }

    if (emailController.text != widget.userState?.email) {
      isEmailUpdated = await context
          .read<SettingsCubit>()
          .sendEmailCode(emailController.text);
      success &= isEmailUpdated;
    }

    if (bioController.text != widget.userState?.bio) {
      isBioUpdated =
          await context.read<SettingsCubit>().updateBio(bioController.text);
      success &= isBioUpdated;
    }

    if (success) {
      context.read<SettingsCubit>().toggleEditing();
      resetUpdateFlags();
      setState(() {}); // Rebuild UI to show indicators
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$text copied to clipboard!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: firstNeutralColor,
      appBar: AppBar(
        backgroundColor: firstNeutralColor,
        actions: widget.isEditing
            ? [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextButton(
                    onPressed: () {
                      _saveChanges(context);
                    },
                    child: Text(
                      "Done",
                      style: TextStyle(color: Color(0xFFFBFBFB), fontSize: 18),
                    ),
                  ),
                ),
              ]
            : [
                IconButton(
                  icon: Icon(Icons.edit, color: secondNeutralColor),
                  onPressed: () {
                    context.read<SettingsCubit>().toggleEditing();
                  },
                ),
              ],
        title: widget.isEditing
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      resetUpdateFlags();
                      context.read<SettingsCubit>().toggleEditing();
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: primaryColor, fontSize: 18),
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
            if (widget.isEditing)
              _buildEditFields(), // Show edit fields if in editing mode
            if (!widget.isEditing) ...[
              SizedBox(height: 30),
              _buildInfoRow(
                  widget.userState!.phoneNumber, 'Phone', Icons.phone),
              _buildInfoRow(
                  widget.userState!.username, 'Username', Icons.person),
              _buildInfoRow(widget.userState!.email, 'Email', Icons.email),
            ],
            if (!widget.isEditing) SizedBox(height: 8),
            if (!widget.isEditing)
              const Divider(
                color: Color(0xFF0A254A),
                thickness: 4.0,
              ),
            if (!widget.isEditing) SizedBox(height: 8),
            if (!widget.isEditing) ...[
              Text(
                "Privacy Settings",
                style: TextStyle(
                  color: primaryColor,
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
                  VisibilitySettingsKeys.visibilitySettingsTile),
              _buildPrivacyCard(
                  'Blocked Users',
                  FontAwesomeIcons.userSlash,
                  const BlockedUsersPage(),
                  VisibilitySettingsKeys.blockedUsersTile),
              SizedBox(
                height: 6,
              ),
              BlocBuilder<VisibilityCubit, Map<String, dynamic>>(
                builder: (context, privacyState) {
                  return ListTile(
                    key: VisibilitySettingsKeys.addMeToGroupsTile,
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Who can add me to groups?",
                            style: TextStyle(color: secondNeutralColor)),
                        Text(
                          privacyState['addMeToGroups'] ?? "No Backend Endpoint",
                          style:
                              TextStyle(color: primaryColor.withOpacity(0.6)),
                        )
                      ],
                    ),
                    onTap: () {
                      if (kDebugMode) print("add me to groups");
                      showVisibilityOptions(
                        context,
                        "Who can add me to groups?",
                        privacyState['addMeToGroups'],
                        (value) {
                          context
                              .read<VisibilityCubit>()
                              .updateAddMeToGroupsVisibility(value);
                        },
                      );
                    },
                  );
                },
              )
            ]
          ]),
        ),
      ),
    );
  }

// Method to reset all update flags
  void resetUpdateFlags() {
    setState(() {
      isNameUpdated = false;
      isUsernameUpdated = false;
      isPhoneUpdated = false;
      isEmailUpdated = false;
      isBioUpdated = false;
    });
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
                    'assets/images/el-gayar.jpg',
                    fit: BoxFit.cover,
                    width: 140,
                    height: 140,
                  ),
                ),
              ),
              if (!widget.isEditing)
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: primaryColor,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.add, size: 24),
                    color: secondNeutralColor,
                    onPressed: () {
                      // Add functionality to upload a profile picture
                    },
                  ),
                ),
            ],
          ),
          if (widget.isEditing)
            PopupMenuButton<String>(
              onSelected: (value) {
                print("Selected: $value");
                // Logic for selecting profile picture options
              },
              itemBuilder: (BuildContext context) => [
                PopupMenuItem<String>(
                  value: 'Camera',
                  child: const Text('Take Photo'),
                ),
                PopupMenuItem<String>(
                  value: 'Gallery',
                  child: const Text('Select from Gallery'),
                ),
                PopupMenuItem<String>(
                  value: 'Remove',
                  child: const Text('Remove Photo'),
                ),
              ],
              child: TextButton(
                onPressed: null,
                style: TextButton.styleFrom(
                  foregroundColor: primaryColor, // Set the text color
                  backgroundColor: Colors.transparent,
                ),
                child: const Text(
                  "Set New Photo",
                  style: TextStyle(
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 16),
          if (!widget.isEditing) ...[
            Text(
              widget.userState!.name,
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 4),
            Text(
              widget.userState?.status == "Online" ? "Online" : "offline",
              style: TextStyle(
                color: widget.userState?.status == "Online"
                    ? const Color(0xFF4CB9CF)
                    : Colors.grey,
              ),
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
        _buildTextField(nameController, 'Name', isUpdated: isNameUpdated),
        _buildTextField(usernameController, 'Username',
            errorText: usernameError, isUpdated: isUsernameUpdated),
        _buildTextField(phoneController, 'Phone Number',
            isUpdated: isPhoneUpdated),
        _buildTextField(emailController, 'Email',
            errorText: emailError, isUpdated: isEmailUpdated),
        _buildTextField(bioController, 'Bio', isUpdated: isBioUpdated),
      ],
    );
  }

  // Modified text field to show success indicator
  Widget _buildTextField(TextEditingController controller, String labelText,
      {String? errorText, bool isUpdated = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              labelText,
              style: const TextStyle(
                color: Color(0xff8D6AEE),
                fontSize: 15,
              ),
            ),
            if (isUpdated) // Show green circle if field is successfully updated
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Icon(Icons.check_circle, color: Colors.green, size: 16),
              ),
          ],
        ),
        const SizedBox(height: 5),
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFF0A254A),
            borderRadius: BorderRadius.circular(25),
          ),
          child: TextField(
            controller: controller,
            style: const TextStyle(color: Color(0xFFFBFBFB)),
            decoration: const InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String value, String label, IconData icon) {
    return InkWell(
      onTap: () => _copyToClipboard(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 13.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(value,
                  style:
                      const TextStyle(color: Color(0xFFFBFBFB), fontSize: 18)),
            ),
            Text(label,
                style: const TextStyle(color: Colors.grey, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyCard(
      String setting, IconData icon, Widget targetPage, Key key) {
    return SizedBox(
      child: Card(
        color: const Color(0xFF1A1E2D),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        child: InkWell(
          key: key,
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => targetPage));
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
                      style: TextStyle(color: secondNeutralColor, fontSize: 15),
                    ),
                  ],
                ),
                const Icon(Icons.arrow_forward_ios, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
