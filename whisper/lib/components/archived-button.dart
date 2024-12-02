import 'package:flutter/material.dart';

class ArchivedChatsButton extends StatelessWidget {
  final List<Map<String, dynamic>> archivedChats;
  final VoidCallback onTap;

  const ArchivedChatsButton({
    super.key,
    required this.archivedChats,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xff1C2742),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Row(
            children: [
              const CircleAvatar(
                backgroundColor: Color(0xff8D6AEE),
                child: Icon(Icons.archive, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Archived Chats',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '${archivedChats.length} archived',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Color(0xff8D6AEE)),
            ],
          ),
        ),
      ),
    );
  }
}
