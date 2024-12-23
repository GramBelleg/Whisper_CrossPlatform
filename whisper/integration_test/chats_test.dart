import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:whisper/keys/login_keys.dart';
import 'package:whisper/main.dart' as app;
import 'utils/auth_user.dart';
import 'package:whisper/keys/chat_page_keys.dart';
import 'package:whisper/keys/emoji_button_sheet_keys.dart';
import 'package:whisper/keys/custom_chat_text_field_keys.dart';
import 'package:whisper/keys/file_button_sheet_keys.dart';
import 'package:whisper/keys/custom_app_bar_keys.dart';
import 'utils/test_common_functions.dart';
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Chat E2E Tests', ()
  {
    late Finder email_field;
    late Finder password_field;
    late Finder login_button;
    late Finder chats_page;
    final friendUsername = AuthUser.whisper_friend_username;


    Future<void> openChat(WidgetTester tester, Finder chatsPageFinder, String friendUsername) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(chatsPageFinder);
      await tester.pumpAndSettle();
      final friendChatFinder = find.textContaining(friendUsername);
      await tester.tap(friendChatFinder);
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
        chats_page = find.byKey(const ValueKey('ChatsPageKey'));
        await tester.pumpAndSettle();
      } catch (e) {
        // Check if user is already logged in and handle accordingly
        try {
          await tester.pumpAndSettle(); // Wait for UI to settle again
          chats_page = find.byKey(const ValueKey('ChatsPageKey'));
          await tester.pumpAndSettle();
        } catch (e) {
          // Print error if setup failed
          print('Error: setup failed');
        }
      }
    });
    testWidgets('Open Chat with a Friend', (WidgetTester tester) async {
      await openChat(tester, chats_page, friendUsername);
      expect(find.textContaining(friendUsername), findsOneWidget);
    });

    testWidgets('Send Message', (WidgetTester tester) async {
      await openChat(tester, chats_page, friendUsername);
      final chat_textbox = find.byKey(const ValueKey(ChatPageKeys.textField));
      String message_to_be_sent=generateRandomString(10);
      await tester.enterText(chat_textbox, message_to_be_sent);
      await tester.pumpAndSettle();
      final chat_send_button = find.byKey(const ValueKey(ChatPageKeys.sendButton));
      await tester.tap(chat_send_button);
      await tester.pumpAndSettle();
      expect(find.textContaining(message_to_be_sent), findsOneWidget);
    });
    testWidgets('Send Voice Note', (WidgetTester tester) async {
      await openChat(tester, chats_page, friendUsername);
      final chat_record_audio_button = find.byKey(const ValueKey(ChatPageKeys.recordButton));
      await tester.tap(chat_record_audio_button);
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(Duration(seconds: 5));
      final stop_record_button = find.byKey(const ValueKey(ChatPageKeys.stopRecordButton));
      await tester.tap(stop_record_button);
      await tester.pumpAndSettle();
    });
    testWidgets('Send Emoji', (WidgetTester tester) async {
      await openChat(tester, chats_page, friendUsername);
      await tester.pumpAndSettle(Duration(seconds: 2));
      final emoji_picker = find.byKey(const ValueKey(ChatPageKeys.emojiPicker));
      await tester.tap(emoji_picker);
      await tester.pumpAndSettle();
      final emoji = find.byKey(const ValueKey(EmojiButtonSheetKeys.emojiButton));
      await tester.tap(emoji);
    });
    testWidgets('Send Sticker', (WidgetTester tester) async {
      await openChat(tester, chats_page, friendUsername);
      await tester.pumpAndSettle(Duration(seconds: 2));
      final emoji_picker = find.byKey(const ValueKey(ChatPageKeys.emojiPicker));
      await tester.tap(emoji_picker);
      await tester.pumpAndSettle();
      final sticker = find.byKey(const ValueKey(EmojiButtonSheetKeys.stickerButton));
      await tester.tap(sticker);
    });
    testWidgets('Send Gif', (WidgetTester tester) async {
      await openChat(tester, chats_page, friendUsername);
      await tester.pumpAndSettle(Duration(seconds: 2));
      final emoji_picker = find.byKey(const ValueKey(ChatPageKeys.emojiPicker));
      await tester.tap(emoji_picker);
      await tester.pumpAndSettle();
      final gif = find.byKey(const ValueKey(EmojiButtonSheetKeys.gifButton));
      await tester.tap(gif);
      expect(find.textContaining('Search GIFs'), findsOneWidget);
    });
    testWidgets('Send Document',(WidgetTester tester) async {
      await openChat(tester, chats_page, friendUsername);
      final file_picker = find.byKey(const ValueKey(CustomChatTextFieldKeys.filePickerButton));
      await tester.tap(file_picker);
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey(FileButtonSheetKeys.documentIcon)), findsOneWidget);
    });
    testWidgets('Send Camera Photo',(WidgetTester tester) async {
      await openChat(tester, chats_page, friendUsername);
      final file_picker = find.byKey(const ValueKey(CustomChatTextFieldKeys.filePickerButton));
      await tester.tap(file_picker);
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey(FileButtonSheetKeys.cameraIcon)), findsOneWidget);
    });
    testWidgets('Send Gallery Photo',(WidgetTester tester) async {
      await openChat(tester, chats_page, friendUsername);
      final file_picker = find.byKey(const ValueKey(CustomChatTextFieldKeys.filePickerButton));
      await tester.tap(file_picker);
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey(FileButtonSheetKeys.galleryIcon)), findsOneWidget);
    });
    testWidgets('Send Audio file',(WidgetTester tester) async {
      await openChat(tester, chats_page, friendUsername);
      final file_picker = find.byKey(const ValueKey(CustomChatTextFieldKeys.filePickerButton));
      await tester.tap(file_picker);
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey(FileButtonSheetKeys.audioIcon)), findsOneWidget);
    });
    testWidgets('Delete Message for Me', (WidgetTester tester) async {
      await openChat(tester, chats_page, friendUsername);
      final chat_textbox = find.byKey(const ValueKey(ChatPageKeys.textField));
      String message_to_be_sent=generateRandomString(10);
      await tester.enterText(chat_textbox, message_to_be_sent);
      await tester.pumpAndSettle();
      final chat_send_button = find.byKey(const ValueKey(ChatPageKeys.sendButton));
      await tester.tap(chat_send_button);
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(Duration(seconds: 1));
      final message = find.textContaining(message_to_be_sent);
      await tester.longPress(message);
      await tester.pumpAndSettle();
      final delete_icon= find.byKey(const ValueKey(CustomAppBarKeys.deleteIcon));
      await tester.tap(delete_icon);
      await tester.pumpAndSettle();
      final delete_for_me_button = find.byKey(const ValueKey(CustomAppBarKeys.deleteForMeButton));
      await tester.tap(delete_for_me_button);
      await tester.pumpAndSettle();
      expect(find.textContaining(message_to_be_sent), findsNothing);
    });
    testWidgets('Delete Message For Everyone', (WidgetTester tester) async {
      await openChat(tester, chats_page, friendUsername);
      final chat_textbox = find.byKey(const ValueKey(ChatPageKeys.textField));
      String message_to_be_sent=generateRandomString(10);
      await tester.enterText(chat_textbox, message_to_be_sent);
      await tester.pumpAndSettle();
      final chat_send_button = find.byKey(const ValueKey(ChatPageKeys.sendButton));
      await tester.tap(chat_send_button);
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(Duration(seconds: 1));
      final message = find.textContaining(message_to_be_sent);
      await tester.longPress(message);
      await tester.pumpAndSettle();
      final delete_icon= find.byKey(const ValueKey(CustomAppBarKeys.deleteIcon));
      await tester.tap(delete_icon);
      await tester.pumpAndSettle();
      final delete_for_everyone_button = find.byKey(const ValueKey(CustomAppBarKeys.deleteForEveryoneButton));
      await tester.tap(delete_for_everyone_button);
      await tester.pumpAndSettle();
      expect(find.textContaining(message_to_be_sent), findsNothing);
    });
    testWidgets('Cancel Deletion', (WidgetTester tester) async {
      await openChat(tester, chats_page, friendUsername);
      final chat_textbox = find.byKey(const ValueKey(ChatPageKeys.textField));
      String message_to_be_sent=generateRandomString(10);
      await tester.enterText(chat_textbox, message_to_be_sent);
      await tester.pumpAndSettle();
      final chat_send_button = find.byKey(const ValueKey(ChatPageKeys.sendButton));
      await tester.tap(chat_send_button);
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(Duration(seconds: 1));
      final message = find.textContaining(message_to_be_sent);
      await tester.longPress(message);
      await tester.pumpAndSettle();
      final delete_icon= find.byKey(const ValueKey(CustomAppBarKeys.deleteIcon));
      await tester.tap(delete_icon);
      await tester.pumpAndSettle();
      final cancel_button = find.byKey(const ValueKey(CustomAppBarKeys.cancelButton));
      await tester.tap(cancel_button);
      await tester.pumpAndSettle();
      expect(find.textContaining(message_to_be_sent), findsOneWidget);
    });
    testWidgets('Edit Message Successfully', (WidgetTester tester) async {
      await openChat(tester, chats_page, friendUsername);
      final chat_textbox = find.byKey(const ValueKey(ChatPageKeys.textField));
      String message_to_be_sent=generateRandomString(10);
      await tester.enterText(chat_textbox, message_to_be_sent);
      await tester.pumpAndSettle();
      final chat_send_button = find.byKey(const ValueKey(ChatPageKeys.sendButton));
      await tester.tap(chat_send_button);
      await tester.pumpAndSettle();
      final message = find.textContaining(message_to_be_sent);
      await tester.longPress(message);
      await tester.pumpAndSettle();
      final popup_menu = find.byKey(const ValueKey(CustomAppBarKeys.popupMenu));
      await tester.tap(popup_menu);
      await tester.pumpAndSettle();
      final edit_icon= find.byKey(const ValueKey(CustomAppBarKeys.popupEdit));
      await tester.tap(edit_icon);
      await tester.pumpAndSettle();
      final chat_textbox_edit = find.byKey(const ValueKey(ChatPageKeys.textField));
      String message_to_be_edited=generateRandomString(10);
      await tester.enterText(chat_textbox_edit, message_to_be_edited);
      await tester.pumpAndSettle();
      final chat_send_button_edit = find.byKey(const ValueKey(ChatPageKeys.editMessageButton));
      await tester.tap(chat_send_button_edit);
      await tester.pumpAndSettle();
      expect(find.textContaining(message_to_be_edited), findsOneWidget);
    });
    testWidgets('Cancel Editing the Message', (WidgetTester tester) async {
      await openChat(tester, chats_page, friendUsername);
      final chat_textbox = find.byKey(const ValueKey(ChatPageKeys.textField));
      String message_to_be_sent=generateRandomString(10);
      await tester.enterText(chat_textbox, message_to_be_sent);
      await tester.pumpAndSettle();
      final chat_send_button = find.byKey(const ValueKey(ChatPageKeys.sendButton));
      await tester.tap(chat_send_button);
      await tester.pumpAndSettle();
      final message = find.textContaining(message_to_be_sent);
      await tester.longPress(message);
      await tester.pumpAndSettle();
      final popup_menu = find.byKey(const ValueKey(CustomAppBarKeys.popupMenu));
      await tester.tap(popup_menu);
      await tester.pumpAndSettle();
      final edit_icon= find.byKey(const ValueKey(CustomAppBarKeys.popupEdit));
      await tester.tap(edit_icon);
      await tester.pumpAndSettle();
      final chat_textbox_edit = find.byKey(const ValueKey(ChatPageKeys.textField));
      String message_to_be_edited=generateRandomString(10);
      await tester.enterText(chat_textbox_edit, message_to_be_edited);
      await tester.pumpAndSettle();
      final cancel_edit_button = find.byKey(const ValueKey(CustomChatTextFieldKeys.cancelEditing));
      await tester.tap(cancel_edit_button);
      await tester.pumpAndSettle();
      expect(find.textContaining(message_to_be_sent), findsOneWidget);
    });
    testWidgets('Pin Message', (WidgetTester tester) async {
      await openChat(tester, chats_page, friendUsername);
      final chat_textbox = find.byKey(const ValueKey(ChatPageKeys.textField));
      String message_to_be_sent=generateRandomString(10);
      await tester.enterText(chat_textbox, message_to_be_sent);
      await tester.pumpAndSettle();
      final chat_send_button = find.byKey(const ValueKey(ChatPageKeys.sendButton));
      await tester.tap(chat_send_button);
      await tester.pumpAndSettle();
      final message = find.textContaining(message_to_be_sent);
      await tester.longPress(message);
      await tester.pumpAndSettle();
      final popup_menu = find.byKey(const ValueKey(CustomAppBarKeys.popupMenu));
      await tester.tap(popup_menu);
      await tester.pumpAndSettle();
      final pin_icon= find.byKey(const ValueKey(CustomAppBarKeys.popupPin));
      await tester.tap(pin_icon);
      await tester.pumpAndSettle();
      expect(find.textContaining(message_to_be_sent), findsOneWidget);
    });
    testWidgets('Reply on a Message', (WidgetTester tester) async {
      await openChat(tester, chats_page, friendUsername);
      final chat_textbox = find.byKey(const ValueKey(ChatPageKeys.textField));
      String message_to_be_sent = generateRandomString(10);
      await tester.enterText(chat_textbox, message_to_be_sent);
      await tester.pumpAndSettle();
      final chat_send_button = find.byKey(const ValueKey(ChatPageKeys.sendButton));
      await tester.tap(chat_send_button);
      await tester.pumpAndSettle();
      final message = find.textContaining(message_to_be_sent);
      await tester.drag(message, const Offset(300.0, 0.0));
      await tester.pumpAndSettle();
      expect(find.textContaining(message_to_be_sent), findsNWidgets(2));
      //reply to the message
      String reply_message = generateRandomString(10);
      await tester.enterText(chat_textbox, reply_message);
      await tester.pumpAndSettle();
      await tester.tap(chat_send_button);
      await tester.pumpAndSettle();
      expect(find.textContaining(message_to_be_sent), findsNWidgets(2));
      expect(find.textContaining(reply_message), findsOneWidget);
    });
    testWidgets('Select Multiple Messages', (WidgetTester tester) async {
      await openChat(tester, chats_page, friendUsername);
      final chat_textbox = find.byKey(const ValueKey(ChatPageKeys.textField));
      String message_to_be_sent=generateRandomString(10);
      await tester.enterText(chat_textbox, message_to_be_sent);
      await tester.pumpAndSettle();
      final chat_send_button = find.byKey(const ValueKey(ChatPageKeys.sendButton));
      await tester.tap(chat_send_button);
      await tester.pumpAndSettle();
      String message_to_be_sent_2=generateRandomString(10);
      await tester.enterText(chat_textbox, message_to_be_sent_2);
      await tester.pumpAndSettle();
      await tester.tap(chat_send_button);
      await tester.pumpAndSettle();
      final message = find.textContaining(message_to_be_sent);
      await tester.longPress(message);
      await tester.pumpAndSettle();
      final message_2 = find.textContaining(message_to_be_sent_2);
      await tester.tap(message_2);
      await tester.pumpAndSettle();
      //untag
      await tester.tap(message_2);
      await tester.pumpAndSettle();
      //expect to find the delete icon as one is selected
      expect(find.byKey(const ValueKey(CustomAppBarKeys.deleteIcon)), findsOneWidget);
    });
    testWidgets('Forward Message', (WidgetTester tester) async {
      await openChat(tester, chats_page, friendUsername);
      final chat_textbox = find.byKey(const ValueKey(ChatPageKeys.textField));
      String message_to_be_sent=generateRandomString(10);
      await tester.enterText(chat_textbox, message_to_be_sent);
      await tester.pumpAndSettle();
      final chat_send_button = find.byKey(const ValueKey(ChatPageKeys.sendButton));
      await tester.tap(chat_send_button);
      await tester.pumpAndSettle();
      final message = find.textContaining(message_to_be_sent);
      await tester.longPress(message);
      await tester.pumpAndSettle();
      final forward_icon= find.byKey(const ValueKey(CustomAppBarKeys.forwardIcon));
      await tester.tap(forward_icon);
      await tester.pumpAndSettle();
      expect(find.textContaining(message_to_be_sent), findsOneWidget);
    });
    //ADVANCED FEATURES
    testWidgets('Self Destructing Messages (based on telegram)', (WidgetTester tester) async {
      await openChat(tester, chats_page, friendUsername);
      final friend_finder=find.textContaining(friendUsername);
      await tester.tap(friend_finder);
      await tester.pumpAndSettle();
      //expect to find 3 dots
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();
      //expect to find the self destructing messages option
      await tester.tap(find.text('Auto Delete'));
      await tester.pumpAndSettle();
      //expect to find the 1 day ,1 week,1 moth,custom
      expect(find.text('1 day'), findsOneWidget);
      expect(find.text('1 week'), findsOneWidget);
      expect(find.text('1 month'), findsOneWidget);
      expect(find.text('Custom'), findsOneWidget);
    });
    testWidgets('Draft Messages', (WidgetTester tester) async {
      await openChat(tester, chats_page, friendUsername);
      final chat_textbox = find.byKey(const ValueKey(ChatPageKeys.textField));
      String message_to_be_sent=generateRandomString(10);
      await tester.enterText(chat_textbox, message_to_be_sent);
      await tester.pumpAndSettle();
      //press Back Button
      await tester.tap(find.byKey(const ValueKey(CustomAppBarKeys.backButton)));
      await tester.pumpAndSettle();
      //expect to find the draft message
      expect(find.textContaining(message_to_be_sent), findsOneWidget);
      //go inside again and sent it
      await openChat(tester, chats_page, friendUsername);
      await tester.pumpAndSettle();
      final chat_send_button = find.byKey(const ValueKey(ChatPageKeys.sendButton));
      await tester.tap(chat_send_button);
      await tester.pumpAndSettle();
      expect(find.textContaining(message_to_be_sent), findsOneWidget);
    });
    testWidgets('Search Within chat', (WidgetTester tester) async {
      await openChat(tester, chats_page, friendUsername);
      //send message
      final chat_textbox = find.byKey(const ValueKey(ChatPageKeys.textField));
      String message_to_be_sent=generateRandomString(10);
      await tester.enterText(chat_textbox, message_to_be_sent);
      await tester.pumpAndSettle();
      final chat_send_button = find.byKey(const ValueKey(ChatPageKeys.sendButton));
      await tester.tap(chat_send_button);
      await tester.pumpAndSettle();
      final search_icon = find.byKey(const ValueKey(CustomAppBarKeys.searchIcon));
      await tester.tap(search_icon);
      await tester.pumpAndSettle();
      //expect to find the search bar
      final search_field=find.textContaining('Search');
      //search for the message
      await tester.enterText(search_field, message_to_be_sent);
      await tester.pumpAndSettle();
      final show_as_list=find.textContaining('Show as List');
      await tester.tap(show_as_list);
      await tester.pumpAndSettle();
      //expect to find the message
      expect(find.textContaining(message_to_be_sent), findsOneWidget);
    });
  });
}