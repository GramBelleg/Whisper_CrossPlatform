import 'package:flutter/material.dart';
import '../models/friend.dart';

class SelectedFriendsChip extends StatelessWidget {
  final List<int> selectedIndexes; // Indexes of selected friends
  final List<Friend> friends; // List of all friends

  const SelectedFriendsChip({
    required this.selectedIndexes,
    required this.friends,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: selectedIndexes.map((index) {
          final friend = friends[index];
          return Chip(
            label: Text(
              friend.name,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: const Color(0xff8d6aee), // Primary color
          );
        }).toList(),
      ),
    );
  }
}
