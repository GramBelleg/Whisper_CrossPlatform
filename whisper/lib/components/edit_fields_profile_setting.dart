// lib/widgets/edit_fields.dart

import 'package:flutter/material.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/keys/settings_page_keys.dart';

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
        _buildTextField(bioController, 'Bio', stateText: bioStateUpdate),
        _buildTextField(nameController, 'Name', stateText: nameStateUpdate),
        _buildTextField(usernameController, 'Username',
            stateText: usernameStateUpdate),
        _buildTextField(phoneController, 'Phone Number',
            stateText: phoneNumberStateUpdate),
        _buildTextField(emailController, 'Email',
            stateText: emailStateUpdate, needCode: true),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      {String? stateText, bool needCode = false}) {
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
                child: Text(
                  stateText,
                  style: TextStyle(
                    color: stateText == "Updated" ? highlightColor : Colors.red,
                    fontSize: 14,
                  ),
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
                    confirmCodeFunction(
                        controller.text); // Call the passed function
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: highlightColor,
                    padding:
                        EdgeInsets.symmetric(horizontal: 12), // Button padding
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
