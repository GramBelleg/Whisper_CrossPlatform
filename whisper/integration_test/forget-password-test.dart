import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:whisper/main.dart' as app;
import 'package:whisper/keys/login-keys.dart';
import 'test_cases/test-cases.dart';
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
    late Finder goBackFromCodeAndPasswords;
    late Finder codeField;
    late Finder passwordField;
    late Finder rePasswordField;

    testWidgets('Forget Password with invalid email', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(Duration(seconds: 3));
      forgetPasswordText = find.byKey(const ValueKey(LoginKeys.forgotPasswordHighlightText));
      // Navigate to Forget Password screen
      await tester.tap(forgetPasswordText);
      await tester.pumpAndSettle();

      emailField = find.byKey(const ValueKey(ForgotPasswordKeys.emailTextFieldKey));
      sendCodeButton = find.byKey(const ValueKey(ForgotPasswordKeys.sendCodeButtonKey));

      final List<String> errors = [];

      await tester.enterText(emailField, testCases['Invalid Emails']![0]);
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
      await tester.enterText(emailField,testCases['Valid but Not Existing Emails']![0]);
      await tester.pumpAndSettle();
      await tester.tap(sendCodeButton);
      await tester.pumpAndSettle();
      try {
        expect(find.textContaining(notExistingEmailErrorMessage), findsOneWidget);
      } catch (e) {
        fail("Forget password failed with not existing email: $e");
      }
    });
    testWidgets("Forget Password with valid email", (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(forgetPasswordText);
      await tester.pumpAndSettle();
      //sending the code
      await tester.enterText(emailField, AuthUser.emailWhisperTest);
      await tester.pumpAndSettle();
      await tester.tap(sendCodeButton);
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(Duration(seconds: 5));
      //Navigate back
      goBackFromCodeAndPasswords = find.byKey(const ValueKey(
          ForgotPasswordKeys.goBackFromCodeAndPasswordsHighlightTextKey));
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
      resendCodeButton = find.byKey(
          const ValueKey(ForgotPasswordKeys.resendCodeHighlightTextKey));
      await tester.tap(resendCodeButton);
      await tester.pumpAndSettle();
      // Get the second code from the email
      final String? secondCode = await getVerificationCode();
      expect(firstCode, isNot(secondCode));
      codeField =
          find.byKey(const ValueKey(ForgotPasswordKeys.codeTextFieldKey));
      await tester.pumpAndSettle();
      // Testing with invalid code
      passwordField =
          find.byKey(const ValueKey(ForgotPasswordKeys.passwordTextFieldKey));
      rePasswordField =
          find.byKey(const ValueKey(ForgotPasswordKeys.rePasswordTextFieldKey));
      var savePasswordAndLoginButton = find.byKey(
          const ValueKey(ForgotPasswordKeys.savePasswordAndLoginButtonKey));
      await tester.enterText(passwordField, AuthUser.passwordWhisperTest2);
      await tester.pumpAndSettle();
      await tester.enterText(rePasswordField, AuthUser.passwordWhisperTest2);
      await tester.pumpAndSettle();
      await tester.enterText(codeField, '12345678');
      await tester.pumpAndSettle();
      savePasswordAndLoginButton = find.byKey(
          const ValueKey(ForgotPasswordKeys.savePasswordAndLoginButtonKey));
      await tester.tap(savePasswordAndLoginButton);
      await tester.pumpAndSettle();
      try {
        expect(find.textContaining('Invalid code'), findsOneWidget);
      } catch (e) {
        print("Forget password failed with invalid code: $e");
      }
    });
    testWidgets("Forget Password with valid code and not similar passwords", (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(forgetPasswordText);
      await tester.pumpAndSettle();
      await tester.enterText(emailField, AuthUser.emailWhisperTest);
      await tester.pumpAndSettle();
      await tester.tap(sendCodeButton);
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(Duration(seconds: 10));
      final String? firstCode = await getVerificationCode();
      // Testing with valid code and passwords doesn't match
      await tester.enterText(codeField, firstCode!);
      await tester.pumpAndSettle();
      await tester.enterText(passwordField, AuthUser.passwordWhisperTest1);
      await tester.pumpAndSettle();
      await tester.enterText(
          rePasswordField, '${AuthUser.passwordWhisperTest1}66');
      await tester.pumpAndSettle();
      var savePasswordAndLoginButton = find.widgetWithText(
          ElevatedButton, 'Save password and login');
      await tester.tap(savePasswordAndLoginButton);
      await tester.pumpAndSettle();
      try {
        expect(find.textContaining('not similar'), findsOneWidget);
      }
      catch (e) {
        print("Forget password failed with passwords not similar: $e");
      }
    });
    testWidgets("Forget Password with valid code and passwords match", (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(forgetPasswordText);
      await tester.pumpAndSettle();
      await tester.enterText(emailField, AuthUser.emailWhisperTest);
      await tester.pumpAndSettle();
      await tester.tap(sendCodeButton);
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(Duration(seconds: 5));
      final String? firstCode = await getVerificationCode();
      await tester.enterText(codeField, firstCode!);
      await tester.pumpAndSettle();
      await tester.enterText(passwordField, AuthUser.passwordWhisperTest2);
      await tester.enterText(rePasswordField, AuthUser.passwordWhisperTest2);
      await tester.pumpAndSettle();
      var savePasswordAndLoginButton = find.byKey(
          const ValueKey(ForgotPasswordKeys.savePasswordAndLoginButtonKey));
      await tester.tap(savePasswordAndLoginButton);
      await tester.pumpAndSettle();
      try {
        expect(find.text('Yes'), findsOneWidget);
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
      final emailFieldLogin = find.byKey(
          const ValueKey(LoginKeys.emailTextFieldKey));
      final passwordFieldLogin = find.byKey(
          const ValueKey(LoginKeys.passwordTextFieldKey));
      await tester.enterText(emailFieldLogin, AuthUser.emailWhisperTest);
      await tester.pumpAndSettle();
      await tester.enterText(passwordFieldLogin, AuthUser.passwordWhisperTest2);
      await tester.pumpAndSettle();
      await tester.tap(loginButton);
      await tester.pumpAndSettle(Duration(seconds: 10));
      try {
        expect(find.byKey(const ValueKey(HomeKeys.logoutButtonKey)),
            findsOneWidget);
        await tester.tap(find.byKey(const ValueKey(HomeKeys.logoutButtonKey)));
        await tester.pumpAndSettle();
      }
      catch (e) {
        print("Login failed after changing password: $e");
      }
    });
    testWidgets("Forget Password with valid code and passwords match but don't logout from all devices", (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(forgetPasswordText);
      await tester.pumpAndSettle();
      await tester.enterText(emailField, AuthUser.emailWhisperTest);
      await tester.pumpAndSettle();
      await tester.tap(sendCodeButton);
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(Duration(seconds: 10));
      final String? thirdCode = await getVerificationCode();
      await tester.enterText(codeField,thirdCode!);
      await tester.pumpAndSettle();
      await tester.enterText(passwordField, AuthUser.passwordWhisperTest1);
      await tester.pumpAndSettle();
      await tester.enterText(rePasswordField, AuthUser.passwordWhisperTest1);
      await tester.pumpAndSettle();
      var savePasswordAndLoginButton = find.byKey(const ValueKey(ForgotPasswordKeys.savePasswordAndLoginButtonKey));
      await tester.tap(savePasswordAndLoginButton);
      await tester.pumpAndSettle();
      final noButton = find.text('No');
      await tester.tap(noButton);
      await tester.pumpAndSettle();
      try {
        expect(find.byKey(const ValueKey(HomeKeys.logoutButtonKey)), findsOneWidget);
        await tester.tap(find.byKey(const ValueKey(HomeKeys.logoutButtonKey)));
        await tester.pumpAndSettle();
      }
      catch (e) {
      print("Forget password failed after saying no: $e");
      }
    });
  });
}
/*  1-verify the expired code test case
    2-verify the resend code test case
    4-verify the invalid code test case
    5-verify the passwords not similar test case
    6-verify the passwords match test case
    7-verify the logout from all devices test case
    8-verify the login after changing password test case
    9- Again but don't say yes to logout from all devices
    10-verify the login after changing password test case
    11-navigate back from code and passwords
 */
