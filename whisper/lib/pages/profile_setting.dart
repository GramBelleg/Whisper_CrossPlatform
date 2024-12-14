import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whisper/components/build_profile_section.dart';
import 'package:whisper/components/buttons_sheet_for_add_story.dart';
import 'package:whisper/components/custom_access_button.dart';
import 'package:whisper/components/edit_fields_profile_setting.dart';
import 'package:whisper/components/helpers.dart';
import 'package:whisper/components/info_row.dart';
import 'package:whisper/components/privacy_card.dart';
import 'package:whisper/models/user_state.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/keys/home_keys.dart';
import 'package:whisper/keys/settings_page_keys.dart';
import 'package:whisper/keys/visibility_settings_keys.dart';
import 'package:whisper/cubit/settings_cubit.dart';
import 'package:whisper/pages/blocked_users_page.dart';
import 'package:whisper/pages/my_stories_screen.dart';
import 'package:whisper/pages/visibility_settings_page.dart';
import 'package:whisper/services/logout_confirmation_dialog.dart';
import 'package:whisper/services/shared_preferences.dart';
import 'package:whisper/services/upload_file.dart';
import 'package:quickalert/quickalert.dart';
import 'package:whisper/validators/reset-password-validation/validate_confirmation_code.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    context.read<SettingsCubit>().loadUserState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: firstNeutralColor,
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<SettingsCubit, SettingsState>(
              builder: (context, state) {
                if (state is SettingsLoading) {
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
                      nameStateUpdate: state.nameStateUpdate,
                      usernameStateUpdate: state.usernameStateUpdate,
                      emailStateUpdate: state.emailStateUpdate,
                      phoneNumberStateUpdate: state.phoneNumberStateUpdate,
                      bioStateUpdate: state.bioStateUpdate,
                      profilePicState: state.profilePicState,
                      hasStory: state.hasStory);
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
  final bool hasStory;
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
  final String nameStateUpdate;
  final String usernameStateUpdate;
  final String emailStateUpdate;
  final String phoneNumberStateUpdate;
  final String bioStateUpdate;
  final String profilePicState;
  const SettingsContent(
      {super.key,
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
      required this.nameStateUpdate,
      required this.usernameStateUpdate,
      required this.emailStateUpdate,
      required this.phoneNumberStateUpdate,
      required this.bioStateUpdate,
      required this.profilePicState,
      required this.hasStory});

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
                GestureDetector(
                  onTap: () {
                    print('Edit tapped');
                    context.read<SettingsCubit>().toggleEditing();
                  },
                  child: Text(
                    "Edit",
                    style: TextStyle(
                      color: highlightColor,
                      fontSize: 16,
                    ),
                  ),
                ),
                IconButton(
                  key: SettingsPageKeys.addStoryInProfile,
                  icon: SizedBox(
                    width: 23.0,
                    height: 23.0,
                    child: Image.asset(
                      "assets/images/addStoryFirstNeutralColor_Icon (3).png", // Change to your desired icon
                      fit: BoxFit.cover,
                    ),
                  ),
                  onPressed: () {
                    _addStory();
                  },
                ),
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
              ProfileSection(
                isEditing: widget.isEditing,
                hasStory: widget.hasStory,
                profilePic: widget.profilePicState,
                name: widget.nameState,
                status: widget.userState!.status,
                showImageSourceDialog: _showImageSourceDialog,
                showProfileOrStatusOptions: _showProfileOrStatusOptions,
              ),
              if (widget.isEditing)
                EditFields(
                  bioController: widget.bioController,
                  nameController: widget.nameController,
                  usernameController: widget.usernameController,
                  phoneController: widget.phoneController,
                  emailController: widget.emailController,
                  bioStateUpdate: widget.bioStateUpdate,
                  nameStateUpdate: widget.nameStateUpdate,
                  usernameStateUpdate: widget.usernameStateUpdate,
                  phoneNumberStateUpdate: widget.phoneNumberStateUpdate,
                  emailStateUpdate: widget.emailStateUpdate,
                  confirmCodeFunction: _confirmCode,
                ), // Show edit fields if in editing mode
              if (!widget.isEditing) ...[
                SizedBox(height: 30),
                InfoRow(
                    value: widget.phoneNumberState,
                    label: 'Phone',
                    icon: Icons.phone),
                InfoRow(
                    value: widget.usernameState,
                    label: 'Username',
                    icon: Icons.person),
                InfoRow(
                    value: widget.emailState,
                    label: 'Email',
                    icon: Icons.email),
                InfoRow(
                    value: widget.bioState,
                    label: 'Bio',
                    icon: Icons.person_sharp),
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
                PrivacyCard(
                    setting: 'Visibility Settings',
                    icon: FontAwesomeIcons.eye,
                    targetPage: const VisibilitySettingsPage(),
                    key: VisibilitySettingsKeys.visibilitySettingsTile),
                PrivacyCard(
                    setting: 'Blocked Users',
                    icon: FontAwesomeIcons.userSlash,
                    targetPage: const BlockedUsersPage(),
                    key: VisibilitySettingsKeys.blockedUsersTile),
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
    if (email != widget.emailState) {
      final response =
          await context.read<SettingsCubit>().sendCode(email, context);
      // Check if response was successful
      if (response['success'] == true) {
        _showCustomAlertDialogCode(email, context);
      } else {
        context.read<SettingsCubit>().setEmailStateUpdate(response['message']);
      }
    } else {
      // Set state if email is the same as the current one
      context.read<SettingsCubit>().setEmailStateUpdate("Same Email");
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
      confirmBtnText: 'Submit', // need to key but this package
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
              content: Text(validateConfirmationCode(message) as String),
            ),
          );
          return;
        }
        //verify my code
        print("the code:           $message");
        final response = await context
            .read<SettingsCubit>()
            .verifyCode(message, email, context);
        if (response['success']) {
          context.read<SettingsCubit>().setEmailStateUpdate("Updated");
          Navigator.pop(context);
        }
      },
    );
  }

  void _saveChanges(BuildContext context) async {
    bool success = true;
    // Check if name is updated
    if (widget.nameController.text.trim() != widget.nameState.trim()) {
      final response = await context
          .read<SettingsCubit>()
          .updateField(widget.nameController.text, 'name');
      success &= response['success'];
      context.read<SettingsCubit>().setNameStateUpdate(response['message']);
    }

    // Check if username is updated
    if (widget.usernameController.text.trim() != widget.usernameState.trim()) {
      final response = await context
          .read<SettingsCubit>()
          .updateField(widget.usernameController.text, 'userName');
      success &= response['success'];
      context.read<SettingsCubit>().setUsernameStateUpdate(response['message']);
    }

    // Check if phone is updated
    if (widget.phoneController.text.trim() != widget.phoneNumberState.trim()) {
      final response = await context
          .read<SettingsCubit>()
          .updateField(widget.phoneController.text, 'phoneNumber');
      success &= response['success'];
      context
          .read<SettingsCubit>()
          .setPhoneNumberStateUpdate(response['message']);
    }

    // Check if bio is updated
    if (widget.bioController.text.trim() != widget.bioState.trim()) {
      final response = await context
          .read<SettingsCubit>()
          .updateField(widget.bioController.text, 'bio');
      success &= response['success'];
      context.read<SettingsCubit>().setBioStateUpdate(response['message']);
    }
    if (success) {
      context.read<SettingsCubit>().toggleEditing();
      context.read<SettingsCubit>().resetStateMessages();
    }
  }

  void _addStory() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => ImagePickerButtonSheetForStory(),
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
                key: SettingsPageKeys.showProfilePic,
                leading: Icon(Icons.photo, color: secondNeutralColor),
                title: Text(
                  'View Profile Photo',
                  style: TextStyle(color: secondNeutralColor),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Close the dialog
                  viewProfilePhoto(context,
                      widget.profilePicState); // Navigate to view profile photo
                },
              ),
              ListTile(
                key: SettingsPageKeys.viewMyStories,
                leading: Icon(Icons.visibility, color: secondNeutralColor),
                title: Text(
                  'View Status',
                  style: TextStyle(color: secondNeutralColor),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  // Close the dialog
                  final id = await getId();
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

  void _viewStatus(BuildContext context, int userId) {
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ShowMyStories(),
        ),
      );
    }
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
      // await context.read<SettingsCubit>().updateProfilePic(blobName);
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
      //  await context.read<SettingsCubit>().updateProfilePic(blobName);
      context.read<SettingsCubit>().sendProfilePhoto(blobName);
    } else {
      print('No image selected.');
    }
  }

  // Function to remove a photo
  Future<void> _removeImage() async {
    context.read<SettingsCubit>().removeProfilePic();
  }
}
