part of 'flashcard_set_bloc.dart';

abstract class FlashcardSetEvent {}

class LoadFlashcardSetEvent extends FlashcardSetEvent {
  final String id;

  LoadFlashcardSetEvent(this.id);
}

class CreateFlashcardSetEvent extends FlashcardSetEvent {}

class ChangeActiveFlashcardEvent extends FlashcardSetEvent {
  final int index;

  ChangeActiveFlashcardEvent(this.index);
}

class AddFlashcardEvent extends FlashcardSetEvent {
  final Flashcard flashcard;

  AddFlashcardEvent(this.flashcard);
}

class EditFlashcardEvent extends AddFlashcardEvent {
  final int index;

  EditFlashcardEvent(Flashcard flashcard, this.index) : super(flashcard);
}

class ChangeSetNameEvent extends FlashcardSetEvent {
  final String name;

  ChangeSetNameEvent(this.name);
}

class SaveSetEvent extends FlashcardSetEvent {}