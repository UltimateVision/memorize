import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:memorize/config/di_config.dart';
import 'package:memorize/config/navigation.dart';
import 'package:memorize/model/flashcard.dart';
import 'package:memorize/model/flashcard_set.dart';
import 'package:memorize/repository/flashcard_set_repository.dart';

part 'flashcard_set_event.dart';

part 'flashcard_set_state.dart';

class FlashcardSetBloc extends Bloc<FlashcardSetEvent, FlashcardSetState> {
  final FlashcardSetRepository _repository = locator.get();
  final MemorizeNavigator _navigator = locator.get();
  final TextEditingController? nameController;

  FlashcardSetBloc({this.nameController}) : super(FlashcardSetState.initial());

  @override
  Stream<FlashcardSetState> mapEventToState(FlashcardSetEvent event) async* {
    if (event is LoadFlashcardSetEvent) {
      yield await _loadSet(event);
    } else if (event is CreateFlashcardSetEvent) {
      yield FlashcardSetState(FlashcardSet('', '', []), FlashcardSetStateType.ready);
    } else if (event is ChangeSetNameEvent) {
      yield state.copyWith(set: state.set.copyWith(name: event.name));
    } else if (event is AddFlashcardEvent) {
      if (event is EditFlashcardEvent) {
        List<Flashcard> flashcards = [...state.set.flashcards];
        flashcards[event.index] = event.flashcard;
        yield state.copyWith(set: state.set.copyWith(flashcards: flashcards));
      } else {
        List<Flashcard> flashcards = [...state.set.flashcards, event.flashcard];
        yield state.copyWith(set: state.set.copyWith(flashcards: flashcards));
      }
    } else if (event is SaveSetEvent) {
      if (isSetValid(state.set)) {
        await _repository.add(state.set);
        _navigator.pop();
      } else {
        // TODO: show dialog or sth
        print('Tried to save invalid set!');
      }
    }
  }

  bool isSetValid(FlashcardSet set) => set.name.isNotEmpty && set.flashcards.isNotEmpty;

  Future<FlashcardSetState> _loadSet(LoadFlashcardSetEvent event) async {
    if (event.id == 'dummy') {
      await _repository.initDummySet();
    }

    FlashcardSet? set = await _repository.get(event.id);

    if (set != null) {
      nameController?.text = set.name;
      return FlashcardSetState(set, FlashcardSetStateType.ready);
    } else {
      return state.copyWith(selected: null, type: FlashcardSetStateType.error);
    }
  }
}
