import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/visibility_service.dart';

class VisibilityCubit extends Cubit<Map<String, dynamic>> {
  final VisibilityService _visibilityService;

  VisibilityCubit(this._visibilityService) : super({}) {
    loadVisibilitySettings();
  }

  Future<void> loadVisibilitySettings() async {
    try {
      final settings = await _visibilityService.getVisibilitySettings();
      emit(settings);
    } catch (e) {
      if (kDebugMode) print("FAILED TO LOAD VISIBILITY SETTINGS: $e");
    }
  }

  Future<void> updateProfilePictureVisibility(String visibility) async {
    await updateVisibilitySetting('pfp', visibility);
  }

  Future<void> updateLastSeenVisibility(String visibility) async {
    await updateVisibilitySetting('lastSeen', visibility);
  }

  Future<void> updateStoriesVisibility(String visibility) async {
    await updateVisibilitySetting('story', visibility);
  }

  Future<void> updateReadReceipts(bool value) async {
    await updateVisibilitySetting('readReceipts', value);
  }

  Future<void> updateAddMeToGroupsVisibility(String visibility) async {
    await updateVisibilitySetting('addMeToGroups', visibility);
  }

  Future<void> updateVisibilitySetting(String key, dynamic value) async {
    try {
      await _visibilityService.updateVisibilitySetting(key, value);
      final updatedSettings = await _visibilityService.getVisibilitySettings();
      emit(updatedSettings);
    } catch (e) {
      if (kDebugMode) print("FAILED TO UPDATE VISIBILITY SETTINGS $e");
    }
  }
}
