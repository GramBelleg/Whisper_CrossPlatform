import 'package:flutter/material.dart';
import 'package:whisper/constants/colors.dart';

class PrivacyCard extends StatelessWidget {
  final String setting;
  final IconData icon;
  final Widget targetPage;
  final Key key;

  const PrivacyCard({
    required this.setting,
    required this.icon,
    required this.targetPage,
    required this.key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
        color: const Color(0xFF1A1E2D),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: InkWell(
          key: key,
          onTap: () {
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
                    const SizedBox(width: 8),
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
