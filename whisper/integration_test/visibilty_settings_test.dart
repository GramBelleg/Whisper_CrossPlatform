import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:whisper/keys/login_keys.dart';
import 'package:whisper/main.dart' as app;
import 'utils/auth_user.dart';
import 'package:whisper/keys/visibility_settings_keys.dart';
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Profile and Settings E2E Tests', () {
    late Finder email_field;
    late Finder password_field;
    late Finder login_button;
    late Finder settings_option;
    late Finder blocked_users_button;
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

    testWidgets('Verify profile information and navigation to settings', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(Duration(seconds: 2));
      // Locate elements
      settings_option = find.byKey(const ValueKey('SettingsPageKey'));
      await tester.tap(settings_option);
      await tester.pumpAndSettle(Duration(seconds: 2));


      // Verify existence of profile information
      final nameText = find.textContaining(AuthUser.whisper_name);
      final phoneNumberText = find.textContaining(AuthUser.whisper_phone_number);
      final bioText = find.textContaining(AuthUser.whisper_bio);
      final emailText = find.textContaining(AuthUser.email_whisper_test);
      final usernameText = find.textContaining(AuthUser.email_whisper_username);

      expect(nameText, findsOneWidget);
      expect(phoneNumberText, findsOneWidget);
      expect(bioText, findsOneWidget);
      expect(emailText, findsOneWidget);
      expect(usernameText, findsOneWidget);
      //tap on each one
      await tester.pumpAndSettle(Duration(seconds: 2));
      await tester.tap(phoneNumberText);
      await tester.pumpAndSettle(Duration(seconds: 2));
      await tester.tap(bioText);
      await tester.pumpAndSettle(Duration(seconds: 2));
      await tester.tap(emailText);
      await tester.pumpAndSettle(Duration(seconds: 2));
      await tester.tap(usernameText);
      await tester.pumpAndSettle(Duration(seconds: 2));
    });
    Future<void> navigateToVisibilitySettings(WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(Duration(seconds: 2));

      // Locate and tap the Settings option
      final settingsOption = find.byKey(const ValueKey('SettingsPageKey'));
      await tester.tap(settingsOption);
      await tester.pumpAndSettle(Duration(seconds: 2));

      // Scroll to the Visibility Settings button
      await tester.drag(find.byType(Scrollable), const Offset(0, -800));
      await tester.pumpAndSettle(Duration(seconds: 2));

      // Tap on Visibility Settings
      final visibilitySettingsButton = find.textContaining('Visibility Settings');
      await tester.tap(visibilitySettingsButton);
      await tester.pumpAndSettle();
    }

    Future<void> selectOption(WidgetTester tester, Finder tile, Key optionKey) async {
      await tester.tap(tile);
      await tester.pumpAndSettle();

      final radio = find.byKey(optionKey);
      await tester.tap(radio);
      await tester.pumpAndSettle();

      final centerTopPosition = Offset(
        tester.binding.window.physicalSize.width / 2,
        0,
      );
      await tester.tapAt(centerTopPosition); // Clear focus
      await tester.pumpAndSettle();
    }


    testWidgets('Set Stories to Everyone', (WidgetTester tester) async {
      await navigateToVisibilitySettings(tester);
      await selectOption(tester, find.byKey(VisibilitySettingsKeys.storiesTile), VisibilitySettingsKeys.everyoneRadio);
    });

    testWidgets('Set Profile Picture to Everyone', (WidgetTester tester) async {
      await navigateToVisibilitySettings(tester);
      await selectOption(tester, find.byKey(VisibilitySettingsKeys.profilePictureTile), VisibilitySettingsKeys.everyoneRadio);
    });

    testWidgets('Set Last Seen to Everyone', (WidgetTester tester) async {
      await navigateToVisibilitySettings(tester);
      await selectOption(tester, find.byKey(VisibilitySettingsKeys.lastSeenTile), VisibilitySettingsKeys.everyoneRadio);
    });

    testWidgets('Set Stories to Contacts', (WidgetTester tester) async {
      await navigateToVisibilitySettings(tester);
      await selectOption(tester, find.byKey(VisibilitySettingsKeys.storiesTile), VisibilitySettingsKeys.contactsRadio);
    });

    testWidgets('Set Profile Picture to Contacts', (WidgetTester tester) async {
      await navigateToVisibilitySettings(tester);
      await selectOption(tester, find.byKey(VisibilitySettingsKeys.profilePictureTile), VisibilitySettingsKeys.contactsRadio);
    });

    testWidgets('Set Last Seen to Contacts', (WidgetTester tester) async {
      await navigateToVisibilitySettings(tester);
      await selectOption(tester, find.byKey(VisibilitySettingsKeys.lastSeenTile), VisibilitySettingsKeys.contactsRadio);
    });

    testWidgets('Set Stories to Nobody', (WidgetTester tester) async {
      await navigateToVisibilitySettings(tester);
      await selectOption(tester, find.byKey(VisibilitySettingsKeys.storiesTile), VisibilitySettingsKeys.nobodyRadio);
    });

    testWidgets('Set Profile Picture to Nobody', (WidgetTester tester) async {
      await navigateToVisibilitySettings(tester);
      await selectOption(tester, find.byKey(VisibilitySettingsKeys.profilePictureTile), VisibilitySettingsKeys.nobodyRadio);
    });

    testWidgets('Set Last Seen to Nobody', (WidgetTester tester) async {
      await navigateToVisibilitySettings(tester);
      await selectOption(tester, find.byKey(VisibilitySettingsKeys.lastSeenTile), VisibilitySettingsKeys.nobodyRadio);
    });
    testWidgets('Switch Read Receipts', (WidgetTester tester) async {
      await navigateToVisibilitySettings(tester);
      final readReceiptsSwitch = find.byKey(VisibilitySettingsKeys.readReceiptsSwitch);
      await tester.tap(readReceiptsSwitch);
      await tester.pumpAndSettle();
    });
    testWidgets('Test Blocked Users', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(Duration(seconds: 2));
      // Locate elements
      settings_option = find.byKey(const ValueKey('SettingsPageKey'));
      await tester.tap(settings_option);
      await tester.pumpAndSettle();
      await tester.drag(
        find.byType(Scrollable),
        const Offset(0, -1000),
      );
      await tester.pumpAndSettle(Duration(seconds: 2));
      blocked_users_button = find.textContaining('Blocked Users');
      await tester.tap(blocked_users_button);
      await tester.pumpAndSettle();
      for(int i = 0; i < 3; i++){
        await tester.tap(find.byKey(const ValueKey('UnblockButton_0')));
        await tester.pumpAndSettle(Duration(seconds: 1));
      }
      expect(find.textContaining('You have no blocked users'), findsOneWidget);
    });
  });
}