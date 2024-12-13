import 'package:flutter/material.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/models/user_view.dart';

class UserViewListWithHeader extends StatelessWidget {
  final List<UserView> userViews;
  final String headerTitle;

  const UserViewListWithHeader({
    super.key,
    required this.userViews,
    required this.headerTitle,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and close button
          Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    headerTitle,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: secondNeutralColor,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 10,
                top: 4,
                child: IconButton(
                  icon: Icon(Icons.close, color: secondNeutralColor),
                  onPressed: () {
                    Navigator.pop(context); // Close the modal
                  },
                ),
              ),
            ],
          ),
          const Divider(), // Divider for separation
          // Check if the list is empty
          Expanded(
            child: userViews.isEmpty
                ? Center(
                    child: Text(
                      "No Views",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: userViews.length,
                    itemBuilder: (context, index) {
                      final userView = userViews[index];
                      return UserViewCard(userView: userView);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class UserViewCard extends StatelessWidget {
  final UserView userView;

  const UserViewCard({
    super.key,
    required this.userView,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(9.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(userView.profilePic),
              radius: 25,
            ),
            const SizedBox(width: 16),
            Text(
              userView.userName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const Spacer(),
            Icon(
              userView.liked ? Icons.favorite : Icons.favorite_border,
              color: userView.liked ? Colors.red : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
