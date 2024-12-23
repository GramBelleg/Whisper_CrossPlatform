import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:whisper/keys/login_keys.dart';
import 'package:whisper/main.dart' as app;
import 'utils/auth_user.dart';
import 'package:whisper/keys/tap_bar_keys.dart';
import 'package:whisper/keys/main_chats_keys.dart';
import 'package:whisper/keys/chat_page_keys.dart';
import 'package:whisper/keys/call_page_keys.dart';
import 'package:whisper/keys/custom_app_bar_keys.dart';
import 'utils/test_common_functions.dart';
import 'package:whisper/keys/forward_menu_keys.dart';
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('Calls E2E Tests', ()
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
    testWidgets('Make a phone call', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(chats_page);
      await tester.pumpAndSettle();
      final friend_finder= find.textContaining(friend_username);
      await tester.tap(friend_finder);
      await tester.pumpAndSettle();
      final phone_icon = find.byKey(const ValueKey(CustomAppBarKeys.phoneIcon));
      await tester.tap(phone_icon);
      await tester.pumpAndSettle();
      final mute_button=find.byKey(const ValueKey(CallPageKeys.muteButton));
      await tester.tap(mute_button);
      await tester.pumpAndSettle();
      //unmute
      await tester.tap(mute_button);
      await tester.pumpAndSettle();
      final end_call=find.byKey(const ValueKey(CallPageKeys.endCallButton));
      await tester.tap(end_call);
      await tester.pumpAndSettle();
      expect(find.textContaining(friend_username), findsOneWidget);
    });
    testWidgets('Make Group Call', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(chats_page);
      await tester.pumpAndSettle();
      final group_name = await CreateGroup(tester);
      await tester.pumpAndSettle();
      final group_finder= find.textContaining(group_name);
      await tester.tap(group_finder);
      await tester.pumpAndSettle();
      final phone_icon = find.byKey(const ValueKey(CustomAppBarKeys.phoneIcon));
      await tester.tap(phone_icon);
      await tester.pumpAndSettle();
      final mute_button=find.byKey(const ValueKey(CallPageKeys.muteButton));
      await tester.tap(mute_button);
      await tester.pumpAndSettle();
      //unmute
      await tester.tap(mute_button);
      await tester.pumpAndSettle();
      final end_call=find.byKey(const ValueKey(CallPageKeys.endCallButton));
      await tester.tap(end_call);
      await tester.pumpAndSettle();
      expect(find.textContaining(group_name), findsOneWidget);
    });
    testWidgets('Go to Call Log', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      final call_log_button = find.byKey(const ValueKey(TapBarKeys.callLogButton));
      await tester.tap(call_log_button);
      //find my friend previous call
      final friend_finder= find.textContaining(friend_username);
      expect(friend_finder, findsOneWidget);
    });
  });
}