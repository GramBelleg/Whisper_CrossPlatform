import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whisper/components/custom-access-button.dart';
import 'package:whisper/components/helpers.dart';
import 'package:whisper/components/users-stories.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/keys/home-keys.dart';
import 'package:whisper/keys/profile-keys.dart';
import 'package:whisper/keys/visibility_settings_keys.dart';
import 'package:whisper/components/user-state.dart';
import 'package:whisper/cubit/profile-setting-cubit.dart';
import 'package:whisper/pages/blocked-users.dart';
import 'package:whisper/pages/story-creation.dart';
import 'package:whisper/pages/user-story.dart';
import 'package:whisper/pages/view-profile-photo.dart';
import 'package:whisper/pages/visibilitySettings.dart';
import 'package:whisper/services/logout_confirmation_dialog.dart';
import 'package:whisper/services/shared-preferences.dart';
import 'package:whisper/services/upload-file.dart';
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
                      style: TextStyle(
                        color: secondNeutralColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ]
            : [
                InkWell(
                  onTap: () {
                    // Action to add a story
                    _navigateToStoryCreationScreen(
                        context); // Call the same function for story creation
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.only(left: .0),
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        key: SettingsPageKeys.addStory,
                        child: Image.asset(
                          'assets/images/IconStory.png',
                          fit: BoxFit
                              .cover, // Ensures the image covers the container
                        ),
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.read<SettingsCubit>().toggleEditing();
                  },
                  child: Text(
                    'Edit',
                    style: TextStyle(
                      color: secondNeutralColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                      style: TextStyle(
                        color: secondNeutralColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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
                CustomAccessButton(
                  key: Key(HomeKeys.logoutFromOneButtonKey),
                  label: "Logout From This Device",
                  onPressed: () {
                    showLogoutConfirmationDialog(context, false);
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                CustomAccessButton(
                  key: Key(HomeKeys.logoutFromAllButtonKey),
                  label: "Logout From All Devices",
                  onPressed: () {
                    showLogoutConfirmationDialog(context, true);
                  },
                )
              ]
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _confirmCode(String email) async {
    if (email != widget.userState?.email) {
      final response =
          await context.read<SettingsCubit>().sendCode(email, context);
      print("code sendeddddddddddddddddddddddddddddd");
      // Check if response was successful
      if (response['success'] == true) {
        _showCustomAlertDialogCode(email, context);
      } else {
        context.read<SettingsCubit>().setEmailState(response['message']);
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
      confirmBtnColor: primaryColor,
      customAsset: 'assets/images/whisper-logo.png',
      widget: TextFormField(
        decoration: InputDecoration(
          alignLabelWithHint: true,
          hintText: 'Enter Your Code',
          hintStyle: TextStyle(
            color: secondNeutralColor
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
          color: secondNeutralColor, // Text color
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
        print("the code:           " + message);
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
          .updateField(widget.usernameController.text, 'userName');
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
                  style: TextStyle(color: secondNeutralColor, fontSize: 18)),
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
              // Circle with border if a story exists
              Container(
                padding: const EdgeInsets.all(3), // Border thickness
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // && widget.userState?.hasStory
                  gradient: !widget.isEditing && widget.userState!.hasStory
                      ? const LinearGradient(
                          colors: [
                            Colors.purple,
                            Colors.orange
                          ], // Border gradient colors
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null, // No border if no story
                ),
                child: InkWell(
                  key: SettingsPageKeys.picUpdatePicInkWell,
                  onTap: () {
                    if (widget.isEditing) {
                      // Show options to pick an image
                      _showImageSourceDialog();
                    } else {
                      if (widget.userState!.hasStory) {
                        _showProfileOrStatusOptions(); // Show dialog to select action if not editing
                      } else {
                        _viewProfilePhoto(
                            context,
                            widget.userState!
                                .profilePic); // Navigate to view profile photo
                      }
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
                                Colors
                                    .transparent, // No filter when not editing
                                BlendMode.saturation,
                              ),
                        child: widget.userState!.profilePic == ''
                            ? Image.network(
                                'https://ui-avatars.com/api/?background=8D6AEE&size=128&color=fff&name=${formatName(widget.userState!.name)}', // Default avatar URL
                                fit: BoxFit.cover,
                                width: 140,
                                height: 140,
                              )
                            : Image.network(
                                widget.userState!
                                    .profilePic, // Display the user's profile picture
                                fit: BoxFit.cover,
                                width: 140,
                                height: 140,
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              // Camera icon overlay with action when in editing mode
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
                      color: secondNeutralColor,
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
              style: TextStyle(color: secondNeutralColor, fontSize: 20),
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

  // Navigate to Story Creation Screen
  void _navigateToStoryCreationScreen(BuildContext context) async {
    final newStory = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StoryCreationScreen(
          onStoryCreated: (Story story) {
            context.read<SettingsCubit>().updateHasStoryUserState();

            context
                .read<SettingsCubit>()
                .sendMyStory(story.media, story.content, story.type);
          },
        ),
      ),
    );
  }

  void _showProfileOrStatusOptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: firstSecondaryColor,
      builder: (BuildContext context) {
        return SafeArea(
          key: SettingsPageKeys.showPhotoOrStory,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Stack to hold both the cancel icon and the header text
              Stack(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        'Select an action',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: secondNeutralColor),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 4,
                    child: IconButton(
                      icon: Icon(Icons.close, color: secondNeutralColor),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
              const Divider(), // Divider for separation
              // Options
              ListTile(
                leading: Icon(Icons.photo, color: secondNeutralColor),
                title: Text(
                  'View Profile Photo',
                  style: TextStyle(color: secondNeutralColor),
                ),
                onTap: () {
                  Navigator.pop(context); // Close the dialog
                  _viewProfilePhoto(
                      context,
                      widget.userState!
                          .profilePic); // Navigate to view profile photo
                },
              ),
              ListTile(
                leading: Icon(Icons.visibility, color: secondNeutralColor),
                title: Text(
                  'View Status',
                  style: TextStyle(color: secondNeutralColor),
                ),
                onTap: () async {
                  Navigator.pop(context); // Close the dialog
                  final id = await GetId();
                  _viewStatus(context, id!);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _viewProfilePhoto(BuildContext context, String photoUrl) {
    if (widget.userState!.profilePic != '') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FullScreenPhotoScreen(photoUrl: photoUrl),
        ),
      );
    }
  }

  void _viewStatus(BuildContext context, int userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserStoriesScreen(
            userId: userId,
            profilePic: widget.userState!.profilePic,
            userName: widget.userState!.name,
            isMyStory: true),
      ),
    );
  }

// Function to show dialog for image source
  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF0A254A),
          title: Center(
            child: Text(
              'Choose an Option',
              style: TextStyle(color: secondNeutralColor),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Center(
                  key: SettingsPageKeys.takePhotoListTile,
                  child: Text(
                    'Take Photo',
                    style: TextStyle(color: secondNeutralColor),
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
                  child: Text(
                    'Select from Gallery',
                    style: TextStyle(color: secondNeutralColor),
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
                  child: Text(
                    'Remove Photo',
                    style: TextStyle(
                        color: secondNeutralColor), // Set text color to white
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
      context.read<SettingsCubit>().sendProfilePhoto(blobName);
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
      context.read<SettingsCubit>().sendProfilePhoto(blobName);
    } else {
      print('No image selected.');
    }
  }

  // Function to remove a photo
  Future<void> _removeImage() async {
    context.read<SettingsCubit>().removeProfilePic();
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
              style: TextStyle(
                color: primaryColor,
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
                  style: TextStyle(color: highlightColor, fontSize: 14),
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
                  style: TextStyle(color: secondNeutralColor),
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
                    foregroundColor: highlightColor,
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
