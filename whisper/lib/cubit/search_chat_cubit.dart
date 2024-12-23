import 'package:bloc/bloc.dart';

class SearchChatState {
  final bool isSearch;

  SearchChatState({required this.isSearch});
}

class SearchChatCubit extends Cubit<SearchChatState> {
  SearchChatCubit() : super(SearchChatState(isSearch: false));

  void toggleSearch() {
    emit(SearchChatState(
        isSearch: !state.isSearch)); // Toggle the isSearch value
  }

  void toggleSearchCloseChat() {
    emit(SearchChatState(isSearch: false)); // Toggle the isSearch value
  }

  bool getStateSearch() {
    return state.isSearch;
  }
}
