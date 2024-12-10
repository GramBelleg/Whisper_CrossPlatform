import 'package:flutter/material.dart';
import 'package:whisper/constants/colors.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0),
            child: TextField(
              onChanged: (value) {
                // Handle search input changes here
                print("Search: $value");
              },
              decoration: InputDecoration(
                hintText: "Search",
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: secondNeutralColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
              ),
            ),
          ),
          // Additional content can be added here, such as search results
          Expanded(
              child: Center(child: Text("Search results will appear here."))),
        ],
      ),
    );
  }
}
