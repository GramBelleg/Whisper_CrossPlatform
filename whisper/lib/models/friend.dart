// models/friend.dart
class Friend {
  final int id;
  final String name;
  String? icon;
  final String chatType;

  Friend({
    required this.id,
    required this.name,
    required this.icon,
    required this.chatType,
  });
}
