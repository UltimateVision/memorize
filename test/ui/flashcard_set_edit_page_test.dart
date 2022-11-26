import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memorize/config/di_config.dart';
import 'package:memorize/config/navigation.dart';
import 'package:memorize/i18n/locale_bundle.dart';
import 'package:memorize/model/flashcard.dart';
import 'package:memorize/model/flashcard_set.dart';
import 'package:memorize/repository/flashcard_set_repository.dart';
import 'package:memorize/ui/pages/flashcard_set_edit_page.dart';
import 'package:memorize/utils/test_widget.dart';
import 'package:mocktail/mocktail.dart';

class _MockedFlashcardSetRepository extends Mock implements FlashcardSetRepository {}

class _MockedMemorizeNavigator extends Mock implements MemorizeNavigator {}

const FlashcardSet _dummySet = FlashcardSet('id', 'name', [Flashcard('question', 'answer')]);

void main() {
  final LocaleBundleEn localeBundleEn = LocaleBundleEn();

  _MockedFlashcardSetRepository repository = _MockedFlashcardSetRepository();
  _MockedMemorizeNavigator navigator = _MockedMemorizeNavigator();

  when(() => repository.get(_dummySet.id)).thenAnswer((_) => Future.value(_dummySet));

  locator.registerSingleton<FlashcardSetRepository>(repository);
  locator.registerSingleton<MemorizeNavigator>(navigator);

  testWidgets('should show empty page when using create factory', (WidgetTester tester) async {
    await tester.pumpWidget(TestWidget(child: FlashcardSetEditPage.create()));

    // FIXME: add checking for form field state
    expect(find.byIcon(Icons.style_rounded), findsOneWidget);
    expect(find.text(localeBundleEn.noFlashcards), findsOneWidget);

    expect(find.byType(ListTile), findsNothing);
  });

  testWidgets('should show requested set when using edit factory', (WidgetTester tester) async {
    await tester.pumpWidget(TestWidget(child: FlashcardSetEditPage.edit(_dummySet.id)));

    expect(find.byIcon(Icons.style_rounded), findsNothing);
    expect(find.text(localeBundleEn.noFlashcards), findsNothing);

    expect(find.text(_dummySet.name), findsOneWidget);
    expect(find.byType(ListTile), findsNWidgets(_dummySet.flashcards.length));
    expect(find.text(_dummySet.flashcards[0].question), findsOneWidget);
    expect(find.text(_dummySet.flashcards[0].answer), findsOneWidget);
  });
}