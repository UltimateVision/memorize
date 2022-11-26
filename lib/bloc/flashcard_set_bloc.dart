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

/// FIXME: Add error handling
class FlashcardSetBloc extends Bloc<FlashcardSetEvent, FlashcardSetState> {
  final FlashcardSetRepository _repository = locator.get();
  final MemorizeNavigator _navigator = locator.get();
  final TextEditingController? nameController;

  FlashcardSetBloc({this.nameController}) : super(FlashcardSetState.initial()) {
    on<LoadFlashcardSetEvent>(_handleLoadFlashcardSetEvent);
    on<CreateFlashcardSetEvent>((event, emit) =>
        emit(const FlashcardSetState(FlashcardSet.empty(), FlashcardSetStateType.ready)));
    on<ChangeSetNameEvent>(
        (event, emit) => emit(state.copyWith(set: state.set.copyWith(name: event.name))));
    on<AddFlashcardEvent>(_handleAddFlashcardSetEvent);
    on<SaveFlashcardSetEvent>(_handleSaveFlashcardSetEvent);
  }

  Future<void> _handleLoadFlashcardSetEvent(
    LoadFlashcardSetEvent event,
    Emitter<FlashcardSetState> emit,
  ) async {
    if (event.id == 'dummy') {
      await _repository.initDummySet();
    }

    FlashcardSet? set = await _repository.get(event.id);

    if (set != null) {
      nameController?.text = set.name;
      emit(FlashcardSetState(set, FlashcardSetStateType.ready));
    } else {
      emit(state.copyWith(selected: null, type: FlashcardSetStateType.error));
    }
  }

  Future<void> _handleAddFlashcardSetEvent(
    AddFlashcardEvent event,
    Emitter<FlashcardSetState> emit,
  ) async {
    if (event is EditFlashcardEvent) {
      List<Flashcard> flashcards = [...state.set.flashcards];
      flashcards[event.index] = event.flashcard;
      emit(state.copyWith(set: state.set.copyWith(flashcards: flashcards)));
    } else {
      List<Flashcard> flashcards = [...state.set.flashcards, event.flashcard];
      emit(state.copyWith(set: state.set.copyWith(flashcards: flashcards)));
    }
  }

  Future<void> _handleSaveFlashcardSetEvent(
    SaveFlashcardSetEvent event,
    Emitter<FlashcardSetState> emit,
  ) async {
    bool isValid = event.formState?.validate() ?? false;

    if (isValid) {
      await _repository.add(state.set);
      _navigator.pop();
    }
  }
}
