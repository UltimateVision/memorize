import 'package:flutter/material.dart' hide BackButton;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:flutter_conditional_rendering/conditional_switch.dart';
import 'package:memorize/bloc/flashcard_set_bloc.dart';
import 'package:memorize/config/theme.dart';
import 'package:memorize/model/flashcard.dart';
import 'package:memorize/ui/widgets/back_button.dart';
import 'package:memorize/ui/widgets/bloc_widget.dart';
import 'package:memorize/ui/widgets/flashcard_widget.dart';

class FlashcardSetPage extends BlocWidget<FlashcardSetBloc> {
  final PageController controller = PageController();
  final String setID;

  FlashcardSetPage(this.setID, {super.key})
      : super(FlashcardSetBloc()..add(LoadFlashcardSetEvent(setID)));

  @override
  void initState() {
    controller.addListener(() {
      // bloc.add(ChangeActiveFlashcardEvent(controller.page!.round()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<FlashcardSetBloc, FlashcardSetState>(
          buildWhen: (oldState, newState) => oldState.set.name != newState.set.name,
          builder: (_, FlashcardSetState state) => Text(
            state.set.name,
            style: const TextStyle(color: Colors.black38),
          ),
        ),
        leading: BackButton(),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
        iconTheme: const IconThemeData(
          color: Colors.black38,
        ),
      ),
      body: Center(
        child: BlocBuilder<FlashcardSetBloc, FlashcardSetState>(
          builder: (_, state) => ConditionalSwitch.single(
            caseBuilders: {
              FlashcardSetStateType.loading: (_) => const CircularProgressIndicator(),
              FlashcardSetStateType.error: (_) => Text('Error loading $setID set'),
            },
            fallbackBuilder: (_) => _buildList(context, state.set.flashcards),
            valueBuilder: (_) => state.type,
            context: context,
          ),
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, List<Flashcard> flashcards) => Conditional.single(
        context: context,
        conditionBuilder: (_) => flashcards.isNotEmpty,
        widgetBuilder: (_) => Conditional.single(
          context: context,
          conditionBuilder: (_) => flashcards.isNotEmpty,
          widgetBuilder: (_) => PageView.builder(
            controller: controller,
            itemBuilder: (_, position) => buildFlashcard(flashcards, position),
            itemCount: flashcards.length,
          ),
          fallbackBuilder: (_) => const CircularProgressIndicator(),
        ),
        fallbackBuilder: (_) => const CircularProgressIndicator(),
      );

  Widget buildFlashcard(List<Flashcard> flashcards, int position) {
    final Flashcard flashcard = flashcards[position];
    final Color color = MemorizeTheme.getFlashcardColor(position);

    return Center(
      child: FlashcardWidget(
        frontText: flashcard.question,
        reverseText: flashcard.answer,
        color: color,
      ),
    );
  }
}
