import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final Future<bool> Function(String email) confirmCodeFunction;

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
    required this.confirmCodeFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(SettingsPageKeys.textFieldBio, bioController, 'Bio',
            stateText: bioStateUpdate, maxLength: 200, context: context),
        _buildTextField(SettingsPageKeys.textFieldName, nameController, 'Name',
            stateText: nameStateUpdate, maxLength: 50, context: context),
        _buildTextField(
            SettingsPageKeys.textFieldUserName, usernameController, 'Username',
            stateText: usernameStateUpdate, maxLength: 30, context: context),
        _buildTextField(SettingsPageKeys.textFieldPhoneNumber, phoneController,
            'Phone Number',
            stateText: phoneNumberStateUpdate, maxLength: 15, context: context),
        _buildTextField(
            SettingsPageKeys.textFieldEmail, emailController, 'Email',
            stateText: emailStateUpdate,
            needCode: true,
            maxLength: 100,
            context: context),
      ],
    );
  }

  Widget _buildTextField(
      String textFieldKey, TextEditingController controller, String labelText,
      {String? stateText,
      bool needCode = false,
      int? maxLength,
      required BuildContext context}) {
    return StatefulBuilder(
      builder: (context, setState) {
        int currentLength = controller.text.length;

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
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      '*',
                      style: TextStyle(
                        color: stateText == "Updated"
                            ? highlightColor
                            : Colors.red,
                        fontSize: 20,
                      ),
                    ),
                  ),
                const Spacer(),
                if (maxLength != null)
                  Text(
                    '$currentLength/$maxLength',
                    style: TextStyle(
                      color: secondNeutralColor,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 5),
            Container(
              constraints: BoxConstraints(
                minHeight: 50,
                maxHeight: 150,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF0A254A),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      key: Key(textFieldKey),
                      controller: controller,
                      style: TextStyle(color: secondNeutralColor),
                      keyboardType: labelText == 'Phone Number'
                          ? TextInputType.phone
                          : TextInputType.multiline,
                      maxLines: null,
                      minLines: 1,
                      inputFormatters: labelText == 'Phone Number'
                          ? [FilteringTextInputFormatter.digitsOnly]
                          : null,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: InputBorder.none,
                        counterText: '',
                      ),
                      maxLength: maxLength,
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  if (needCode)
                    TextButton(
                      key: SettingsPageKeys.sendCodeButton,
                      onPressed: () => confirmCodeFunction(controller.text),
                      style: TextButton.styleFrom(
                        foregroundColor: highlightColor,
                        padding: EdgeInsets.symmetric(horizontal: 12),
                      ),
                      child: const Text("Send Code"),
                    ),
                ],
              ),
            ),
            if (stateText != null && stateText.isNotEmpty)
              _ShowSnackBar(
                  stateText: stateText, labelText: labelText, context: context),
          ],
        );
      },
    );
  }
}

class _ShowSnackBar extends StatelessWidget {
  final String stateText;
  final BuildContext context;
  final String labelText;

  const _ShowSnackBar(
      {required this.stateText,
      required this.context,
      required this.labelText});

  @override
  Widget build(BuildContext context) {
    // Delay the SnackBar to allow the UI to update
    Future.delayed(Duration(milliseconds: 50), () {
      ScaffoldMessenger.of(this.context).showSnackBar(
        SnackBar(
          content: stateText == "Updated"
              ? Text("$labelText: $stateText")
              : Text(stateText),
          backgroundColor: stateText == "Updated" ? highlightColor : Colors.red,
        ),
      );
    });
    return Container();
  }
}
