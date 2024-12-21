import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whisper/components/page_state.dart';
import 'package:whisper/keys/admin_dash_board_keys.dart';
import 'package:whisper/keys/login_keys.dart';
import 'package:whisper/models/login_credentials.dart';
import 'package:whisper/pages/forget_password_email.dart';
import 'package:whisper/pages/sign_up.dart';
import 'package:whisper/services/admin_dashboard_service.dart';
import 'package:whisper/validators/form-validation/validate_email_field.dart';
import '../components/custom_access_button.dart';
import '../components/custom_highlight_text.dart';
import '../components/custom_quick_login.dart';
import '../components/custom_text_field.dart';
import '../constants/colors.dart';
import '../keys/home_keys.dart';
import '../services/login_service.dart';
import '../services/logout_confirmation_dialog.dart';
import '../validators/form-validation/validate_passward_field.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  static String id = "/adminDashboard";

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  List<dynamic> users = [];
  List<dynamic> bannedUsers = [];
  List<dynamic> unbannedUsers = [];
  List<dynamic> groups = [];
  List<dynamic> filterGroups = [];
  List<dynamic> unfilterGroups = [];
  bool showUsers = true;
  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final fetchedUsers = await AdminDashboardService.getAllUsers(context);
    setState(() {
      if (fetchedUsers != null) users = fetchedUsers;
      bannedUsers = users.where((user) => user['banned'] == true).toList();
      unbannedUsers = users.where((user) => user['banned'] == false).toList();
    });
  }

  Future<void> _fetchGroups() async {
    final fetchedGroups = await AdminDashboardService.getAllGroups(context);
    setState(() {
      if (fetchedGroups != null) groups = fetchedGroups;
      filterGroups =
          groups.where((group) => group['filtered'] == true).toList();
      unfilterGroups =
          groups.where((group) => group['filtered'] == false).toList();
    });
  }

  Future<void> _banUser(bool ban, int userId) async {
    await AdminDashboardService.banAUser(context, ban, userId);
    _fetchUsers(); // Refresh the user list after banning/unbanning
  }

  Future<void> _filterGroup(bool filter, int groupId) async {
    await AdminDashboardService.filterGroup(context, filter, groupId);
    _fetchGroups(); // Refresh the group list after filtering/unfiltering
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: firstNeutralColor,
      appBar: AppBar(
        title: Text(showUsers ? "Users List" : "Groups List"),
        actions: [
          IconButton(
            key: Key(AdminDashboardKeys.toggleUsersGroupsButton),
            icon: Icon(showUsers ? Icons.group : Icons.person),
            onPressed: () {
              setState(() {
                showUsers = !showUsers;
                if (!showUsers) {
                  _fetchGroups();
                }
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showUsers) ...[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Unbanned Users:",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: secondNeutralColor),
                ),
              ),
              ...unbannedUsers.map((user) => ListTile(
                    title: Text(
                      user['userName'],
                      style: TextStyle(color: secondNeutralColor),
                    ),
                    trailing: ElevatedButton(
                      key: Key(AdminDashboardKeys.banButton),
                      onPressed: () => _banUser(true, user['id']),
                      child: Text("Ban",
                          style: TextStyle(color: secondNeutralColor)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                      ),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Banned Users:",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: secondNeutralColor),
                ),
              ),
              ...bannedUsers.map((user) => ListTile(
                    title: Text(user['userName'],
                        style: TextStyle(color: secondNeutralColor)),
                    trailing: ElevatedButton(
                      key: Key(AdminDashboardKeys.unbanButton),
                      onPressed: () => _banUser(false, user['id']),
                      child: Text("Unban",
                          style: TextStyle(color: secondNeutralColor)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                      ),
                    ),
                  )),
            ] else ...[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "UnFiltered Groups:",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: secondNeutralColor),
                ),
              ),
              ...unfilterGroups.map((group) => ListTile(
                    title: Text(
                      group['name'],
                      style: TextStyle(color: secondNeutralColor),
                    ),
                    trailing: ElevatedButton(
                      key: Key(AdminDashboardKeys.filterButton),
                      onPressed: () => _filterGroup(true, group['chatId']),
                      child: Text("Filter",
                          style: TextStyle(color: secondNeutralColor)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                      ),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Filtered Groups:",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: secondNeutralColor),
                ),
              ),
              ...filterGroups.map((group) => ListTile(
                    title: Text(group['name'],
                        style: TextStyle(color: secondNeutralColor)),
                    trailing: ElevatedButton(
                      key: Key(AdminDashboardKeys.unfilterButton),
                      onPressed: () => _filterGroup(false, group['chatId']),
                      child: Text("unfilter",
                          style: TextStyle(color: secondNeutralColor)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                      ),
                    ),
                  )),
            ],
            SizedBox(
              height: 30,
            ),
            Center(
              child: CustomAccessButton(
                key: Key(HomeKeys.logoutFromOneButtonKey),
                label: "Logout From This Device",
                onPressed: () {
                  showLogoutConfirmationDialog(context, false);
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: CustomAccessButton(
                key: Key(HomeKeys.logoutFromAllButtonKey),
                label: "Logout From All Devices",
                onPressed: () {
                  showLogoutConfirmationDialog(context, true);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
