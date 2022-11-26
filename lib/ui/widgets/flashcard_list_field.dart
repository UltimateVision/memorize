import 'package:flutter/material.dart';
import 'package:memorize/bloc/flashcard_set_bloc.dart';
import 'package:memorize/config/theme.dart';
import 'package:memorize/i18n/locale_bundle.dart';
import 'package:memorize/i18n/localization.dart';
import 'package:memorize/model/flashcard.dart';
import 'package:memorize/ui/dialogs/flashcard_details_dialog.dart';

class EditableFlashcardListField extends FormField<List<Flashcard>> {
  EditableFlashcardListField({super.key, required FlashcardSetBloc bloc})
      : super(
          builder: (formFieldState) => _FlashcardListField(
            bloc: bloc,
            formFieldState: formFieldState,
            key: key,
          ),
          validator: (_) => bloc.state.set.flashcards.isNotEmpty ? null : 'empty',
        );
}

class _FlashcardListField extends StatelessWidget {
  final FlashcardSetBloc bloc;
  final FormFieldState formFieldState;

  const _FlashcardListField({Key? key, required this.bloc, required this.formFieldState});

  @override
  Widget build(BuildContext context) {
    final LocaleBundle localeBundle = Localization.of(context).bundle;

    return _buildPage(context, bloc.state, localeBundle);
  }

  Widget _buildPage(BuildContext context, FlashcardSetState state, LocaleBundle localeBundle) =>
      state.set.flashcards.isNotEmpty
          ? _buildList(context, state, localeBundle)
          : _emptySetWidget(context, localeBundle);

  Widget _emptySetWidget(BuildContext context, LocaleBundle localeBundle) {
    final Color color = formFieldState.hasError ? Colors.redAccent : Colors.black38;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.style_rounded,
            size: 96.0,
            color: color,
          ),
          const SizedBox(
            height: 16.0,
          ),
          Text(
            localeBundle.noFlashcards,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.caption?.copyWith(color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, FlashcardSetState state, LocaleBundle localeBundle) => ListView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemBuilder: (_, index) => _buildFlashcard(state, index, context),
        itemCount: state.set.flashcards.length,
      );

  Widget _buildFlashcard(FlashcardSetState state, int index, BuildContext context) {
    final Color color = MemorizeTheme.getFlashcardColor(index);
    final Flashcard flashcard = state.set.flashcards[index];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        color: color,
        child: ListTile(
          title: Text(flashcard.question),
          subtitle: Text(flashcard.answer),
          onTap: () => FlashcardDetailsDialog.show(
            context: context,
            onFlashcardSaved: (flashcard) => bloc.add(EditFlashcardEvent(flashcard, index)),
            flashcard: flashcard,
          ),
        ),
      ),
    );
  }
}
