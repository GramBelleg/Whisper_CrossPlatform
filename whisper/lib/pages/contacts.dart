import 'package:flutter/material.dart';

class ContactsPage extends StatelessWidget {
  static const String id = '/contacts_page';

  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        backgroundColor: const Color(0xFF0A122F),
      ),
      body: _buildContactsList(),
    );
  }

  Widget _buildContactsList() {
    // Sample list of contacts
    final List<Map<String, String>> contacts = [
      {'name': 'Alice', 'phone': '123-456-7890'},
      {'name': 'Bob', 'phone': '987-654-3210'},
      {'name': 'Charlie', 'phone': '555-555-5555'},
      // Add more contacts here
    ];

    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(contacts[index]['name']!),
          subtitle: Text(contacts[index]['phone']!),
          leading: const Icon(Icons.person),
          onTap: () {
            // Handle contact tap
          },
        );
      },
    );
  }
}
