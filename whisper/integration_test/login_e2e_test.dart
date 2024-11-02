import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:whisper/main.dart' as app;
import 'package:whisper/keys/login-keys.dart';
import 'package:whisper/keys/home-keys.dart';
import 'package:logger/logger.dart'; // Import logger
import 'utils/test_cases/LoginTestCases.dart';
import 'utils/auth_user.dart';
const String invalidEmailErrorMessage = 'Enter a valid email';
const String emptyField = 'This field is required';
const String notExistingEmailErrorMessage = 'Something went wrong';

void main() {
  final Logger logger = Logger(
    printer: PrettyPrinter(),
  );
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Login E2E Tests', () {
    late Finder emailField;
    late Finder passwordField;
    late Finder loginButton;
    setUp(() async {
      try {
        emailField = find.byKey(const ValueKey(LoginKeys.emailTextFieldKey));
        passwordField = find.byKey(const ValueKey(LoginKeys.passwordTextFieldKey));
        loginButton = find.byKey(const ValueKey(LoginKeys.loginButtonKey));
      } catch (e) {
        logger.e("SETUP FAILED: Can't find fields", e); // Log error
      }
    });

    testWidgets('Login with invalid email and valid password', (WidgetTester tester) async {
      bool testFailed=false;
      app.main();
      await tester.pumpAndSettle();
      await tester.enterText(passwordField, 'ValidPass@@13');
      // Test invalid emails
      for (String testcase in loginTestCases['Invalid Emails']!) {
        await tester.enterText(emailField, testcase);
        await tester.tap(loginButton);
        await tester.pumpAndSettle();
        try {
          expect(find.text(invalidEmailErrorMessage), findsOneWidget);
        } catch (e) {
          logger.e("Test case failed for invalid email: $testcase", e); // Log error
          testFailed=true;
        }
      }
      // Test empty field
      await tester.enterText(emailField, '');
      await tester.tap(loginButton);
      await tester.pumpAndSettle();
      try {
        expect(find.text(emptyField), findsOneWidget);
      } catch (e) {
        logger.e("Test case failed for empty email field", e); // Log error
        testFailed=true;
      }
      if(testFailed) {
        throw Error();
      }
    });

    testWidgets('Login with valid email and invalid password', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      bool testFailed=false;
      await tester.enterText(emailField, AuthUser.email);
      for (String testcase in loginTestCases['Invalid Passwords']!) {
        await tester.enterText(passwordField, testcase);
        await tester.tap(loginButton);
        await tester.pumpAndSettle();
        try {
          expect(find.textContaining('Password must'), findsOneWidget);
        } catch (e) {
          logger.e("Test case failed for invalid password: $testcase", e); // Log error
          testFailed=true;
        }
      }
      // Test empty field
      await tester.enterText(passwordField, '');
      await tester.tap(loginButton);
      await tester.pumpAndSettle();
      try {
        expect(find.text(emptyField), findsOneWidget);
      } catch (e) {
        logger.e("Test case failed for empty password field", e); // Log error
        testFailed=true;
      }
      if(testFailed){
          throw Error();
        }
    });

    testWidgets('Login with valid but non-existing emails and password', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      bool testFailed=false;
      await tester.enterText(passwordField, 'ValidPass@@13');
      for (String testcase in loginTestCases['Valid but Not Existing Emails']!) {
        await tester.enterText(emailField, testcase);
        await tester.tap(loginButton);
        await tester.pumpAndSettle();
        try {
          expect(find.textContaining(notExistingEmailErrorMessage), findsOneWidget);
        } catch (e) {
          logger.e("Test case failed for valid but non-existing email: $testcase", e); // Log error
          testFailed=true;
        }
      }
      if(testFailed){
          throw Error();
        }
    });

    testWidgets('Login with valid email and password', (WidgetTester tester) async {
      app.main();
      bool testFailed=false;
      await tester.pumpAndSettle();
      await tester.enterText(emailField,AuthUser.email);
      await tester.enterText(passwordField, AuthUser.password);
      await tester.tap(loginButton);
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(const Duration(seconds: 15));
      try {
        expect(find.byKey((const ValueKey(HomeKeys.logoutButtonKey))), findsOneWidget);
      } catch (e) {
        logger.e("Login failed", e); // Log error
        testFailed=true;
      }
      if(testFailed){
          throw Error();
        }
    });
  });
}
