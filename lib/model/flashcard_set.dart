import 'package:hive/hive.dart';
import 'package:memorize/config/hive_config.dart';
import 'package:memorize/model/flashcard.dart';
import 'package:uuid/uuid.dart';

part 'flashcard_set.g.dart';

@HiveType(typeId: HiveTypes.FLASHCARD_SET)
class FlashcardSet extends HiveObject {

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final List<Flashcard> flashcards;

  FlashcardSet(this.id, this.name, this.flashcards);

  FlashcardSet.withId(this.name, this.flashcards) : id = Uuid().v4();

  FlashcardSet copyWith({String? name, List<Flashcard>? flashcards}) =>
      FlashcardSet(this.id, name ?? this.name, flashcards ?? this.flashcards);
}
