import 'package:flutter/material.dart';
import 'package:whisper/components/custom-highlight-text.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/services/log-out-services.dart';

void showLogoutConfirmationDialog(BuildContext context, bool fromAllDevices) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        backgroundColor: firstNeutralColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "⚠ Are you sure that you want to logout from ${fromAllDevices ? 'all previously logged in devices?' : 'this device?'}",
                style: TextStyle(
                  fontSize: 20,
                  color: secondNeutralColor,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomHighlightText(
                    callToActionText: "No",
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  CustomHighlightText(
                    callToActionText: "Yes",
                    onTap: () async {
                      if (fromAllDevices) {
                        await LogoutService.logoutFromAllDevices(context);
                      } else {
                        await LogoutService.logoutFromThisDevice(context);
                      }
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}
