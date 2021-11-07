import 'dart:io';

import 'package:hive/hive.dart';
import 'package:memorize/model/flashcard.dart';
import 'package:memorize/model/flashcard_set.dart';
import 'package:path_provider/path_provider.dart';

class HiveTypes {
  static const int FLASHCARD = 1;
  static const int FLASHCARD_SET = 2;
}

class HiveConfig {

  static Future<void> init() async {
    Directory? dir = await getExternalStorageDirectory();
    Hive
        ..init(dir!.path)
        ..registerAdapter<Flashcard>(FlashcardAdapter())
        ..registerAdapter<FlashcardSet>(FlashcardSetAdapter());
  }
}
