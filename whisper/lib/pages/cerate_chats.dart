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
  List<Contact> _filteredContacts = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _contactsFuture = fetchUserContacts();
    _searchController.addListener(_filterContacts);
  }

  // Function to filter contacts based on search query
  void _filterContacts() {
    setState(() {
      // If there is a search query, filter the contacts
      if (_searchController.text.isEmpty) {
        _filteredContacts = [];
      } else {
        // Filter contacts only after fetching the data
        _contactsFuture.then((contacts) {
          _filteredContacts = contacts
              .where((contact) => contact.userName
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()))
              .toList();
        });
      }
    });
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
                Expanded(
                  child: TextField(
                    controller: _searchController,
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
                  // Use filtered contacts or all contacts based on the search query
                  final contactsToShow = _searchController.text.isEmpty
                      ? contacts
                      : _filteredContacts;

                  return SingleChildScrollView(
                    child: Column(
                      children: List.generate(contactsToShow.length, (index) {
                        return ListTile(
                          onTap: isSelecting
                              ? () {
                                  setState(() {
                                    if (selectedContacts
                                        .contains(contactsToShow[index])) {
                                      selectedContacts
                                          .remove(contactsToShow[index]);
                                    } else {
                                      selectedContacts
                                          .add(contactsToShow[index]);
                                    }
                                  });
                                }
                              : () {
                                  print(
                                      'Tapped on ${contactsToShow[index].userName}');
                                  GlobalChatsCubitProvider.chatListCubit
                                      .createChat("DM", null, null, null,
                                          [contactsToShow[index].userId]);
                                  Navigator.of(context).pop();
                                },
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(contactsToShow[index].profilePic),
                          ),
                          title: Text(
                            contactsToShow[index].userName,
                            style: const TextStyle(color: secondNeutralColor),
                          ),
                          trailing: isSelecting
                              ? Icon(
                                  selectedContacts
                                          .contains(contactsToShow[index])
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
