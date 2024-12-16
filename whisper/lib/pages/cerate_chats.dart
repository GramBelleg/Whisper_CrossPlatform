import 'package:flutter/material.dart';
import 'package:whisper/components/dialog_create_group_channel.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/global_cubits/global_chats_cubit.dart';
import 'package:whisper/models/contact.dart';
import 'package:whisper/services/chats_services/fetch_contacts.dart';

class ModalBottomSheetContent extends StatefulWidget {
  @override
  _ModalBottomSheetContentState createState() =>
      _ModalBottomSheetContentState();
}

class _ModalBottomSheetContentState extends State<ModalBottomSheetContent> {
  late Future<List<Contact>> _contactsFuture;
  final Set<Contact> selectedContacts = {};
  bool isSelecting = false;

  @override
  void initState() {
    super.initState();
    _contactsFuture = fetchUserContacts();
  }

  void showCreateDialog(String type) {
    showDialog(
      context: context,
      builder: (context) {
        return CreateGroupOrChannelDialog(
            type: type,
            onCreate: () {
              Navigator.of(context).pop();
            },
            contacts: selectedContacts);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.92,
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: primaryColor, fontSize: 18),
                ),
              ),
              const Text(
                'New Message',
                style: TextStyle(
                  color: secondNeutralColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(
                  isSelecting ? Icons.cancel : Icons.select_all,
                  color: primaryColor,
                ),
                onPressed: () {
                  setState(() {
                    isSelecting = !isSelecting;
                    if (!isSelecting) {
                      selectedContacts.clear(); // Clear selected contacts
                    }
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Search Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            decoration: BoxDecoration(
              color: firstNeutralColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.grey[600]),
                const SizedBox(width: 8),
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(color: secondNeutralColor),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Options Section
          Column(
            children: [
              ListTile(
                leading: const Icon(Icons.group, color: primaryColor),
                title: const Text('New Group',
                    style: TextStyle(color: secondNeutralColor)),
                onTap: () {
                  if (isSelecting && selectedContacts.isNotEmpty) {
                    showCreateDialog('Group');
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.campaign, color: primaryColor),
                title: const Text('New Channel',
                    style: TextStyle(color: secondNeutralColor)),
                onTap: () {
                  if (isSelecting && selectedContacts.isNotEmpty) {
                    showCreateDialog('Channel');
                  }
                },
              ),
            ],
          ),
          const Divider(color: Colors.grey),

          // Contacts Section
          Expanded(
            child: FutureBuilder<List<Contact>>(
              future: _contactsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No contacts available'));
                } else {
                  final contacts = snapshot.data!;
                  return SingleChildScrollView(
                    child: Column(
                      children: List.generate(contacts.length, (index) {
                        return ListTile(
                          onTap: isSelecting
                              ? () {
                                  setState(() {
                                    if (selectedContacts
                                        .contains(contacts[index])) {
                                      selectedContacts.remove(contacts[index]);
                                    } else {
                                      selectedContacts.add(contacts[index]);
                                    }
                                  });
                                }
                              : () {
                                  print(
                                      'Tapped on ${contacts[index].userName}');
                                  GlobalChatsCubitProvider.chatListCubit
                                      .createChat("DM", null, null, null,
                                          [contacts[index].userId]);
                                  Navigator.of(context).pop();
                                },
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(contacts[index].profilePic),
                          ),
                          title: Text(
                            contacts[index].userName,
                            style: const TextStyle(color: secondNeutralColor),
                          ),
                          trailing: isSelecting
                              ? Icon(
                                  selectedContacts.contains(contacts[index])
                                      ? Icons.check_circle
                                      : Icons.check_circle_outline,
                                  color: primaryColor,
                                )
                              : null,
                        );
                      }),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
