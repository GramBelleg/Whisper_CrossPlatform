import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/global_cubits/global_setting_cubit.dart';
import 'package:whisper/keys/settings_page_keys.dart';
import 'package:whisper/validators/form-validation/validate_email_field.dart';
import 'package:whisper/validators/form-validation/validate_name_field.dart';
import 'package:whisper/validators/form-validation/validate_number_field.dart';
import 'package:whisper/validators/form-validation/validate_user_name_field.dart';

class EditFields extends StatelessWidget {
  final TextEditingController bioController;
  final TextEditingController nameController;
  final TextEditingController usernameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final String bioStateUpdate;
  final String nameStateUpdate;
  final String usernameStateUpdate;
  final String phoneNumberStateUpdate;
  final String emailStateUpdate;
  final Future<bool> Function(String email)
      confirmCodeFunction; // Accept function as parameter

  const EditFields({
    super.key,
    required this.bioController,
    required this.nameController,
    required this.usernameController,
    required this.phoneController,
    required this.emailController,
    required this.bioStateUpdate,
    required this.nameStateUpdate,
    required this.usernameStateUpdate,
    required this.phoneNumberStateUpdate,
    required this.emailStateUpdate,
    required this.confirmCodeFunction, // Pass the function here
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(bioController, 'Bio',
            stateText: bioStateUpdate,
            maxLength: 200,
            validator: null, // Validate bio field
            setUpdate:
                GlobalSettingsCubitProvider.settingsCubit.setBioStateUpdate),
        _buildTextField(nameController, 'Name',
            stateText: nameStateUpdate,
            maxLength: 50,
            validator: (text) => validateNameField(text), // Validate name field
            setUpdate:
                GlobalSettingsCubitProvider.settingsCubit.setNameStateUpdate),
        _buildTextField(usernameController, 'Username',
            stateText: usernameStateUpdate,
            maxLength: 20,
            validator: (text) =>
                validateUsernameField(text), // Validate username field
            setUpdate: GlobalSettingsCubitProvider
                .settingsCubit.setUsernameStateUpdate),
        _buildTextField(phoneController, 'Phone Number',
            stateText: phoneNumberStateUpdate,
            maxLength: 15,
            keyboardType: TextInputType.phone,
            validator: (text) =>
                validateNumberFieldString(text), // Validate phone number field
            setUpdate: GlobalSettingsCubitProvider
                .settingsCubit.setPhoneNumberStateUpdate),
        _buildTextField(emailController, 'Email',
            stateText: emailStateUpdate,
            needCode: true,
            maxLength: 100,
            keyboardType: TextInputType.emailAddress,
            validator: (text) =>
                validateEmailField(text), // Validate email field
            setUpdate:
                GlobalSettingsCubitProvider.settingsCubit.setEmailStateUpdate),
      ],
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String labelText, {
    String? stateText,
    bool needCode = false,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
    String? Function(String?)? validator,
    Future<void> Function(String)? setUpdate,
  }) {
    controller.addListener(() {
      GlobalSettingsCubitProvider.settingsCubit
          .setAllStateUpdate(''); // Reset state on text change
    });

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
            if (stateText != null && stateText.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Flexible(
                  child: Text(
                    stateText.length > 30
                        ? '${stateText.substring(0, 30)}...' // Truncate large text
                        : stateText,
                    style: TextStyle(
                      color:
                          stateText == "Updated" ? highlightColor : Colors.red,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis, // Ensure no overflow
                    maxLines: 1, // Prevent the text from wrapping
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 5),
        Container(
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
                  textAlign: controller.text.isEmpty
                      ? TextAlign.center
                      : TextAlign.start, // Center text when empty
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: InputBorder.none,
                  ),
                  keyboardType: keyboardType,
                  maxLength: maxLength,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  minLines: 1,
                  maxLines: null,
                  onChanged: (text) {
                    final errorMessage = validator?.call(text);
                    if (errorMessage != null) {
                      setUpdate!(errorMessage);
                    }
                  },
                ),
              ),
              if (needCode)
                TextButton(
                  key: SettingsPageKeys.sendCodeButton,
                  onPressed: () {
                    confirmCodeFunction(
                        controller.text); // Call the passed function
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: highlightColor,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                  ),
                  child: const Text("Send Code"),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
