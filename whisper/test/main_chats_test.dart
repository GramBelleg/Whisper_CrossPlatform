// import 'package:draggable_home/draggable_home.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:whisper/cubit/chats_cubit.dart';
// import 'package:whisper/cubit/user_story_state.dart';
// import 'package:whisper/keys/main_chats_keys.dart';
// import 'package:whisper/pages/cerate_chats.dart';
// import 'package:whisper/pages/main_chats.dart';
// import 'package:whisper/cubit/user_story_cubit.dart';
// import 'package:whisper/models/chat.dart';
// import 'package:whisper/models/user.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:whisper/pages/my_stories_screen.dart';

// class MockUserStoryCubit extends Mock implements UserStoryCubit {}

// void main() {
//   group('MainChats Widget Tests', () {
//     late MockUserStoryCubit mockUserStoryCubit;

//     setUp(() {
//       mockUserStoryCubit = MockUserStoryCubit();
//     });

//     testWidgets('MainChats widget builds correctly',
//         (WidgetTester tester) async {
//       await tester.pumpWidget(
//         MaterialApp(
//           home: MainChats(),
//         ),
//       );

//       expect(find.text('Chats'), findsOneWidget); // Verify the title
//       expect(
//           find.byType(DraggableHome), findsOneWidget); // Verify DraggableHome
//     });

//     testWidgets('Header widget displays loading state',
//         (WidgetTester tester) async {
//       when(mockUserStoryCubit.state).thenReturn(UserStoryLoading());

//       await tester.pumpWidget(
//         MaterialApp(
//           home: BlocProvider<UserStoryCubit>(
//             create: (_) => mockUserStoryCubit,
//             child: MainChats(),
//           ),
//         ),
//       );

//       expect(find.byType(CircularProgressIndicator), findsOneWidget);
//     });

//     testWidgets('Header widget displays error state',
//         (WidgetTester tester) async {
//       when(mockUserStoryCubit.state)
//           .thenReturn(UserStoryError(message: 'Error loading stories'));

//       await tester.pumpWidget(
//         MaterialApp(
//           home: BlocProvider<UserStoryCubit>(
//             create: (_) => mockUserStoryCubit,
//             child: MainChats(),
//           ),
//         ),
//       );

//       expect(find.text('Error loading stories'), findsOneWidget);
//     });

//     testWidgets('Header widget displays loaded state',
//         (WidgetTester tester) async {
//       final users = [
//         User(id: 1, userName: 'user1', profilePic: 'url1', stories: []),
//         User(id: 2, userName: 'user2', profilePic: 'url2', stories: []),
//       ];
//       final me = User(id: 0, userName: 'me', profilePic: 'me_url', stories: []);

//       when(mockUserStoryCubit.state)
//           .thenReturn(UserStoryLoaded(users: users, me: me));

//       await tester.pumpWidget(
//         MaterialApp(
//           home: BlocProvider<UserStoryCubit>(
//             create: (_) => mockUserStoryCubit,
//             child: MainChats(),
//           ),
//         ),
//       );

//       expect(find.text('My Story'), findsOneWidget);
//       expect(find.text('user1'), findsOneWidget);
//       expect(find.text('user2'), findsOneWidget);
//     });

//     testWidgets('Edit button opens modal sheet', (WidgetTester tester) async {
//       await tester.pumpWidget(
//         MaterialApp(
//           home: MainChats(),
//         ),
//       );

//       final editButton = find.byKey(Key(MainChatsKeys.editButton));
//       expect(editButton, findsOneWidget);

//       await tester.tap(editButton);
//       await tester.pumpAndSettle();

//       expect(find.byType(ModalBottomSheetContent), findsOneWidget);
//     });

//     testWidgets('Tapping a story navigates to ShowMyStories',
//         (WidgetTester tester) async {
//       final me = User(userName: 'me', profilePic: 'me_url', stories: [], id: 0);

//       when(mockUserStoryCubit.state)
//           .thenReturn(UserStoryLoaded(users: [], me: me));

//       await tester.pumpWidget(
//         MaterialApp(
//           home: BlocProvider<UserStoryCubit>(
//             create: (_) => mockUserStoryCubit,
//             child: MainChats(),
//           ),
//         ),
//       );

//       final myStoryKey = find.byKey(Key("me_story"));
//       expect(myStoryKey, findsOneWidget);

//       await tester.tap(myStoryKey);
//       await tester.pumpAndSettle();

//       expect(find.byType(ShowMyStories), findsOneWidget);
//     });

//     testWidgets('Sliding a chat displays actions', (WidgetTester tester) async {
//       final mockChatListCubit = MockChatListCubit();
//       final chat = Chat(userName: 'testChat', type: 'Group', isMuted: false);

//       when(mockChatListCubit.state).thenReturn([chat]);

//       await tester.pumpWidget(
//         MaterialApp(
//           home: BlocProvider<ChatListCubit>(
//             create: (_) => mockChatListCubit,
//             child: MainChats(),
//           ),
//         ),
//       );

//       final chatCard = find.byKey(ValueKey('testChat'));
//       expect(chatCard, findsOneWidget);

//       await tester.drag(chatCard, Offset(-300, 0));
//       await tester.pumpAndSettle();

//       expect(find.text('Mute'), findsOneWidget);
//       expect(find.text('Delete'), findsOneWidget);
//     });
//   });
// }
