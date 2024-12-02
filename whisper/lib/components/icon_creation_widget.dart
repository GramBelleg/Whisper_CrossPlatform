import 'package:flutter/material.dart';
class IconCreationWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final Function onTap;

  const IconCreationWidget({
    super.key,
    required this.icon,
    required this.text,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Icon(
              icon,
              size: 29,
              color: Colors.white,
            ),
          ),
          Text(text),
        ],
      ),
    );
  }
}
