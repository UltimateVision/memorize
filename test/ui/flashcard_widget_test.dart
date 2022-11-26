import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memorize/ui/widgets/flashcard_widget.dart';
import 'package:memorize/utils/test_widget.dart';

void main() {
  const String frontText = 'front';
  const String backText = 'back';
  const FlashcardWidget flashcardWidget = FlashcardWidget(
    color: Colors.orangeAccent,
    frontText: frontText,
    reverseText: backText,
  );

  testWidgets('Flashcard should present front text when first displayed', (WidgetTester tester) async {
    await tester.pumpWidget(
      const TestWidget(child: flashcardWidget),
    );

    expect(find.text(frontText), findsOneWidget);
    expect(find.text(backText), findsNothing);
  });

  testWidgets('Flashcard should switch text after tapping on it', (WidgetTester tester) async {
    await tester.pumpWidget(
      const TestWidget(child: flashcardWidget),
    );

    await tester.tap(find.byType(Card));
    await tester.pumpAndSettle();

    expect(find.text(frontText), findsNothing);
    expect(find.text(backText), findsOneWidget);

    await tester.tap(find.byType(Card));
    await tester.pumpAndSettle();

    expect(find.text(frontText), findsOneWidget);
    expect(find.text(backText), findsNothing);
  });
}
