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

  FlashcardSetBloc() : super(FlashcardSetState(null, null, FlashcardSet('', '', []), FlashcardSetStateType.loading));

  @override
  Stream<FlashcardSetState> mapEventToState(FlashcardSetEvent event) async* {
    if (event is LoadFlashcardSetEvent) {
      yield await _loadSet(event);
    } else if (event is ChangeActiveFlashcardEvent) {
      yield state.copyWith(selected: state.set.flashcards[event.index]);
    } else if (event is CreateFlashcardSetEvent) {
      yield FlashcardSetState(null, null, FlashcardSet('', '', []), FlashcardSetStateType.ready);
    } else if (event is ChangeSetNameEvent) {
      yield state.copyWith(set: state.set.copyWith(name: event.name));
    } else if (event is AddFlashcardEvent) {
      List<Flashcard> flashcards = [...state.set.flashcards, event.flashcard];
      yield state.copyWith(set: state.set.copyWith(flashcards: flashcards));
    } else if (event is SaveSetEvent) {
      await _repository.add(state.set);
      MemorizeNavigator.pop();
    }
  }

  Future<FlashcardSetState> _loadSet(LoadFlashcardSetEvent event) async {
    if (event.id == 'dummy') {
      await _repository.initDummySet();
    }

    FlashcardSet? set = await _repository.get(event.id);

    return set != null
        ? FlashcardSetState(set.flashcards[0], null, set, FlashcardSetStateType.ready)
        : state.copyWith(selected: null, type: FlashcardSetStateType.error);
  }
}
