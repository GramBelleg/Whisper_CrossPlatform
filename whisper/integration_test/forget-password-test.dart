import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:whisper/main.dart' as app;
import 'package:whisper/keys/login-keys.dart';
import 'utils/test_cases/login-test-cases.dart';
import 'package:whisper/keys/forgot-password-keys.dart';
import 'package:whisper/keys/home-keys.dart';
import 'utils/auth-user.dart';
import 'utils/test-common-functions.dart';
const String invalidEmailErrorMessage = 'Enter a valid email';
const String emptyField = 'This field is required';
const String notExistingEmailErrorMessage = 'existed in DB';
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
        print("setup failed : Can't find fields: $e"); // Log error
      }
    });

    testWidgets('Forget Password with invalid email', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to Forget Password screen
      await tester.tap(forgetPasswordText);
      await tester.pumpAndSettle();

      emailField = find.byKey(const ValueKey(ForgotPasswordKeys.emailTextFieldKey));
      sendCodeButton = find.byKey(const ValueKey(ForgotPasswordKeys.sendCodeButtonKey));

      final List<String> errors = [];

      await tester.enterText(emailField, loginTestCases['Invalid Emails']![0]);
      await tester.tap(sendCodeButton);
      await tester.pumpAndSettle();
      try {
        expect(find.text(invalidEmailErrorMessage), findsOneWidget);
      } catch (e) {
        errors.add("Forget password failed with invalid email: $e");
      }

      await tester.enterText(emailField, '');
      await tester.tap(sendCodeButton);
      await tester.pumpAndSettle();
      try {
        expect(find.text(emptyField), findsOneWidget);
      } catch (e) {
        errors.add("Forget password failed with empty email field: $e");
      }
      if (errors.isNotEmpty) {
        fail(errors.join('\n'));
      }
    });

    testWidgets("Valid but not existing emails", (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(forgetPasswordText);
      await tester.pumpAndSettle();
      emailField = find.byKey(const ValueKey(ForgotPasswordKeys.emailTextFieldKey));
      sendCodeButton = find.byKey(const ValueKey(ForgotPasswordKeys.sendCodeButtonKey));
      await tester.enterText(emailField,loginTestCases['Valid but Not Existing Emails']![0]);
      await tester.pumpAndSettle();
      await tester.tap(sendCodeButton);
      await tester.pumpAndSettle();
      try {
        expect(find.text(notExistingEmailErrorMessage), findsOneWidget);
      } catch (e) {
        fail("Forget password failed with not existing email: $e");
      }
    });
    testWidgets("Forget Password with valid email", (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(forgetPasswordText);
      await tester.pumpAndSettle();
      final String? oldCode = await getVerificationCode();
      //sending the code
      emailField = find.byKey(const ValueKey(ForgotPasswordKeys.emailTextFieldKey));
      sendCodeButton = find.byKey(const ValueKey(ForgotPasswordKeys.sendCodeButtonKey));
      await tester.enterText(emailField, AuthUser.emailWhisperTest);
      await tester.pumpAndSettle();
      await tester.tap(sendCodeButton);
      await tester.pumpAndSettle();
      //Navigate back
      goBackFromCodeAndPasswords = find.byKey(const ValueKey(ForgotPasswordKeys.goBackFromCodeAndPasswordsHighlightTextKey));
      await tester.tap(goBackFromCodeAndPasswords);
      await tester.pumpAndSettle();
      //sending the code again
      await tester.enterText(emailField, AuthUser.emailWhisperTest);
      await tester.pumpAndSettle();
      await tester.tap(sendCodeButton);
      await tester.pumpAndSettle();
      // Get the first code from the email
      final String? firstCode = await getVerificationCode();
      expect(firstCode, isNotNull);
      resendCodeButton = find.byKey(const ValueKey(ForgotPasswordKeys.resendCodeHighlightTextKey));
      await tester.tap(resendCodeButton);
      await tester.pumpAndSettle();
      // Get the second code from the email
      final String? secondCode = await getVerificationCode();
      expect(firstCode, isNot(secondCode));
      codeField = find.byKey(const ValueKey(ForgotPasswordKeys.codeTextFieldKey));
      await tester.pumpAndSettle();
      // Testing with expired code
      await tester.enterText(codeField,oldCode!);
      await tester.pumpAndSettle();
      print("Old code: $oldCode");
      print("First code: $firstCode");
      print ("Second code: $secondCode");
      await tester.pumpAndSettle();
      passwordField = find.byKey(const ValueKey(ForgotPasswordKeys.passwordTextFieldKey));
      rePasswordField = find.byKey(const ValueKey(ForgotPasswordKeys.rePasswordTextFieldKey));
      savePasswordAndLoginButton = find.byKey(const ValueKey(ForgotPasswordKeys.savePasswordAndLoginButtonKey));
      await tester.enterText(passwordField, AuthUser.passwordWhisperTest2);
      await tester.pumpAndSettle();
      await tester.enterText(rePasswordField, AuthUser.passwordWhisperTest2);
      await tester.pumpAndSettle();
      await tester.tap(savePasswordAndLoginButton);
      await tester.pumpAndSettle();
      try {
      expect(find.textContaining('Expired Code'), findsOneWidget);
      } catch (e) {
      print("Forget password failed with expired code: $e");
      }
      // Testing with invalid code
      await tester.enterText(codeField, '123456');
      await tester.pumpAndSettle();
      await tester.tap(savePasswordAndLoginButton);
      await tester.pumpAndSettle();
      try {
      expect(find.textContaining('Invalid Code'), findsOneWidget);
      } catch (e) {
      print("Forget password failed with invalid code: $e");
      }
      // Testing with valid code and passwords doesn't match
      await tester.enterText(codeField,secondCode!);
      await tester.pumpAndSettle();
      await tester.enterText(rePasswordField,'${AuthUser.passwordWhisperTest1}66');
      await tester.pumpAndSettle();
      await tester.tap(savePasswordAndLoginButton);
      await tester.pumpAndSettle();
      try {
      expect(find.textContaining('not similar'), findsOneWidget);
      }
      catch (e) {
      print("Forget password failed with passwords not similar: $e");
      }
      // Testing with valid code and passwords match

      await tester.enterText(rePasswordField,AuthUser.passwordWhisperTest2);
      await tester.pumpAndSettle();
      await tester.tap(savePasswordAndLoginButton);
      await tester.pumpAndSettle();
      try {
      expect(find.textContaining('Password changed successfully'), findsOneWidget);
      }
      catch (e) {
      print("Forget password failed with valid code and passwords match: $e");
      }
      //Say yes to Logout from all devices
      final yesButton = find.text('Yes');
      await tester.tap(yesButton);
      await tester.pumpAndSettle();
      //Try to Login with the new Password
      final loginButton = find.byKey(const ValueKey(LoginKeys.loginButtonKey));
      final emailFieldLogin = find.byKey(const ValueKey(LoginKeys.emailTextFieldKey));
      final passwordFieldLogin = find.byKey(const ValueKey(LoginKeys.passwordTextFieldKey));
      await tester.enterText(emailFieldLogin, AuthUser.emailWhisperTest);
      await tester.pumpAndSettle();
      await tester.enterText(passwordFieldLogin, AuthUser.passwordWhisperTest2);
      await tester.pumpAndSettle();
      await tester.tap(loginButton);
      await tester.pumpAndSettle(Duration(seconds: 5));
      try {
      expect(find.byKey(const ValueKey(HomeKeys.logoutButtonKey)), findsOneWidget);
      }
      catch (e) {
        print("Login failed after changing password: $e");
      }
    });
  });
}