import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:whisper/keys/login_keys.dart';
import 'package:whisper/keys/settings_page_keys.dart';
import 'package:whisper/keys/main_chats_keys.dart';
import 'package:whisper/main.dart' as app;
import 'utils/auth_user.dart';
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Story And User Settings E2E Tests', () {
    late Finder email_field;
    late Finder password_field;
    late Finder login_button;
    late Finder settings_option;
    late final double x_coordinate_of_photo;
    late final double y_coordinate_of_photo;
    testWidgets('assure the user is logged in', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      try {
        // Locate elements
        email_field = find.byKey(const ValueKey(LoginKeys.emailTextFieldKey));
        password_field = find.byKey(const ValueKey(LoginKeys.passwordTextFieldKey));
        login_button = find.byKey(const ValueKey(LoginKeys.loginButtonKey));

        // Enter email and password
        await tester.enterText(email_field, AuthUser.email_whisper_test);
        await tester.enterText(password_field, AuthUser.password_whisper_test_1);

        // Tap on the login button
        await tester.tap(login_button);
        await tester.pumpAndSettle();  // Wait for the UI to settle

        // Check if login is successful and settings page is loaded
        settings_option = find.byKey(const ValueKey('SettingsPageKey'));
        await tester.pumpAndSettle();

      } catch (e) {
        // Check if user is already logged in and handle accordingly
        try {
          await tester.pumpAndSettle();  // Wait for UI to settle again
          settings_option = find.byKey(const ValueKey('SettingsPageKey'));
          await tester.pumpAndSettle();
        } catch (e) {
          // Print error if setup failed
          print('Error: setup failed');
        }
      }
    });
    Future<void> openSettings(WidgetTester tester) async {
      app.main(); // Starts the app
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(Duration(seconds: 2));
      settings_option= find.byKey(const ValueKey('SettingsPageKey'));
      await tester.pumpAndSettle();
      await tester.tap(settings_option);
      await tester.pumpAndSettle();
    }

    Future<void> openEditPage(WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(Duration(seconds: 2));
      settings_option= find.byKey(const ValueKey('SettingsPageKey'));
      await tester.pumpAndSettle();
      await tester.tap(settings_option);
      await tester.pumpAndSettle();
      final editButton = find.byKey(const ValueKey(SettingsPageKeys.editButton));
      await tester.tap(editButton);
      await tester.pumpAndSettle();
    }

    testWidgets('Edit Phone Number', (WidgetTester tester) async {
      await openEditPage(tester);
      await tester.pumpAndSettle(Duration(seconds: 5));
      throw Exception('Error: Key not found for phone editing');
    });
    testWidgets('Edit bio', (WidgetTester tester) async {
      await openEditPage(tester);
      throw Exception('Error: Key not found for bio editing');
    });
    testWidgets('Edit Name', (WidgetTester tester) async {
      await openEditPage(tester);
      throw Exception('Error: Key not found for Name editing');
    });
    testWidgets('Edit username', (WidgetTester tester) async {
      await openEditPage(tester);
      throw Exception('Error: Key not found for username editing');
    });
    testWidgets('Edit email', (WidgetTester tester) async {
      await openEditPage(tester);
      throw Exception('Error: Key not found for email editing');
    });
    testWidgets('Show photo', (WidgetTester tester) async {
      await openSettings(tester);
      await tester.pumpAndSettle();
      final show_photo = find.byKey(const ValueKey(SettingsPageKeys.showPhotoOrStory));
      final Offset widget_position = tester.getTopLeft(show_photo);
      x_coordinate_of_photo = widget_position.dx;
      y_coordinate_of_photo = widget_position.dy;
      await tester.tap(show_photo);
      await tester.pumpAndSettle();
      final back_button = find.byKey(const ValueKey(SettingsPageKeys.backFromViewProfilePicture));
      await tester.tap(back_button);
      await tester.pumpAndSettle();
      expect(find.textContaining('Phone'), findsOneWidget);
    });
    testWidgets('Edit Photo', (WidgetTester tester) async {
      await openEditPage(tester);
      await tester.pumpAndSettle();
      await tester.tapAt(Offset(x_coordinate_of_photo, y_coordinate_of_photo));
      await tester.pumpAndSettle();
      expect(find.textContaining('Take Photo'), findsOneWidget);
      expect(find.textContaining('Select From'), findsOneWidget);
      expect(find.textContaining('Remove'), findsOneWidget);
    });
    testWidgets('Cancel Update', (WidgetTester tester) async {
      await openEditPage(tester);
      await tester.pumpAndSettle();
      throw('Error: Key not found for any Text field so cant edit and cancel');
      final cancel_button = find.byKey(const ValueKey(SettingsPageKeys.cancelButton));
      await tester.tap(cancel_button);
      await tester.pumpAndSettle();
    });
    testWidgets('Save Update', (WidgetTester tester) async {
      await openEditPage(tester);
      await tester.pumpAndSettle();
      throw('Error: Key not found for any Text field so cant edit and save');
      final done_button = find.byKey(const ValueKey(SettingsPageKeys.doneButton));
      await tester.tap(done_button);
      await tester.pumpAndSettle();
    });
    testWidgets('Copy User Data', (WidgetTester tester) async {
      await openSettings(tester);
      await tester.pumpAndSettle();
      final phone_copy = find.textContaining('Phone');
      final email_copy = find.textContaining('Email');
      final username_copy = find.textContaining('Username');
      final bio_copy = find.textContaining('Bio');
      await tester.tap(phone_copy);
      await tester.pumpAndSettle();
      await tester.tap(email_copy);
      await tester.pumpAndSettle();
      await tester.tap(username_copy);
      await tester.pumpAndSettle();
      await tester.tap(bio_copy);
      await tester.pumpAndSettle();
    });
    testWidgets('Add Story From Profile', (WidgetTester tester) async {
      await openSettings(tester);
      await tester.pumpAndSettle();
      final add_story = find.byKey(const ValueKey(SettingsPageKeys.addStoryInProfile));
      await tester.tap(add_story);
      await tester.pumpAndSettle();
      expect(find.textContaining('Camera'), findsOneWidget);
      expect(find.textContaining('Gallery'), findsOneWidget);
    });
    testWidgets('Add Story From Header', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      final add_story_from_header = find.byKey(const ValueKey(MainChatsKeys.addStoryInHeaderButton));
      await tester.tap(add_story_from_header);
      await tester.pumpAndSettle();
      expect(find.textContaining('Camera'), findsOneWidget);
      expect(find.textContaining('Gallery'), findsOneWidget);
    });
    testWidgets('Add Story from Actions', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      final add_story_from_actions = find.byKey(const ValueKey(MainChatsKeys.addStoryInActionsButton));
      await tester.tap(add_story_from_actions);
      await tester.pumpAndSettle();
      expect(find.textContaining('Camera'), findsOneWidget);
      expect(find.textContaining('Gallery'), findsOneWidget);
    });
  });
}