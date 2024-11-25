import 'package:flutter/material.dart';

class IconCreationWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final Function onTap;

  const IconCreationWidget({
    Key? key,
    required this.icon,
    required this.text,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(context),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            child: Icon(
              icon,
              size: 29,
              color: Colors.white,
            ),
            backgroundColor: color,
          ),
          Text(text),
        ],
      ),
    );
  }
}
