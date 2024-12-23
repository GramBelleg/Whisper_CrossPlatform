import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:whisper/keys/custom_app_bar_keys.dart';
import 'package:whisper/keys/login_keys.dart';
import 'package:whisper/main.dart' as app;
import 'utils/auth_user.dart';
import 'package:whisper/keys/tap_bar_keys.dart';
import 'package:whisper/keys/main_chats_keys.dart';
import 'utils/test_common_functions.dart';
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Groups E2E Tests', ()
  {
    late Finder email_field;
    late Finder password_field;
    late Finder login_button;
    late Finder chats_page;
    final friend_username = AuthUser.whisper_friend_username;

    Future<String> CreateGroup(WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(chats_page);
      await tester.pumpAndSettle();
      final search_button = find.byKey(const ValueKey(MainChatsKeys.searchGestureDetector));
      final search_button_center = tester.getCenter(search_button);
      await tester.dragFrom(search_button_center, const Offset(0, -300));
      await tester.pumpAndSettle();
      final pencil_button= find.byKey(const ValueKey(MainChatsKeys.editButton));
      throw('Error: No key found for selecting users');
      final select_user = find.byKey();
      await tester.tap(select_user);
      await tester.pumpAndSettle();
      final friend_finder = find.textContaining(friend_username);
      await tester.tap(friend_finder);
      await tester.pumpAndSettle();
      final create_group_button = find.textContaining('Create Group');
      await tester.tap(create_group_button);
      await tester.pumpAndSettle();
      final group_name_field = find.textContaining('Enter Group Name');
      String group_name_to_be_created = generateRandomString(10);
      await tester.enterText(group_name_field, group_name_to_be_created);
      await tester.pumpAndSettle();
      final create_button = find.textContaining('Create');
      await tester.tap(create_button);
      return group_name_to_be_created;
    }
    Future<void> OpenGroup(WidgetTester tester,String group_name) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(chats_page);
      await tester.pumpAndSettle();
      final group_finder = find.textContaining(group_name);
      await tester.tap(group_finder);
      await tester.pumpAndSettle();
    }
    Future<void> DeleteGroup(WidgetTester tester,String group_name) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(chats_page);
      await tester.pumpAndSettle();
      final group_finder = find.textContaining(group_name);
      // drag left to reveal delete button
      await tester.drag(group_finder, const Offset(-300, 0));
      await tester.pumpAndSettle();
      final delete_button = find.byKey(const ValueKey(MainChatsKeys.deleteButton));
      await tester.tap(delete_button);
      await tester.pumpAndSettle();
    }
    testWidgets('assure the user is logged in', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      try {
        // Locate elements
        email_field = find.byKey(const ValueKey(LoginKeys.emailTextFieldKey));
        password_field =
            find.byKey(const ValueKey(LoginKeys.passwordTextFieldKey));
        login_button = find.byKey(const ValueKey(LoginKeys.loginButtonKey));

        // Enter email and password
        await tester.enterText(email_field, AuthUser.email_whisper_test);
        await tester.enterText(
            password_field, AuthUser.password_whisper_test_1);

        // Tap on the login button
        await tester.tap(login_button);
        await tester.pumpAndSettle(); // Wait for the UI to settle

        // Check if login is successful and settings page is loaded
        chats_page = find.byKey(const ValueKey(TapBarKeys.chatsButton));
        await tester.pumpAndSettle();
      } catch (e) {
        // Check if user is already logged in and handle accordingly
        try {
          await tester.pumpAndSettle(); // Wait for UI to settle again
          chats_page = find.byKey(const ValueKey(TapBarKeys.chatsButton));
          await tester.pumpAndSettle();
        } catch (e) {
          // Print error if setup failed
          print('Error: setup failed');
        }
      }
    });
    testWidgets('Create a group', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await CreateGroup(tester);
    });
    testWidgets('Open a group', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      String group_created = await CreateGroup(tester);
      await OpenGroup(tester, group_created);
    });
    testWidgets('Delete group', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      String group_created = await CreateGroup(tester);
      await DeleteGroup(tester, group_created);
    });
    testWidgets('Leave Group', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      String group_created = await CreateGroup(tester);
      final group_finder = find.textContaining(group_created);
      // drag left to reveal leave button
      await tester.drag(group_finder, const Offset(-300, 0));
      await tester.pumpAndSettle();
      final leave_button = find.byKey(const ValueKey(MainChatsKeys.leaveButton));
      await tester.tap(leave_button);
      await tester.pumpAndSettle();
    });
    testWidgets('Mute Group', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      String group_name = await CreateGroup(tester);
      final group_finder = find.textContaining(group_name);
      // drag right to reveal mute button
      await tester.drag(group_finder, const Offset(300, 0));
      await tester.pumpAndSettle();
      final mute_button = find.byKey(const ValueKey(MainChatsKeys.muteButton));
      await tester.tap(mute_button);
      await tester.pumpAndSettle();
      final week_duration = find.byKey(const ValueKey(MainChatsKeys.weekDuration));
      await tester.tap(week_duration);
      await tester.pumpAndSettle();
      //try hours
      await tester.drag(group_finder, const Offset(300, 0));
      await tester.pumpAndSettle();
      await tester.tap(mute_button);
      await tester.pumpAndSettle();
      final hours_duration = find.byKey(const ValueKey(MainChatsKeys.hoursDuration));
      await tester.tap(hours_duration);
      await tester.pumpAndSettle();
      //try always
      await tester.drag(group_finder, const Offset(300, 0));
      await tester.pumpAndSettle();
      await tester.tap(mute_button);
      await tester.pumpAndSettle();
      final always_duration = find.byKey(const ValueKey(MainChatsKeys.alwaysDuration));
      await tester.tap(always_duration);
      await tester.pumpAndSettle();
    });
    testWidgets('Add Admins to The Group', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      String group_name = await CreateGroup(tester);
      //open the group
      await OpenGroup(tester, group_name);
      final group_finder = find.textContaining(group_name);
      //tap on the group
      await tester.tap(group_finder);
      await tester.pumpAndSettle();
      final friend_finder = find.textContaining(friend_username);
      //hold on it
      await tester.longPress(friend_finder);
      await tester.pumpAndSettle();
      final add_admin_button = find.textContaining('Make Admin');
      await tester.tap(add_admin_button);
      await tester.pumpAndSettle();
      //expect two admins
      final admin_count = expect(find.textContaining('Admin'), findsNWidgets(2));
    });
    testWidgets('Remove Users From the group', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      String group_name = await CreateGroup(tester);
      //open the group
      await OpenGroup(tester, group_name);
      final group_finder = find.textContaining(group_name);
      //tap on the group
      await tester.tap(group_finder);
      await tester.pumpAndSettle();
      final friend_finder = find.textContaining(friend_username);
      //hold on it
      await tester.longPress(friend_finder);
      await tester.pumpAndSettle();
      final remove_user_button = find.textContaining('Remove Member');
      await tester.tap(remove_user_button);
      await tester.pumpAndSettle();
      //expect not to find the user
      final user_count = expect(find.textContaining(friend_username), findsNothing);
    });
    testWidgets('Add Users to the group', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      String group_name = await CreateGroup(tester);
      //open the group
      await OpenGroup(tester, group_name);
      final group_finder = find.textContaining(group_name);
      //tap on the group
      await tester.tap(group_finder);
      await tester.pumpAndSettle();
      final add_member_button = find.textContaining('Add Members');
      await tester.tap(add_member_button);
      await tester.pumpAndSettle();
      final friend_finder = find.textContaining(friend_username);
      await tester.tap(friend_finder);
      await tester.pumpAndSettle();
      final add_button = find.textContaining('ADD');
      await tester.tap(add_button);
      await tester.pumpAndSettle();
    });
    testWidgets('Set Permission to users inside the group', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      String group_name = await CreateGroup(tester);
      //open the group
      await OpenGroup(tester, group_name);
      final group_finder = find.textContaining(group_name);
      //tap on the group
      await tester.tap(group_finder);
      await tester.pumpAndSettle();
      final friend_finder = find.textContaining(friend_username);
      //hold on it
      await tester.longPress(friend_finder);
      await tester.pumpAndSettle();
      final set_permission_button = find.textContaining('Change Per');
      await tester.tap(set_permission_button);
      await tester.pumpAndSettle();
      throw('Error: No key found for selecting permission');
    });
    testWidgets('Change Group Privacy', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      String group_name = await CreateGroup(tester);
      //open the group
      await OpenGroup(tester, group_name);
      final group_finder = find.textContaining(group_name);
      //tap on the group
      await tester.tap(group_finder);
      await tester.pumpAndSettle();
      final change_privacy_button = find.textContaining('privacy');
      await tester.tap(change_privacy_button);
      await tester.pumpAndSettle();
      final public_group = find.textContaining('Public');
      await tester.tap(public_group);
      await tester.pumpAndSettle();
      expect(find.textContaining('Public'), findsOneWidget);
      //make it private again
      await tester.tap(change_privacy_button);
      await tester.pumpAndSettle();
      final private_group = find.textContaining('Private');
      await tester.tap(private_group);
      await tester.pumpAndSettle();
      expect(find.textContaining('Private'), findsOneWidget);
    });
    testWidgets('Change Group Size Limit', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      String group_name = await CreateGroup(tester);
      //open the group
      await OpenGroup(tester, group_name);
      final group_finder = find.textContaining(group_name);
      //tap on the group
      await tester.tap(group_finder);
      await tester.pumpAndSettle();
      final change_size_button = find.textContaining('Set group max size');
      await tester.tap(change_size_button);
      await tester.pumpAndSettle();
      final size_field = find.textContaining('Max Size');
      await tester.enterText(size_field, '99');
      await tester.pumpAndSettle();
      expect(find.textContaining('99'), findsOneWidget);
    });
    testWidgets('Send Announcements ', (WidgetTester tester) async {
      throw('Error: No Way Found for Making An Announcement');
    });
    testWidgets('Search in a Group', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      String group_name = await CreateGroup(tester);
      //open the group
      await OpenGroup(tester, group_name);
      final group_finder = find.textContaining(group_name);
      //tap on the group
      Finder search_icon = find.byKey(const ValueKey(CustomAppBarKeys.searchIcon));
      await tester.tap(search_icon);
      await tester.pumpAndSettle();
      final search_field = find.textContaining('Search');
      await tester.enterText(search_field, friend_username);
      await tester.pumpAndSettle();
      expect(find.textContaining(friend_username), findsOneWidget);
    });
  });
}