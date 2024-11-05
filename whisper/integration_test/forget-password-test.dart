import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:whisper/main.dart' as app;
import 'package:whisper/keys/login-keys.dart';
import 'utils/test_cases/login-test-cases.dart';
import 'package:whisper/keys/home-keys.dart';
import 'package:whisper/keys/forgot-password-keys.dart';
import 'utils/auth-user.dart';
const String invalidEmailErrorMessage = 'Enter a valid email';
const String emptyField = 'This field is required';
const String notExistingEmailErrorMessage = 'existed in DB';
/*
* class ForgotPasswordKeys {
  static const String emailTextFieldKey = 'emailTextFieldKeyForgotPassword';
  static const String sendCodeButtonKey = 'sendCodeButtonForgotPassword';
  static const String goBackFromForgotPasswordHighlightTextKey =
      'goBackFomForgotPassword';
  static const String resendCodeHighlightTextKey = 'resendCodeForgotPassword';
  static const String savePasswordAndLoginButtonKey = 'savePasswordAndLoginKey';
  static const String codeTextFieldKey = 'codeTextFieldForgotPassword';
  static const String passwordTextFieldKey = 'passwordTextFieldForgotPassword';
  static const String rePasswordTextFieldKey =
      'rePasswordTextFieldForgotPassword';
  static const String goBackFromCodeAndPasswordsHighlightTextKey =
      'goBackFromCodeAndPasswordsHighlightText';
}*/
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('Forget Password E2E Tests', () {
    late Finder forgetPasswordText;
    late Finder emailField;
    late Finder sendCodeButton;
    late Finder resendCodeButton;
    late Finder savePasswordAndLoginButton;
    late Finder codeField;
    late Finder passwordField;
    late Finder rePasswordField;
    late Finder goBackFromCodeAndPasswords;
    setUp(() async {
      try {
        forgetPasswordText = find.byKey(const ValueKey(LoginKeys.forgotPasswordHighlightText));
      } catch (e) {
        print("SETUP FAILED: Can't find fields: $e"); // Log error
      }
    });

    testWidgets('Forget Password with invalid email', (WidgetTester tester) async {
      bool testFailed=false;
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(forgetPasswordText);
      await tester.pumpAndSettle();
      emailField = find.byKey(const ValueKey(ForgotPasswordKeys.emailTextFieldKey));
      sendCodeButton = find.byKey(const ValueKey(ForgotPasswordKeys.sendCodeButtonKey));
      // Test invalid emails
      for (String testcase in loginTestCases['Invalid Emails']!) {
        await tester.enterText(emailField, testcase);
        await tester.tap(sendCodeButton);
        await tester.pumpAndSettle();
        try {
          expect(find.text(invalidEmailErrorMessage), findsOneWidget);
        } catch (e) {
          print("Test case failed for invalid email input in send code page: $testcase: $e"); // Log error
          testFailed=true;
        }
      }
      // Test empty field
      await tester.enterText(emailField, '');
      await tester.tap(sendCodeButton);
      await tester.pumpAndSettle();
      try {
        expect(find.text(emptyField), findsOneWidget);
      } catch (e) {
        print("Forget password Failed with empty email field: $e"); // Log error
        testFailed=true;
      }
      if(testFailed) {
        print("Forget password with invalid email failed");
      }
    });
    testWidgets("Valid but not existing emails", (WidgetTester tester) async {
      bool testFailed=false;
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(forgetPasswordText);
      await tester.pumpAndSettle();
      emailField = find.byKey(const ValueKey(ForgotPasswordKeys.emailTextFieldKey));
      sendCodeButton = find.byKey(const ValueKey(ForgotPasswordKeys.sendCodeButtonKey));
      for (String testcase in loginTestCases['Valid but Not Existing Emails']!) {
        await tester.enterText(emailField, testcase);
        await tester.tap(sendCodeButton);
        await tester.pumpAndSettle();
        try {
          expect(find.text(notExistingEmailErrorMessage), findsOneWidget);
        } catch (e) {
          print(
              "Test case failed for not existing email input in send code page: $e"); // Log error
          testFailed = true;
        }
      }
      if(testFailed) {
        print("Forget password with not existing email failed");
      }
    });
  });
}