import 'package:hive/hive.dart';
import 'package:memorize/model/flashcard.dart';
import 'package:memorize/model/flashcard_set.dart';
import 'package:memorize/repository/box_repository.dart';

class FlashcardSetRepository extends BoxRepository<FlashcardSet> {

  static const FlashcardSet dummySet = FlashcardSet(
    'dummy',
    'dummy',
    [
      Flashcard("Question 1", "Answer 1"),
      Flashcard("Question 2", "Answer 2"),
      Flashcard("Question 3", "Answer 3"),
    ],
  );

  FlashcardSetRepository() : super('flashcards');

  Future<FlashcardSet> add(FlashcardSet set) async {
    Box<FlashcardSet> box = await getBox();

    if (set.id.isEmpty) {
      set = FlashcardSet.withId(set.name, set.flashcards);
    }

    box.put(set.id, set);
    return set;
  }

  Future<FlashcardSet?> get(String id) async {
    Box<FlashcardSet> box = await getBox();

    return box.get(id);
  }

  Future<void> remove(String id) async {
    Box<FlashcardSet> box = await getBox();
    box.delete(id);
  }

  Future<List<FlashcardSet>> getAll() async {
    Box<FlashcardSet> box = await getBox();

    return box.values.toList();
  }

  Future<void> initDummySet() async {
    Box<FlashcardSet> box = await getBox();

    if (!box.containsKey(dummySet.id)) {
      box.put(dummySet.id, dummySet);
    }
  }
}