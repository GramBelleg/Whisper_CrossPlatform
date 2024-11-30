/*
Hello dear friend
run this first
flutter pub run build_runner build --delete-conflicting-outputs

*/

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:whisper/services/visibility_service.dart';
import 'package:whisper/cubit/visibility_cubit.dart';

// if this import is missing, run 'flutter pub run build_runner build'
import 'visibility_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<VisibilityService>()])
void main() {
  late MockVisibilityService mockVisibilityService;
  late VisibilityCubit visibilityCubit;
  Map<String, dynamic> initSettings = {};

  setUp(() {
    mockVisibilityService = MockVisibilityService();
    visibilityCubit = VisibilityCubit(mockVisibilityService);
    initSettings = {
      "readReceipts": true,
      "storyPrivacy": "Everyone",
      "pfpPrivacy": "Everyone",
      "lastSeenPrivacy": "Everyone"
    };
  });

  tearDown(() {
    visibilityCubit.close();
  });

  group('VisibilityCubit Tests', () {
    test('Initial state is an empty map', () {
      expect(visibilityCubit.state, {});
    });

    test('loadVisibilitySettings emits correct state on success', () async {

      // Define behavior of mocked method
      when(mockVisibilityService.getVisibilitySettings())
          .thenAnswer((_) async => initSettings);

      await visibilityCubit.loadVisibilitySettings();

      // Verify the Cubit state was updated
      expect(visibilityCubit.state, initSettings);
    });

    test(
        'updateProfilePictureVisibility calls updateVisibilitySetting and updates state',
        () async {
      when(mockVisibilityService.getVisibilitySettings())
          .thenAnswer((_) async => initSettings);

      when(mockVisibilityService.updateVisibilitySetting(any, any))
          .thenAnswer((_) async {
        initSettings['pfpPrivacy'] = 'nobody';
      });

      await visibilityCubit.loadVisibilitySettings();

      await visibilityCubit.updateProfilePictureVisibility('nobody');

      verify(mockVisibilityService.updateVisibilitySetting('pfp', 'nobody'))
          .called(1);

      expect(visibilityCubit.state, {
        "readReceipts": true,
        "storyPrivacy": "Everyone",
        "pfpPrivacy": "nobody",
        "lastSeenPrivacy": "Everyone"
      });
    });

    test(
        'updateLastSeenVisibility calls updateVisibilitySetting and updates state',
        () async {
      when(mockVisibilityService.getVisibilitySettings())
          .thenAnswer((_) async => initSettings);

      when(mockVisibilityService.updateVisibilitySetting(any, any))
          .thenAnswer((_) async {
        initSettings['lastSeenPrivacy'] = 'nobody';
      });

      await visibilityCubit.loadVisibilitySettings();
      await visibilityCubit.updateLastSeenVisibility('nobody');

      verify(mockVisibilityService.updateVisibilitySetting(
              'lastSeen', 'nobody'))
          .called(1);

      expect(visibilityCubit.state, {
        "readReceipts": true,
        "storyPrivacy": "Everyone",
        "pfpPrivacy": "Everyone",
        "lastSeenPrivacy": "nobody"
      });
    });

    test(
        'updateStoriesVisibility calls updateVisibilitySetting and updates state',
        () async {
      when(mockVisibilityService.getVisibilitySettings())
          .thenAnswer((_) async => initSettings);

      when(mockVisibilityService.updateVisibilitySetting(any, any))
          .thenAnswer((_) async {
        initSettings['storyPrivacy'] = 'nobody';
      });

      await visibilityCubit.loadVisibilitySettings();
      await visibilityCubit.updateStoriesVisibility('nobody');

      verify(mockVisibilityService.updateVisibilitySetting(
              'story', 'nobody'))
          .called(1);

      expect(visibilityCubit.state, {
        "readReceipts": true,
        "storyPrivacy": "nobody",
        "pfpPrivacy": "Everyone",
        "lastSeenPrivacy": "Everyone"
      });
    });

    test('updateReadReceipts calls updateVisibilitySetting and updates state',
        () async {
      when(mockVisibilityService.getVisibilitySettings())
          .thenAnswer((_) async => initSettings);

      when(mockVisibilityService.updateVisibilitySetting(any, any))
          .thenAnswer((_) async {
        initSettings['readReceipts'] = false;
      });

      await visibilityCubit.loadVisibilitySettings();
      await visibilityCubit.updateReadReceipts(false);

      verify(mockVisibilityService.updateVisibilitySetting(
              'readReceipts', false))
          .called(1);

      expect(visibilityCubit.state, {
        "readReceipts": false,
        "storyPrivacy": "Everyone",
        "pfpPrivacy": "Everyone",
        "lastSeenPrivacy": "Everyone"
      });
    });

    test('Error during loadVisibilitySettings is handled', () async {
      when(mockVisibilityService.getVisibilitySettings())
          .thenThrow(Exception('Failed to load'));

      await visibilityCubit.loadVisibilitySettings();

      verify(mockVisibilityService.getVisibilitySettings()).called(2);
      // State remains unchanged because the Cubit handles the error.
      expect(visibilityCubit.state, {});
    });
  });
}
