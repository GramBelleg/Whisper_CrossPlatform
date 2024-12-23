import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:whisper/keys/login_keys.dart';
import 'package:whisper/keys/main_chats_keys.dart';
import 'package:whisper/keys/tap_bar_keys.dart';
import 'package:whisper/keys/chat_page_keys.dart';
import 'package:whisper/main.dart' as app;
import 'utils/test_common_functions.dart';
import 'utils/auth_user.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('Notifications E2E Tests', ()
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
    Future<String> CreateChannel(WidgetTester tester) async {
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
      final select_user = find.byKey(key);
      await tester.tap(select_user);
      await tester.pumpAndSettle();
      final friend_finder = find.textContaining(friend_username);
      await tester.tap(friend_finder);
      await tester.pumpAndSettle();
      final create_channel_button = find.textContaining('Create channel');
      await tester.tap(create_channel_button);
      await tester.pumpAndSettle();
      final channel_name_field = find.textContaining('Enter channel Name');
      String channel_name_to_be_created = generateRandomString(10);
      await tester.enterText(channel_name_field, channel_name_to_be_created);
      await tester.pumpAndSettle();
      final create_button = find.textContaining('Create');
      await tester.tap(create_button);
      return channel_name_to_be_created;
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
    testWidgets('Send Message to Authorised user 2 from Authorised user 1', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(chats_page);
      await tester.pumpAndSettle();
      final friend_finder= find.textContaining(AuthUser.whisper_friend_username);
      await tester.tap(friend_finder);
      await tester.pumpAndSettle();
      final message_field = find.byKey(const ValueKey(ChatPageKeys.textField));
      await tester.enterText(message_field, 'Hello DM');
      await tester.pumpAndSettle();
      final send_button = find.byKey(const ValueKey(ChatPageKeys.sendButton));
      await tester.enterText(message_field, 'Hello DM again');
      await tester.pumpAndSettle();
      await tester.tap(send_button);
      await tester.pumpAndSettle();
    });
    testWidgets('Send message from group', (WidgetTester tester) async {
      final group_name = await CreateGroup(tester);
      await OpenGroup(tester, group_name);
      final message_field = find.byKey(const ValueKey(ChatPageKeys.textField));
      await tester.enterText(message_field, 'Hello Group');
      await tester.pumpAndSettle();
      final send_button = find.byKey(const ValueKey(ChatPageKeys.sendButton));
      await tester.tap(send_button);
      await tester.pumpAndSettle();
      //again
      await tester.enterText(message_field, 'Hello Group again');
      await tester.pumpAndSettle();
      await tester.tap(send_button);
      await tester.pumpAndSettle();
    });
    testWidgets('Send message from channel', (WidgetTester tester) async {
      final channel_name = await CreateChannel(tester);
      await OpenGroup(tester, channel_name);
      final message_field = find.byKey(const ValueKey(ChatPageKeys.textField));
      await tester.enterText(message_field, 'Hello Channel');
      await tester.pumpAndSettle();
      final send_button = find.byKey(const ValueKey(ChatPageKeys.sendButton));
      await tester.tap(send_button);
      await tester.pumpAndSettle();
      //again
      await tester.enterText(message_field, 'Hello Channel again');
      await tester.pumpAndSettle();
      await tester.tap(send_button);
      await tester.pumpAndSettle();
    });
    testWidgets('Logout', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      final settings_page = find.byKey(const ValueKey(TapBarKeys.settingsButton));
      await tester.tap(settings_page);
      await tester.pumpAndSettle();
      // Scroll to the Logout options
      await tester.drag(find.byType(Scrollable), const Offset(0, -800));
      await tester.pumpAndSettle(Duration(seconds: 2));
      final logout_button = find.textContaining('Logout From This Device');
      await tester.tap(logout_button);
      await tester.pumpAndSettle();
    });
    testWidgets('Login With the Authorized User2', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      try {
        // Locate elements
        email_field = find.byKey(const ValueKey(LoginKeys.emailTextFieldKey));
        password_field =
            find.byKey(const ValueKey(LoginKeys.passwordTextFieldKey));
        login_button = find.byKey(const ValueKey(LoginKeys.loginButtonKey));

        // Enter email and password
        await tester.enterText(email_field, AuthUser.email);
        await tester.enterText(
            password_field, AuthUser.whisper_friend_password);

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
    testWidgets('Check Notifications', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      final notification = find.textContaining('Hello DM Again');
      expect(notification, findsOne);
      final notification_group = find.textContaining('Hello Group Again');
      expect(notification_group, findsOne);
      final notification_channel = find.textContaining('Hello Channel Again');
      expect(notification_channel, findsOne);
      expect(find.textContaining('2'), findsExactly(3));
    });
    testWidgets('Mark Unread', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      final notification = find.textContaining('Hello DM Again');
      //long press
      await tester.longPress(notification);
      await tester.pumpAndSettle();
      final mark_unread = find.textContaining('Mark Unread');
      await tester.tap(mark_unread);
      await tester.pumpAndSettle();
      final notification_group = find.textContaining('Hello Group Again');
      //long press
      await tester.longPress(notification_group);
      await tester.pumpAndSettle();
      final mark_unread_group = find.textContaining('Mark Unread');
      await tester.tap(mark_unread_group);
      await tester.pumpAndSettle();
      final notification_channel = find.textContaining('Hello Channel Again');
      //long press
      await tester.longPress(notification_channel);
      await tester.pumpAndSettle();
      final mark_unread_channel = find.textContaining('Mark Unread');
      await tester.tap(mark_unread_channel);
      await tester.pumpAndSettle();
      expect(find.textContaining('2'), findsNothing);
    });
  });
}