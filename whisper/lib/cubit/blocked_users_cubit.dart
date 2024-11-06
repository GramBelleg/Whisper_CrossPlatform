import 'package:flutter_bloc/flutter_bloc.dart';

class BlockedUsersCubit extends Cubit<List<Map<String, String>>> {
  BlockedUsersCubit()
      : super([
          {
            'name': 'Alice',
            'profilePicture': 'https://placecats.com/neo/100/100',
          },
          {
            'name': 'Bob',
            'profilePicture': 'https://place.dog/100/100',
          },
          {
            'name': 'Konafa',
            'profilePicture': 'https://placecats.com/neo_2/200/200',
          },
          {
            'name': 'bati5a',
            'profilePicture': 'https://place.dog/200/200',
          },
          {
            'name': 'lalala',
            'profilePicture': 'https://placecats.com/bella/100/100',
          },
          {
            'name': 'bababa',
            'profilePicture': 'https://placecats.com/millie/100/100',
          },
        ]);

  void unblockUser(int index) {
    final blockedUsers = List<Map<String, String>>.from(state);
    blockedUsers.removeAt(index);
    emit(blockedUsers);
  }
}
