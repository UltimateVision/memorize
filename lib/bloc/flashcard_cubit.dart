import 'package:bloc/bloc.dart';
import 'package:memorize/model/flashcard.dart';

class FlashcardCubit extends Cubit<Flashcard> {

  FlashcardCubit(Flashcard initialState) : super(initialState);

  void setQuestion(String question) => emit(state.copyWith(question: question));

  void setAnswer(String answer) => emit(state.copyWith(answer: answer));
}
