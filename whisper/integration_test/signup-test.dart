import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:whisper/main.dart' as app;
import 'package:whisper/keys/login-keys.dart';
import 'package:whisper/keys/home-keys.dart';
import 'test_cases/test-cases.dart';
import 'package:whisper/keys/signup-keys.dart';
import 'utils/auth-user.dart';
import 'utils/test-common-functions.dart';
const String emptyField = 'Form is invalid';
const String invalidUsernameErrorMessage = 'Form is invalid';
const String invalidNameErrorMessage = 'Form is invalid';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('Sign up E2E tests', ()
  {
    late Finder emailFieldLogin;
    late Finder passwordFieldLogin;
    late Finder loginButtonLogin;
    late Finder signUpButtonLogin;
    late Finder emailFieldSignUp;
    late Finder usernameFieldSignUp;
    late Finder nameFieldSignUp;
    late Finder passwordFieldSignUp;
    late Finder rePasswordFieldSignUp;
    late Finder phoneNumber;
    late Finder signUpButtonSignUp;
    late Finder loginButtonSignUp;
    late Finder goBackFromRecaptcha;
    late Finder goBackFromCode;
    late Finder codeField;
    late Finder submitCodeButton;
    late Finder resendCode;
    testWidgets(
        'Initialization and Ensuring routing from signup page to login page', (
        WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      emailFieldLogin = find.byKey(const ValueKey(LoginKeys.emailTextFieldKey));
      passwordFieldLogin =
          find.byKey(const ValueKey(LoginKeys.passwordTextFieldKey));
      loginButtonLogin = find.byKey(const ValueKey(LoginKeys.loginButtonKey));
      signUpButtonLogin =
          find.byKey(const ValueKey(LoginKeys.registerHighLightTextKey));
      await tester.tap(signUpButtonLogin);
      await tester.pumpAndSettle();
      emailFieldSignUp =
          find.byKey(const ValueKey(SignupKeys.emailTextFieldKey));
      usernameFieldSignUp =
          find.byKey(const ValueKey(SignupKeys.usernameTextFieldKey));
      nameFieldSignUp = find.byKey(const ValueKey(SignupKeys.nameTextFieldKey));
      passwordFieldSignUp =
          find.byKey(const ValueKey(SignupKeys.passwordTextFieldKey));
      rePasswordFieldSignUp =
          find.byKey(const ValueKey(SignupKeys.rePasswordTextFieldKey));
      phoneNumber = find.byKey(const ValueKey(SignupKeys.phoneNumberFieldKey));
      loginButtonSignUp =
          find.byKey(const ValueKey(SignupKeys.goBackToLoginHighlightTextKey));
      signUpButtonSignUp =
          find.byKey(const ValueKey(SignupKeys.goToRecaptchaButtonKey));
      await tester.tap(loginButtonSignUp);
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey(LoginKeys.emailTextFieldKey)),
          findsOneWidget);
    });
    testWidgets(
        'Ensure name testcases are covered', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      final List<String> errors = [];
      await tester.tap(signUpButtonLogin);
      await tester.pumpAndSettle();
      await tester.enterText(emailFieldSignUp, AuthUser.emailWhisperTest);
      await tester.pumpAndSettle();
      await tester.enterText(usernameFieldSignUp, 'testusername');
      await tester.pumpAndSettle();
      await tester.enterText(
          passwordFieldSignUp, AuthUser.passwordWhisperTest1);
      await tester.pumpAndSettle();
      await tester.enterText(
          rePasswordFieldSignUp, AuthUser.passwordWhisperTest1);
      await tester.pumpAndSettle();
      await tester.enterText(phoneNumber, '1234567890');
      await tester.pumpAndSettle();
      for (String testcase in testCases['Invalid Names']!) {
        await tester.tap(nameFieldSignUp);
        await tester.pumpAndSettle();
        await tester.enterText(nameFieldSignUp, testcase);
        await tester.pumpAndSettle();
        await tester.tap(rePasswordFieldSignUp);
        await tester.pumpAndSettle();
        await tester.tap(phoneNumber);
        await tester.pumpAndSettle();
        await tester.tap(signUpButtonSignUp);
        await tester.pumpAndSettle();
        try {
          expect(find.textContaining(invalidNameErrorMessage), findsOneWidget);
        } catch (e) {
          await tester.pumpAndSettle(Duration(seconds: 5));
          goBackFromRecaptcha = find.byKey(
              const ValueKey(SignupKeys.goBackFromRecaptchaHighlightTextKey));
          await tester.tap(goBackFromRecaptcha);
          errors.add("Test case failed for invalid name: '$testcase'");
        }
      }
      //try empty
      await tester.enterText(nameFieldSignUp, '');
      await tester.pumpAndSettle();
      await tester.tap(rePasswordFieldSignUp);
      await tester.pumpAndSettle();
      await tester.tap(phoneNumber);
      await tester.pumpAndSettle();
      await tester.tap(signUpButtonSignUp);
      await tester.pumpAndSettle();
      try {
        expect(find.text(emptyField), findsOneWidget);
      } catch (e) {
        errors.add("Test case failed for empty name field - ");
      }
      if (errors.isNotEmpty) {
        fail(errors.join('\n'));
      }
    });
    testWidgets(
        'Ensure username testcases are covered', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      final List<String> errors = [];
      await tester.tap(signUpButtonLogin);
      await tester.pumpAndSettle();
      await tester.enterText(emailFieldSignUp, AuthUser.emailWhisperTest);
      await tester.pumpAndSettle();
      await tester.enterText(nameFieldSignUp, 'John Doe');
      await tester.pumpAndSettle();
      await tester.enterText(
          passwordFieldSignUp, AuthUser.passwordWhisperTest1);
      await tester.pumpAndSettle();
      await tester.enterText(
          rePasswordFieldSignUp, AuthUser.passwordWhisperTest1);
      await tester.pumpAndSettle();
      await tester.enterText(phoneNumber, '1234567890');
      await tester.pumpAndSettle();
      for (String testcase in testCases['Invalid Usernames']!) {
        await tester.enterText(usernameFieldSignUp, testcase);
        await tester.pumpAndSettle();
        await tester.tap(rePasswordFieldSignUp);
        await tester.pumpAndSettle();
        await tester.tap(phoneNumber);
        await tester.pumpAndSettle();
        await tester.tap(signUpButtonSignUp);
        await tester.pumpAndSettle();
        try {
          expect(
              find.textContaining(invalidUsernameErrorMessage), findsOneWidget);
        } catch (e) {
          await tester.pumpAndSettle(Duration(seconds: 5));
          goBackFromRecaptcha = find.byKey(
              const ValueKey(SignupKeys.goBackFromRecaptchaHighlightTextKey));
          await tester.tap(goBackFromRecaptcha);
          errors.add("Test case failed for invalid username: '$testcase'");
        }
      }
      //try empty
      await tester.enterText(usernameFieldSignUp, '');
      await tester.pumpAndSettle();
      await tester.tap(rePasswordFieldSignUp);
      await tester.pumpAndSettle();
      await tester.tap(phoneNumber);
      await tester.pumpAndSettle();
      await tester.tap(signUpButtonSignUp);
      await tester.pumpAndSettle();
      try {
        expect(find.text(emptyField), findsOneWidget);
      } catch (e) {
        errors.add("Test case failed for empty username field");
      }
      if (errors.isNotEmpty) {
        fail(errors.join('\n'));
      }
    });
    testWidgets('Test Phone Number', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      final List<String> errors = [];
      await tester.tap(signUpButtonLogin);
      await tester.pumpAndSettle();
      await tester.enterText(emailFieldSignUp, AuthUser.emailWhisperTest);
      await tester.pumpAndSettle();
      await tester.enterText(nameFieldSignUp, 'John Doe');
      await tester.pumpAndSettle();
      await tester.enterText(usernameFieldSignUp, 'testusername');
      await tester.pumpAndSettle();
      await tester.enterText(
          passwordFieldSignUp, AuthUser.passwordWhisperTest1);
      await tester.pumpAndSettle();
      await tester.enterText(
          rePasswordFieldSignUp, AuthUser.passwordWhisperTest1);
      await tester.pumpAndSettle();
      await tester.enterText(phoneNumber, '1234567');
      await tester.pumpAndSettle();
      await tester.tap(signUpButtonSignUp);
      await tester.pumpAndSettle();
      try {
        expect(find.textContaining('Form is invalid'), findsOneWidget);
      } catch (e) {
        errors.add("Test case failed for invalid phone number - ");
      }
      //try empty
      await tester.enterText(phoneNumber, '');
      await tester.pumpAndSettle();
      await tester.tap(signUpButtonSignUp);
      await tester.pumpAndSettle();
      try {
        expect(find.text(emptyField), findsOneWidget);
      } catch (e) {
        errors.add("Test case failed for empty phone number field - ");
      }
      if (errors.isNotEmpty) {
        fail(errors.join('\n'));
      }
    });
    // testWidgets('Sign up with valid credentials', (WidgetTester tester) async {
    //   app.main();
    //   await tester.pumpAndSettle();
    //   await tester.tap(signUpButtonLogin);
    //   await tester.pumpAndSettle();
    //   await tester.enterText(emailFieldSignUp, AuthUser.emailWhisperTest);
    //   await tester.enterText(nameFieldSignUp, 'John Doe');
    //   await tester.enterText(usernameFieldSignUp, 'test username');
    //   await tester.enterText(
    //       passwordFieldSignUp, AuthUser.passwordWhisperTest1);
    //   await tester.enterText(
    //       rePasswordFieldSignUp, AuthUser.passwordWhisperTest1);
    //   FocusManager.instance.primaryFocus?.unfocus();
    //   await tester.pumpAndSettle(Duration(seconds: 1));
    //   await tester.enterText(phoneNumber, '1234567890');
    //   FocusManager.instance.primaryFocus?.unfocus();
    //   await tester.pumpAndSettle(Duration(seconds: 1));
    //   await tester.tap(signUpButtonSignUp);
    //   await tester.pumpAndSettle();
    //   goBackFromRecaptcha = find.byKey(
    //       const ValueKey(SignupKeys.goBackFromRecaptchaHighlightTextKey));
    //   await tester.tap(goBackFromRecaptcha);
    //   await tester.pumpAndSettle();
    //   await tester.tap(signUpButtonSignUp);
    //   await tester.pumpAndSettle();
    //   print('Please solve the CAPTCHA manually. Type "Y" then press Enter when done.');
    //   while (stdin.readLineSync()?.toUpperCase() != 'Y') {
    //     print('Invalid input. Type "Y" and press Enter once CAPTCHA is solved.');
    //   }
    //   goBackFromCode =
    //       find.byKey(const ValueKey(SignupKeys.goBackFromSubmittingCodeKey));
    //   await tester.tap(goBackFromCode);
    //   await tester.pumpAndSettle();
    //   await tester.tap(signUpButtonSignUp);
    //   await tester.pumpAndSettle();
    //   print('Please solve the CAPTCHA manually. Type "Y" then press Enter when done.');
    //   while (stdin.readLineSync()?.toUpperCase() != 'Y') {
    //     print('Invalid input. Type "Y" and press Enter once CAPTCHA is solved.');
    //   }
    //   codeField = find.byKey(const ValueKey(SignupKeys.codeTextFieldKey));
    //   submitCodeButton =
    //       find.byKey(const ValueKey(SignupKeys.submitCodeButtonKey));
    //   resendCode =
    //       find.byKey(const ValueKey(SignupKeys.resendCodeHighlightTextKey));
    //   await tester.tap(resendCode);
    //   await tester.pumpAndSettle();
    //   var code = await getVerificationCode();
    //   await tester.enterText(codeField, code!);
    //   await tester.tap(submitCodeButton);
    //   await tester.pumpAndSettle();
    //   expect(
    //       find.byKey(const ValueKey(HomeKeys.logoutButtonKey)), findsOneWidget);
    // });
    // testWidgets('Ensure uniqueness of email', (WidgetTester tester) async {
    //   app.main();
    //   await tester.pumpAndSettle();
    //   await tester.tap(signUpButtonLogin);
    //   await tester.pumpAndSettle();
    //   await tester.enterText(emailFieldSignUp, AuthUser.emailWhisperTest);
    //   await tester.enterText(nameFieldSignUp, 'John Doe');
    //   await tester.enterText(usernameFieldSignUp, 'testusername2');
    //   await tester.enterText(
    //       passwordFieldSignUp, AuthUser.passwordWhisperTest1);
    //   await tester.enterText(
    //       rePasswordFieldSignUp, AuthUser.passwordWhisperTest1);
    //   FocusManager.instance.primaryFocus?.unfocus();
    //   await tester.pumpAndSettle(Duration(seconds: 1));
    //   await tester.enterText(phoneNumber, '1224567890');
    //   FocusManager.instance.primaryFocus?.unfocus();
    //   await tester.pumpAndSettle(Duration(seconds: 1));
    //   await tester.tap(signUpButtonSignUp);
    //   await tester.pumpAndSettle();
    //   try {
    //     await waitUntilVisible(tester, 'Email is already found in DB');
    //   } catch (e) {
    //     fail("Test case failed for email already found in DB - ");
    //   }
    // });
    // testWidgets('Ensure i can login with the new user created', (WidgetTester tester) async {
    //   app.main();
    //   await tester.pumpAndSettle();
    //   await tester.enterText(emailFieldLogin, AuthUser.emailWhisperTest);
    //   await tester.enterText(passwordFieldLogin, AuthUser.passwordWhisperTest1);
    //   await tester.tap(loginButtonLogin);
    //   await tester.pumpAndSettle();
    //   expect(find.byKey(const ValueKey(HomeKeys.logoutButtonKey)), findsOneWidget);
    // });
  });
}
/*
1-test routing from signup page to login page
2- ensure testcases in the file test-cases.dart are implemented
3- test phone number
4- go back from recaptcha page go back in,test the resend code button
5- ensure uniqueness of username and email
6 - try login with the new user
* */