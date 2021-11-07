import 'package:hive/hive.dart';
import 'package:memorize/model/flashcard.dart';
import 'package:memorize/model/flashcard_set.dart';
import 'package:memorize/repository/box_repository.dart';

class FlashcardSetRepository extends BoxRepository<FlashcardSet> {

  static FlashcardSet _dummySet = FlashcardSet(
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

  Future<FlashcardSet?> get(String name) async {
    Box<FlashcardSet> box = await getBox();

    return box.get(name);
  }

  Future<void> remove(String name) async {
    Box<FlashcardSet> box = await getBox();
    box.delete(name);
  }

  Future<List<FlashcardSet>> getAll() async {
    Box<FlashcardSet> box = await getBox();

    return box.values.toList();
  }

  Future<void> initDummySet() async {
    Box<FlashcardSet> box = await getBox();

    if (!box.containsKey(_dummySet.id)) {
      box.put(_dummySet.id, _dummySet);
    }
  }
}