import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:whisper/keys/login_keys.dart';
import 'package:whisper/pages/login.dart';

void main() {
  // this test case is to test the login
  // if the user is not already logged in
  testWidgets('Find widget by key', (WidgetTester tester) async {
    final emailFieldKey = LoginKeys.emailTextFieldKey;
    final passwordFieldKey = LoginKeys.passwordTextFieldKey;
    final loginButtonKey = LoginKeys.loginButtonKey;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Login(),
      ),
    ));
    await tester.pumpAndSettle(Duration(seconds: 5));
    expect(find.byKey(Key(emailFieldKey)), findsOneWidget);
    expect(find.byKey(Key(passwordFieldKey)), findsOneWidget);
    expect(find.byKey(Key(loginButtonKey)), findsOneWidget);

    // first scenario : trying to login
    // without writing any email or password
    await tester.tap(find.byKey(Key(loginButtonKey)));
    await tester.pumpAndSettle(Duration(seconds: 5));
    expect(find.text("This field is required"), findsExactly(2));

    // second scenario : trying to login
    // with incorrect email format
    await tester.enterText(
      find.byKey(Key(emailFieldKey)),
      "seifmohamed.com",
    );
    await tester.enterText(
      find.byKey(Key(passwordFieldKey)),
      "12345678",
    );
    await tester.tap(find.byKey(Key(loginButtonKey)));
    await tester.pumpAndSettle(Duration(seconds: 5));
    expect(find.text("Enter a valid email"), findsExactly(1));

    // third scenario : trying to login
    // with a short password
    await tester.enterText(
      find.byKey(Key(emailFieldKey)),
      "seifmohamed@gmail.com",
    );
    await tester.enterText(
      find.byKey(Key(passwordFieldKey)),
      "12348",
    );
    await tester.tap(find.byKey(Key(loginButtonKey)));
    await tester.pumpAndSettle(Duration(seconds: 5));
    expect(
      find.text("Password must be at least 6 characters"),
      findsExactly(1),
    );
  });
}
