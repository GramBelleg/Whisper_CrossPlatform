import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:whisper/keys/login_keys.dart';
import 'package:whisper/main.dart' as app;
import 'utils/auth_user.dart';
import 'package:whisper/keys/tap_bar_keys.dart';
import 'package:whisper/keys/main_chats_keys.dart';
import 'package:whisper/keys/chat_page_keys.dart';
import 'package:whisper/keys/custom_app_bar_keys.dart';
import 'utils/test_common_functions.dart';
import 'package:whisper/keys/forward_menu_keys.dart';
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Channels E2E Tests', ()
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
    Future<void> OpenChannel(WidgetTester tester,String channel_name) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(chats_page);
      await tester.pumpAndSettle();
      final channel_finder = find.textContaining(channel_name);
      await tester.tap(channel_finder);
      await tester.pumpAndSettle();
    }
    Future<void> DeleteChannel(WidgetTester tester,String channel_name) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(chats_page);
      await tester.pumpAndSettle();
      final channel_finder = find.textContaining(channel_name);
      // drag left to reveal delete button
      await tester.drag(channel_finder, const Offset(-300, 0));
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
    testWidgets('Create Channel', (WidgetTester tester) async {
      String channel_name = await CreateChannel(tester);
      await tester.pumpAndSettle();
      final channel_finder = find.textContaining(channel_name);
      expect(channel_finder, findsOneWidget);
    });
    testWidgets('Open Channel', (WidgetTester tester) async {
      String channel_name = await CreateChannel(tester);
      await tester.pumpAndSettle();
      await OpenChannel(tester,channel_name);
      await tester.pumpAndSettle();
      final channel_name_finder = find.textContaining(channel_name);
      expect(channel_name_finder, findsOneWidget);
    });
    testWidgets('Delete Channel', (WidgetTester tester) async {
      String channel_name = await CreateChannel(tester);
      await tester.pumpAndSettle();
      await DeleteChannel(tester,channel_name);
      await tester.pumpAndSettle();
      final channel_name_finder = find.textContaining(channel_name);
      expect(channel_name_finder, findsNothing);
    });
    testWidgets('Leave Channel', (WidgetTester tester) async {
      String channel_name = await CreateChannel(tester);
      await tester.pumpAndSettle();
      await OpenChannel(tester,channel_name);
      await tester.pumpAndSettle();
      final leave_channel_button = find.textContaining('Leave channel');
      await tester.tap(leave_channel_button);
      await tester.pumpAndSettle();
      final channel_name_finder = find.textContaining(channel_name);
      expect(channel_name_finder, findsNothing);
    });
    testWidgets('Mute Channel', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      String channel_name = await CreateChannel(tester);
      final channel_finder = find.textContaining(channel_name);
      // drag right to reveal mute button
      await tester.drag(channel_finder, const Offset(300, 0));
      await tester.pumpAndSettle();
      final mute_button = find.byKey(const ValueKey(MainChatsKeys.muteButton));
      await tester.tap(mute_button);
      await tester.pumpAndSettle();
      final week_duration = find.byKey(const ValueKey(MainChatsKeys.weekDuration));
      await tester.tap(week_duration);
      await tester.pumpAndSettle();
      //try hours
      await tester.drag(channel_finder, const Offset(300, 0));
      await tester.pumpAndSettle();
      await tester.tap(mute_button);
      await tester.pumpAndSettle();
      final hours_duration = find.byKey(const ValueKey(MainChatsKeys.hoursDuration));
      await tester.tap(hours_duration);
      await tester.pumpAndSettle();
      //try always
      await tester.drag(channel_finder, const Offset(300, 0));
      await tester.pumpAndSettle();
      await tester.tap(mute_button);
      await tester.pumpAndSettle();
      final always_duration = find.byKey(const ValueKey(MainChatsKeys.alwaysDuration));
      await tester.tap(always_duration);
      await tester.pumpAndSettle();
    });
    testWidgets('Add Admins', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      String channel_name = await CreateChannel(tester);
      //open the channel
      await OpenChannel(tester, channel_name);
      final channel_finder = find.textContaining(channel_name);
      //tap on the channel
      await tester.tap(channel_finder);
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
    testWidgets('Add Subscribers to the channel', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      String channel_name = await CreateChannel(tester);
      //open the channel
      await OpenChannel(tester, channel_name);
      final channel_finder = find.textContaining(channel_name);
      //tap on the channel
      await tester.tap(channel_finder);
      await tester.pumpAndSettle();
      final add_member_button = find.textContaining('Add Subscribers');
      await tester.tap(add_member_button);
      await tester.pumpAndSettle();
      final friend_finder = find.textContaining(friend_username);
      await tester.tap(friend_finder);
      await tester.pumpAndSettle();
      final add_button = find.textContaining('ADD');
      await tester.tap(add_button);
      await tester.pumpAndSettle();
    });
    testWidgets('Post Messages', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      String channel_name = await CreateChannel(tester);
      //open the channel
      await OpenChannel(tester, channel_name);
      final post_field = find.byKey(const ValueKey(ChatPageKeys.textField));
      await tester.enterText(post_field, 'Hello');
      await tester.pumpAndSettle();
      final send_button = find.byKey(const ValueKey(ChatPageKeys.sendButton));
      await tester.tap(send_button);
      await tester.pumpAndSettle();
      expect(find.textContaining('Hello'), findsOneWidget);
    });
    testWidgets('Change Channel Privacy', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      String channel_name = await CreateChannel(tester);
      //open the channel
      await OpenChannel(tester, channel_name);
      final channel_finder = find.textContaining(channel_name);
      //tap on the channel
      await tester.tap(channel_finder);
      await tester.pumpAndSettle();
      final change_privacy_button = find.textContaining('privacy');
      await tester.tap(change_privacy_button);
      await tester.pumpAndSettle();
      final public_channel = find.textContaining('Public');
      await tester.tap(public_channel);
      await tester.pumpAndSettle();
      expect(find.textContaining('Public'), findsOneWidget);
      //make it private again
      await tester.tap(change_privacy_button);
      await tester.pumpAndSettle();
      final private_channel = find.textContaining('Private');
      await tester.tap(private_channel);
      await tester.pumpAndSettle();
      expect(find.textContaining('Private'), findsOneWidget);
    });
    testWidgets('Invite users Via Link', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      String channel_name = await CreateChannel(tester);
      //open the channel
      await OpenChannel(tester, channel_name);
      final channel_finder = find.textContaining(channel_name);
      //tap on the channel
      await tester.tap(channel_finder);
      await tester.pumpAndSettle();
      final invite_button = find.textContaining('Invite');
      await tester.tap(invite_button);
      await tester.pumpAndSettle();
      final copy_link_button = find.textContaining('Copy Link');
      await tester.tap(copy_link_button);
      await tester.pumpAndSettle();
    });
    testWidgets('Forward Posts to Chats and Groups', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      String channel_name = await CreateChannel(tester);
      String group_name= await CreateGroup(tester);
      //open the channel
      await OpenChannel(tester, channel_name);
      //post a message
      final post_field = find.byKey(const ValueKey(ChatPageKeys.textField));
      await tester.enterText(post_field, 'Hello');
      await tester.pumpAndSettle();
      final send_button = find.byKey(const ValueKey(ChatPageKeys.sendButton));
      await tester.tap(send_button);
      await tester.pumpAndSettle();
      //forward the message to the group
      final post_finder = find.textContaining('Hello');
      await tester.longPress(post_finder);
      await tester.pumpAndSettle();
      final forward_icon = find.byKey(const ValueKey(CustomAppBarKeys.forwardIcon));
      await tester.tap(forward_icon);
      await tester.pumpAndSettle();
      final group_finder = find.textContaining(group_name);
      await tester.tap(group_finder);
      await tester.pumpAndSettle();
      final friend_finder= find.textContaining(friend_username);
      await tester.tap(friend_finder);
      await tester.pumpAndSettle();
      final forward_button = find.byKey(const ValueKey(ForwardMenuKeys.forwardButton));
      await tester.tap(forward_button);
      await tester.pumpAndSettle();
    });
    testWidgets('Set Permission to users inside the channel', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      String channel_name = await CreateChannel(tester);
      //open the channel
      await OpenChannel(tester, channel_name);
      final channel_finder = find.textContaining(channel_name);
      //tap on the channel
      await tester.tap(channel_finder);
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
    testWidgets('Set ability to add Comments(threads)', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      String channel_name = await CreateChannel(tester);
      //open the channel
      await OpenChannel(tester, channel_name);
      final channel_finder = find.textContaining(channel_name);
      //tap on the channel
      await tester.tap(channel_finder);
      await tester.pumpAndSettle();
      final allow_comments = find.textContaining('Allow Comments');
      await tester.tap(allow_comments);
      await tester.pumpAndSettle();
    });
  });
}