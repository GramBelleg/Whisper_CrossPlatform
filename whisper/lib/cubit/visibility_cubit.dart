import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/visibility_service.dart';

class VisibilityCubit extends Cubit<Map<String, dynamic>> {
  final VisibilityService _visibilityService;

  VisibilityCubit(this._visibilityService) : super({}) {
    _loadVisibilitySettings();
  }

  Future<void> _loadVisibilitySettings() async {
    try {
      final settings = await _visibilityService.getVisibilitySettings();
      emit(settings);
    } catch (e) {
      if (kDebugMode) print("FAILED TO LOAD VISIBILITY SETTINGS: $e");
    }
  }

  void updateProfilePictureVisibility(String visibility) {
    _updateVisibilitySetting('pfp', visibility);
  }

  void updateLastSeenVisibility(String visibility) {
    _updateVisibilitySetting('lastSeen', visibility);
  }

  void updateStoriesVisibility(String visibility) {
    _updateVisibilitySetting('story', visibility);
  }

  void updateReadReceipts(bool value) {
    _updateVisibilitySetting('readReceipts', value);
  }

  void updateAddMeToGroupsVisibility(String visibility) {
    _updateVisibilitySetting('addMeToGroups', visibility);
  }

  Future<void> _updateVisibilitySetting(String key, dynamic value) async {
    try {
      await _visibilityService.updateVisibilitySetting(key, value);
      final updatedSettings = await _visibilityService.getVisibilitySettings();
      emit(updatedSettings);
    } catch (e) {
      if (kDebugMode) print("FAILED TO UPDATE VISIBILITY SETTINGS $e");
    }
  }
}
