part of 'flashcard_set_bloc.dart';

class FlashcardSetState implements Equatable {
  final FlashcardSet set;
  final FlashcardSetStateType type;
  final Flashcard? selected;
  final Color? color;

  FlashcardSetState(this.selected, this.color, this.set, this.type);

  FlashcardSetState copyWith(
          {FlashcardSet? set, Flashcard? selected, Color? color, FlashcardSetStateType? type}) =>
      FlashcardSetState(
        selected ?? this.selected,
        color ?? this.color,
        set ?? this.set,
        type ?? this.type,
      );

  @override
  List<Object?> get props => [this.type, this.set, this.selected, this.color];

  @override
  bool? get stringify => true;
}

enum FlashcardSetStateType { loading, ready, error }
