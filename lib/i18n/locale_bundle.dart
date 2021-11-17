/// Definition for all localized strings in application
abstract class LocaleBundle {
  String get homePageTitle;
  String get delete;
  String get edit;
  String get noSets;
  String sizeOfSet(int length);

  /// Edit page
  String get noFlashcards;
  String failedToLoadSet(String name);
  String get setNameLabel;
  String get questionLabel;
  String get answerLabel;

  /// Generic
  String get appError;
}

class LocaleBundleEn extends LocaleBundle {
  @override
  String get homePageTitle => 'Memorize';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String sizeOfSet(int length) => '$length flashcards';

  @override
  String get noSets => 'No sets found. Add one now!';

  @override
  String get noFlashcards => 'It\'s empty here. Add new flashcard by clicking [+] button';

  @override
  String failedToLoadSet(String name) => 'Error loading $name set';

  @override
  String get setNameLabel => 'Name';

  @override
  String get answerLabel => 'Answer';

  @override
  String get questionLabel => 'Question';

  @override
  String get appError => 'Ooops, there was an error...';

}