import 'package:flutter_bloc/flutter_bloc.dart';

enum VisibilityState { everyone, contacts, nobody }

class VisibilityCubit extends Cubit<Map<String, dynamic>> {
  VisibilityCubit()
      : super({
          'profilePicture': VisibilityState.everyone,
          'lastSeen': VisibilityState.everyone,
          'stories': VisibilityState.everyone,
          'readReceipts': true,
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
}
