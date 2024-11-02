import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {
  final VoidCallback onPressed;

  const DeleteButton({super.key, required this.onPressed});

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete message?"),
          content: Text("Are you sure you want to delete this message?"),
          actions: [
            TextButton(
              onPressed: () {
                // Perform delete for everyone action
                Navigator.of(context).pop();
                // Call the onPressed callback if needed
                onPressed();
              },
              child: Text("Delete for everyone"),
            ),
            TextButton(
              onPressed: () {
                // Perform delete for me action
                Navigator.of(context).pop();
                // Call the onPressed callback if needed
                onPressed();
              },
              child: Text("Delete for me"),
            ),
            TextButton(
              onPressed: () {
                // Close dialog
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _showDeleteDialog(context),
      child: Text("Delete"), // You can customize the button label here
    );
  }
}
