import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:memorize/config/hive_config.dart';
import 'package:memorize/model/flashcard.dart';
import 'package:uuid/uuid.dart';

part 'flashcard_set.g.dart';

@HiveType(typeId: HiveTypes.flashcardSet)
class FlashcardSet extends Equatable {

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final List<Flashcard> flashcards;

  const FlashcardSet(this.id, this.name, this.flashcards);

  FlashcardSet.withId(this.name, this.flashcards) : id = const Uuid().v4();
  const FlashcardSet.empty() : id = '', name = '', flashcards = const [];

  FlashcardSet copyWith({String? name, List<Flashcard>? flashcards}) =>
      FlashcardSet(id, name ?? this.name, flashcards ?? this.flashcards);

  @override
  List<Object?> get props => [id, name, flashcards];
  
}
