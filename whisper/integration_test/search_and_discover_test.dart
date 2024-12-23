import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:whisper/keys/login_keys.dart';
import 'package:whisper/main.dart' as app;
import 'utils/auth_user.dart';
import 'package:whisper/keys/tap_bar_keys.dart';
import 'package:whisper/keys/main_chats_keys.dart';
import 'package:whisper/keys/chat_page_keys.dart';
import 'utils/test_common_functions.dart';
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('Search And Discover E2E Tests', ()
  {
    late Finder email_field;
    late Finder password_field;
    late Finder login_button;
    late Finder chats_page;
    final friend_username = AuthUser.whisper_friend_username;
    late String group_name;
    late String channel_name;
    final message_to_be_searched_for=generateRandomString(10);

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
      final select_user = find.byKey(key);
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
    testWidgets('Create Group', (WidgetTester tester) async {
      group_name = await CreateGroup(tester);
      expect(find.textContaining(group_name), findsOne);
    });
    testWidgets('Create Channel', (WidgetTester tester) async {
      channel_name = await CreateChannel(tester);
      expect(find.textContaining(channel_name), findsOne);
    });
    testWidgets('Send Message to a friend', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(chats_page);
      await tester.pumpAndSettle();
      final friend_finder= find.textContaining(friend_username);
      await tester.tap(friend_finder);
      await tester.pumpAndSettle();
      final message_field = find.byKey(const ValueKey(ChatPageKeys.textField));
      await tester.enterText(message_field, message_to_be_searched_for);
      await tester.pumpAndSettle();
      final send_button = find.byKey(const ValueKey(ChatPageKeys.sendButton));
      await tester.tap(send_button);
      await tester.pumpAndSettle();
      expect(find.textContaining(message_to_be_searched_for), findsOne);
    });
    testWidgets('Post in A group', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(chats_page);
      await tester.pumpAndSettle();
      final group_finder= find.textContaining(group_name);
      await tester.tap(group_finder);
      await tester.pumpAndSettle();
      final message_field = find.byKey(const ValueKey(ChatPageKeys.textField));
      await tester.enterText(message_field, message_to_be_searched_for);
      await tester.pumpAndSettle();
      final send_button = find.byKey(const ValueKey(ChatPageKeys.sendButton));
      await tester.tap(send_button);
      await tester.pumpAndSettle();
    });
    testWidgets('Send in A channel', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(chats_page);
      await tester.pumpAndSettle();
      final channel_finder= find.textContaining(channel_name);
      await tester.tap(channel_finder);
      await tester.pumpAndSettle();
      final message_field = find.byKey(const ValueKey(ChatPageKeys.textField));
      await tester.enterText(message_field, message_to_be_searched_for);
      await tester.pumpAndSettle();
      final send_button = find.byKey(const ValueKey(ChatPageKeys.sendButton));
      await tester.tap(send_button);
      await tester.pumpAndSettle();
    });
    testWidgets('Search For message', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(chats_page);
      await tester.pumpAndSettle();
      final search_button = find.byKey(
          const ValueKey(MainChatsKeys.searchGestureDetector));
      await tester.tap(search_button);
      await tester.pumpAndSettle();
      final String part_of_the_message = message_to_be_searched_for.substring(0, 5);
      final search_field = find.textContaining('Search');
      await tester.enterText(search_field, part_of_the_message);
      await tester.pumpAndSettle();
      expect(find.textContaining(part_of_the_message), findsExactly(3));
      await tester.tap(find.textContaining('Channel'));
      await tester.pumpAndSettle();
      expect(find.textContaining(part_of_the_message), findsOne);
      await tester.tap(find.textContaining('Group'));
      await tester.pumpAndSettle();
      expect(find.textContaining(part_of_the_message), findsOne);
      await tester.tap(find.textContaining('Chat'));
      await tester.pumpAndSettle();
      expect(find.textContaining(part_of_the_message), findsOne);
      await tester.tap(find.textContaining('Link'));
      await tester.pumpAndSettle();
      expect(find.textContaining(part_of_the_message), findsNothing);
      await tester.tap(find.textContaining('Video'));
      await tester.pumpAndSettle();
      expect(find.textContaining(part_of_the_message), findsNothing);
      await tester.tap(find.textContaining('image'));
      await tester.pumpAndSettle();
      expect(find.textContaining(part_of_the_message), findsNothing);
      await tester.tap(find.textContaining('text'));
      await tester.pumpAndSettle();
      expect(find.textContaining(part_of_the_message), findsOne);
    });
    testWidgets('Search for A group or channel or a friend', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(chats_page);
      await tester.pumpAndSettle();
      final search_button = find.byKey(
          const ValueKey(MainChatsKeys.searchGestureDetector));
      await tester.tap(search_button);
      await tester.pumpAndSettle();
      final search_field = find.textContaining('Search');
      await tester.enterText(search_field, group_name);
      await tester.pumpAndSettle();
      expect(find.textContaining(group_name), findsOne);
      await tester.enterText(search_field, channel_name);
      await tester.pumpAndSettle();
      expect(find.textContaining(channel_name), findsOne);
      await tester.enterText(search_field, friend_username);
      await tester.pumpAndSettle();
      expect(find.textContaining(friend_username), findsOne);
      await tester.enterText(search_field, AuthUser.email);
      await tester.pumpAndSettle();
      expect(find.textContaining(friend_username), findsOne);
      //search by name
      await tester.enterText(search_field, AuthUser.whisper_name);
      await tester.pumpAndSettle();
      expect(find.textContaining(AuthUser.whisper_name), findsOne);
      //by phone
      await tester.enterText(search_field, AuthUser.whisper_phone_number);
      await tester.pumpAndSettle();
      expect(find.textContaining(AuthUser.whisper_name), findsOne);
    });
  });
}