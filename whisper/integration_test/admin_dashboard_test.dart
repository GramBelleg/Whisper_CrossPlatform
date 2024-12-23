import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:whisper/main.dart' as app;
import 'package:whisper/keys/admin_dash_board_keys.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('Admin DashBoard E2E Tests', ()
  {
    testWidgets('Toggle Between Users And Groups', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      expect(find.textContaining('Users List'), findsOne);
      expect(find.textContaining('Unbanned Users'), findsOne);
      final toggle_button = find.byKey(const ValueKey(AdminDashboardKeys.toggleUsersGroupsButton));
      await tester.tap(toggle_button);
      await tester.pumpAndSettle();
      expect(find.textContaining('Groups List'), findsOne);
      expect(find.textContaining('Unfiltered Groups'), findsOne);
      expect(find.textContaining('Filtered Groups'), findsOne);
      await tester.tap(toggle_button);
      await tester.pumpAndSettle();
      expect(find.textContaining('Users List'), findsOne);
      expect(find.textContaining('Unbanned Users'), findsOne);
    });
    testWidgets('Ban User', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      final banButtonFinder = find.byKey(Key(AdminDashboardKeys.banButton)).first;
      final userTile = find.ancestor(of: banButtonFinder, matching: find.byType(ListTile)).first;
      final userNameText = tester.widget<Text>(find.descendant(of: userTile, matching: find.byType(Text)).first);
      final userName = userNameText.data;
      await tester.tap(banButtonFinder);
      await tester.pumpAndSettle();
      expect(find.text(userName!), findsNothing);
    });
    testWidgets('Filter Group', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      //go to groups
      final toggle_button = find.byKey(const ValueKey(AdminDashboardKeys.toggleUsersGroupsButton));
      await tester.tap(toggle_button);
      await tester.pumpAndSettle();
      final filterButtonFinder = find.byKey(Key(AdminDashboardKeys.filterButton)).first;
      //tap on filter
      await tester.tap(filterButtonFinder);
      await tester.pumpAndSettle();
      //unfilter
      await tester.tap(find.byKey(Key(AdminDashboardKeys.unfilterButton)));
      await tester.pumpAndSettle();
      //filter
      await tester.tap(filterButtonFinder);
      await tester.pumpAndSettle();
    });
  });
}