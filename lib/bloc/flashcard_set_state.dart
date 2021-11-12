part of 'flashcard_set_bloc.dart';

class FlashcardSetState extends Equatable {
  final FlashcardSet set;
  final FlashcardSetStateType type;

  FlashcardSetState(this.set, this.type);

  FlashcardSetState copyWith({FlashcardSet? set, Flashcard? selected, Color? color, FlashcardSetStateType? type}) =>
      FlashcardSetState(
        set ?? this.set,
        type ?? this.type,
      );

  factory FlashcardSetState.initial() => FlashcardSetState(
        FlashcardSet('', '', []),
        FlashcardSetStateType.loading,
      );

  @override
  List<Object?> get props => [type, set];

}

enum FlashcardSetStateType { loading, ready, error }
