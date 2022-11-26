import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:memorize/config/hive_config.dart';

part 'flashcard.g.dart';

@HiveType(typeId: HiveTypes.flashcard)
class Flashcard extends Equatable {
  @HiveField(0)
  final String question;
  @HiveField(1)
  final String answer;

  const Flashcard(this.question, this.answer);

  Flashcard copyWith({String? question, String? answer}) => Flashcard(question ?? this.question, answer ?? this.answer);

  @override
  List<Object?> get props => [question, answer];

}
