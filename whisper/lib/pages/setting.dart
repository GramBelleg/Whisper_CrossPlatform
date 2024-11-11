import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whisper/components/custom-access-button.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/cubit/visibility_cubit.dart';
import 'package:whisper/keys/home-keys.dart';
import 'package:whisper/keys/profile-keys.dart';
import 'package:whisper/keys/visibility_settings_keys.dart';
import 'package:whisper/components/user-state.dart';
import 'package:whisper/cubit/profile-setting-cubit.dart';
import 'package:whisper/pages/blocked-users.dart';
import 'package:whisper/pages/logout-after-reset-password.dart';
import 'package:whisper/pages/visibilitySettings.dart';
import 'package:whisper/services/read-file.dart';
import 'package:whisper/services/uploud-file.dart';
import 'package:whisper/utils/visibility_utils.dart';
import 'package:quickalert/quickalert.dart';
import 'package:whisper/validators/reset-password-validation/confirmation-code-validation.dart';

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
                    nameController: state.nameController,
                    usernameController: state.usernameController,
                    emailController: state.emailController,
                    bioController: state.bioController,
                    phoneController: state.phoneController,
                    nameState: state.nameState,
                    usernameState: state.usernameState,
                    emailState: state.emailState,
                    phoneNumberState: state.phoneNumberState,
                    bioState: state.bioState,
                  );
                }
                return const Center(child: Text("An State occurred."));
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
  final TextEditingController nameController;
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController bioController;
  final TextEditingController phoneController;
  final String nameState;
  final String usernameState;
  final String emailState;
  final String phoneNumberState;
  final String bioState;
  const SettingsContent({
    Key? key,
    required this.userState,
    required this.isEditing,
    required this.nameController,
    required this.usernameController,
    required this.emailController,
    required this.bioController,
    required this.phoneController,
    required this.nameState,
    required this.usernameState,
    required this.emailState,
    required this.phoneNumberState,
    required this.bioState,
  }) : super(key: key);

  @override
  _SettingsContentState createState() => _SettingsContentState();
}

class _SettingsContentState extends State<SettingsContent> {
  final ImagePicker _picker = ImagePicker(); // ImagePicker instance
// Save changes method with success indicators
  File? _image; // Variable to hold the picked image

  Future<bool> _confirmCode(String email) async {
    if (email != widget.userState?.email) {
      final response =
          await context.read<SettingsCubit>().sendCode(email, context);
      print("code sendeddddddddddddddddddddddddddddd");
      // Check if response was successful
      if (response['success'] == true) {
        _showCustomAlertDialogCode(email, context);
      }
    } else {
      // Set state if email is the same as the current one
      context.read<SettingsCubit>().setEmailState("Same Email");
    }

    return true;
  }

