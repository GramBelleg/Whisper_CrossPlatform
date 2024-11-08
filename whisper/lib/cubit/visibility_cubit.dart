import 'package:flutter_bloc/flutter_bloc.dart';

import '../utils/visibility_utils.dart';

import '../services/visibility_service.dart';

class VisibilityCubit extends Cubit<Map<String, dynamic>> {
  VisibilityCubit()
      : super({
          'profilePicture': VisibilityState.everyone,
          'lastSeen': VisibilityState.everyone,
          'stories': VisibilityState.everyone,
          'readReceipts': true,
          'addMeToGroups': VisibilityState.everyone,
        });
  
  void updateProfilePictureVisibility(VisibilityState visibility) {
    emit({...state, 'profilePicture': visibility});
  }

  void updateLastSeenVisibility(VisibilityState visibility) {
    emit({...state, 'lastSeen': visibility});
  }

  void updateStoriesVisibility(VisibilityState visibility) {
    emit({...state, 'stories': visibility});
  }

  void updateReadReceipts(bool value) {
    emit({...state, 'readReceipts': value});
  }

  void updateAddMeToGroupsVisibility(VisibilityState visibility) {
    emit({...state, 'addMeToGroups': visibility});
  }
}
