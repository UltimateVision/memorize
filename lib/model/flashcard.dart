import 'package:hive/hive.dart';
import 'package:memorize/config/hive_config.dart';

part 'flashcard.g.dart';

@HiveType(typeId: HiveTypes.FLASHCARD)
class Flashcard extends HiveObject {
  @HiveField(0)
  final String question;
  @HiveField(1)
  final String answer;

  Flashcard(this.question, this.answer);

  Flashcard copyWith({String? question, String? answer}) => Flashcard(question ?? this.question, answer ?? this.answer);
}
