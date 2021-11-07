import 'package:flutter/painting.dart';

class MemorizeTheme {
  MemorizeTheme._();

  static List<Color> flashcardColors = [
    Color(0xFFFFE082),
    Color(0xFFE6EE9C),
    Color(0xFFC5E1A5),
    Color(0xFF80CBC4),
    Color(0xFF80DEEA),
    Color(0xFFE1BEE7),
  ];

  static Color getFlashcardColor(int index) => flashcardColors[index % flashcardColors.length];
}