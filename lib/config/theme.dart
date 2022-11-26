import 'package:flutter/painting.dart';

class MemorizeTheme {
  MemorizeTheme._();

  static List<Color> flashcardColors = [
    const Color(0xFFFFE082),
    const Color(0xFFE6EE9C),
    const Color(0xFFC5E1A5),
    const Color(0xFF80CBC4),
    const Color(0xFF80DEEA),
    const Color(0xFFE1BEE7),
  ];

  static Color getFlashcardColor(int index) => flashcardColors[index % flashcardColors.length];
}