  void _showCustomAlertDialogCode(String email, BuildContext context) {
    var message = '';
    QuickAlert.show(
      borderRadius: 30.0,
      backgroundColor: Color(0xFF0A254A),
      headerBackgroundColor: Color(0xFF0A254A),
      context: context,
      type: QuickAlertType.custom,
      barrierDismissible: true,
      confirmBtnText: 'Submit',
      confirmBtnColor: Color(0xff8D6AEE),
      customAsset: 'assets/images/whisper-logo.png',
      widget: TextFormField(
        decoration: InputDecoration(
          alignLabelWithHint: true,
          hintText: 'Enter Your Code',
          hintStyle: TextStyle(
            color: Color(0xFFfbfbfb)
                .withOpacity(0.7), // Hint color with opacity for visibility
            fontSize: 18, // Larger hint text size
          ),
          filled: true,
          fillColor: Colors.transparent, // Transparent background
          contentPadding:
              EdgeInsets.symmetric(vertical: 10), // Reduces field height
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Color(0xFF0A254A)), // Border color when not focused
            borderRadius:
                BorderRadius.circular(60), // Optional: Rounded borders
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Color(0xFF0A254A)), // Border color when focused
            borderRadius: BorderRadius.circular(60),
          ),
        ),
        style: TextStyle(
          color: Color(0xFFfbfbfb), // Text color
          fontSize: 18, // Larger font size for entered text
        ),
        textAlign: TextAlign.center, // Center-aligns text inside the field
        keyboardType: TextInputType.text,
        showCursor: false,
        onChanged: (value) => message = value,
      ),
      onConfirmBtnTap: () async {
        if (message.length < 6) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(ValidateConfirmationCode(message) as String),
            ),
          );
          return;
        }
        //verify my code
        print("the code is:           " + message);
        final response = await context
            .read<SettingsCubit>()
            .verifyCode(message, email, context);
        if (response['success']) {
          context.read<SettingsCubit>().setEmailState("Updated");
          Navigator.pop(context);
        }
      },
    );
  }

  void _saveChanges(BuildContext context) async {
    bool success = true;
    // Check if name is updated
    if (widget.nameController.text != widget.userState?.name) {
      final response = await context
          .read<SettingsCubit>()
          .updateField(widget.nameController.text, 'name');
      success &= response['success'];
      context.read<SettingsCubit>().setNameState(response['message']);
    }

    // Check if username is updated
    if (widget.usernameController.text != widget.userState?.username) {
      final response = await context
          .read<SettingsCubit>()
          .updateField(widget.usernameController.text, 'username');
      success &= response['success'];
      context.read<SettingsCubit>().setUsernameState(response['message']);
    }

    // Check if phone is updated
    if (widget.phoneController.text != widget.userState?.phoneNumber) {
      final response = await context
          .read<SettingsCubit>()
          .updateField(widget.phoneController.text, 'phoneNumber');
      success &= response['success'];
      context.read<SettingsCubit>().setPhoneNumberState(response['message']);
    }

    // Check if bio is updated
    if (widget.bioController.text != widget.userState?.bio) {
      final response = await context
          .read<SettingsCubit>()
          .updateField(widget.bioController.text, 'bio');
      success &= response['success'];
      context.read<SettingsCubit>().setBioState(response['message']);
    }

    if (success) {
      context.read<SettingsCubit>().toggleEditing();
      context.read<SettingsCubit>().resetStateMessages();
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
                    key: SettingsPageKeys.doneButton,
                    onPressed: () {
                      _saveChanges(context);
                    },
                    child: Text(
                      "Done",
                      style: TextStyle(color: Color(0xFFFBFBFB), fontSize: 18),
                    ),
                  ),
                )
              ]
            : [
                IconButton(
                  key: SettingsPageKeys.editButton,
                  icon: Icon(Icons.edit, color: secondNeutralColor),
                  onPressed: () {
                    context.read<SettingsCubit>().toggleEditing();
                  },
                )
              ],
        title: widget.isEditing
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    key: SettingsPageKeys.cancelButton,
                    onPressed: () {
                      context.read<SettingsCubit>().toggleEditing();
                      context.read<SettingsCubit>().resetStateMessages();
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Color(0xFFFBFBFB), fontSize: 18),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15),
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
                            privacyState['addMeToGroups'] ??
                                "No Backend Endpoint",
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
                ),
                CustomAccessButton(
                  key: Key(HomeKeys.logoutButtonKey),
                  label: "Logout",
                  onPressed: () {
                    Navigator.pushNamed(context, LogoutAfterResetPassword.id);
                  },
                )
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String value, String label, IconData icon) {
    return InkWell(
      key: Key(label + SettingsPageKeys.row),
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

// Function to build the profile section
  Widget _buildProfileSection() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // Gray scale photo
              InkWell(
                key: SettingsPageKeys.picUpdatePicInkWell,
                onTap: () {
                  if (widget.isEditing) {
                    // Show options to pick an image
                    _showImageSourceDialog();
                  }
                },
                splashColor: Colors.transparent, // Remove splash color
                highlightColor: Colors.transparent, // Remove highlight color
                child: CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.grey,
                  child: ClipOval(
                    child: ColorFiltered(
                      colorFilter: widget.isEditing
                          ? ColorFilter.mode(
                              Colors.grey, // Apply gray filter when editing
                              BlendMode.saturation, // Desaturate the color
                            )
                          : ColorFilter.mode(
                              Colors.transparent, // No filter when not editing
                              BlendMode.saturation,
                            ),
                      child: widget.userState!.profilePic == ''
                          ? Image.network(
                              'https://ui-avatars.com/api/?background=8D6AEE&size=128&color=fff&name=${formatName(widget.userState!.name)}', // Default online avatar URL
                              fit: BoxFit.cover,
                              width: 140,
                              height: 140,
                            )
                          : Image.network(
                              widget.userState!
                                  .profilePic, // Display the picked image
                              fit: BoxFit.cover,
                              width: 140,
                              height: 140,
                            ),
                    ),
                  ),
                ),
              ),
              // Camera icon overlay with action
              if (widget.isEditing) ...[
                Positioned(
                  child: InkWell(
                    key: SettingsPageKeys.iconUpdatePicInkWell,
                    onTap: () {
                      // Open the dialog to pick an image
                      _showImageSourceDialog();
                    },
                    splashColor: Colors.transparent, // Remove splash color
                    highlightColor:
                        Colors.transparent, // Remove highlight color
                    child: Icon(
                      Icons.camera_alt, // Camera icon
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          if (!widget.isEditing) ...[
            Text(
              widget.userState!.name,
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 4),
            Text(
              widget.userState?.status == "Online" ? "Online" : "Offline",
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

  String formatName(String fullName) {
    List<String> names = fullName.split(" ");

    if (names.length > 1) {
      // Get the first and last name
      return "${names[0]}+${names[names.length - 1]}";
    } else {
      // If only one name is present, return as is
      return fullName;
    }
  }

// Function to show dialog for image source
  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF0A254A), // Set dialog background color
          title: Center(
            child: const Text(
              'Choose an Option',
              style: TextStyle(
                  color: Colors.white), // Set title text color to white
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Center(
                  key: SettingsPageKeys.takePhotoListTile,
                  child: const Text(
                    'Take Photo',
                    style: TextStyle(
                        color: Colors.white), // Set text color to white
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromCamera();
                },
              ),
              ListTile(
                key: SettingsPageKeys.selectPhotoListTile,
                title: Center(
                  child: const Text(
                    'Select from Gallery',
                    style: TextStyle(
                        color: Colors.white), // Set text color to white
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromGallery();
                },
              ),
              ListTile(
                key: SettingsPageKeys.removePhotoListTile,
                title: Center(
                  child: const Text(
                    'Remove Photo',
                    style: TextStyle(
                        color: Colors.white), // Set text color to white
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _removeImage();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImageFromGallery() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      String blobName = await uploadFile(pickedFile.path);
      await context.read<SettingsCubit>().updateProfilePic(blobName);
    } else {
      print('No image selected.');
    }
  }

  // Function to take a photo using the camera
  Future<void> _pickImageFromCamera() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      String blobName = await uploadFile(pickedFile.path);
      await context.read<SettingsCubit>().updateProfilePic(blobName);
    } else {
      print('No image selected.');
    }
  }

  // Function to remove a photo
  Future<void> _removeImage() async {
    await context.read<SettingsCubit>().removeProfilePic();
  }

  Widget _buildEditFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          widget.bioController,
          'Bio',
          StateText: widget.bioState,
        ),
        _buildTextField(
          widget.nameController,
          'Name',
          StateText: widget.nameState,
        ),
        _buildTextField(
          widget.usernameController,
          'Username',
          StateText: widget.usernameState,
        ),
        _buildTextField(
          widget.phoneController,
          'Phone Number',
          StateText: widget.phoneNumberState,
        ),
        _buildTextField(widget.emailController, 'Email',
            StateText: widget.emailState, needCode: true),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      {String? StateText, bool needCode = false}) {
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
            if (StateText != null &&
                StateText.isNotEmpty &&
                StateText ==
                    "Updated") // Show green circle if field is successfully updated
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  StateText,
                  style:
                      const TextStyle(color: Color(0xFF4CB9CF), fontSize: 14),
                ),
              ),
            if (StateText != null &&
                StateText.isNotEmpty &&
                StateText != "Updated")
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  StateText,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),
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
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  key: Key("$labelText${SettingsPageKeys.textField}"),
                  controller: controller,
                  style: const TextStyle(color: Color(0xFFFBFBFB)),
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: InputBorder.none,
                  ),
                ),
              ),
              if (needCode)
                TextButton(
                  key: SettingsPageKeys.sendCodeButton,
                  onPressed: () {
                    _confirmCode(widget.emailController.text);
                    print("Send Code pressed");
                  },
                  child: const Text("Send Code"),
                  style: TextButton.styleFrom(
                    foregroundColor: Color(0xFF4CB9CF),
                    padding:
                        EdgeInsets.symmetric(horizontal: 12), // Button padding
                  ),
                ),
            ],
          ),
        ),
      ],
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
