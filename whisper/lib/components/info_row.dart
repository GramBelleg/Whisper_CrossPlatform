import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/keys/settings_page_keys.dart';

class InfoRow extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const InfoRow({
    Key? key,
    required this.value,
    required this.label,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: SettingsPageKeys.copyRow,
      onTap: () => _copyToClipboard(value, context),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 13.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                value,
                style: TextStyle(color: secondNeutralColor, fontSize: 18),
              ),
            ),
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  void _copyToClipboard(String text, BuildContext context) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$text copied to clipboard!')),
    );
  }
}
