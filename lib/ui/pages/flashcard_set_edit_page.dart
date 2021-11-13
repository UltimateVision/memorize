import 'package:flutter/material.dart' hide BackButton;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional_switch.dart';
import 'package:memorize/bloc/flashcard_set_bloc.dart';
import 'package:memorize/config/theme.dart';
import 'package:memorize/i18n/locale_bundle.dart';
import 'package:memorize/i18n/localization.dart';
import 'package:memorize/model/flashcard.dart';
import 'package:memorize/ui/dialogs/flashcard_details_dialog.dart';
import 'package:memorize/ui/widgets/back_button.dart';
import 'package:memorize/ui/widgets/bloc_widget.dart';

class FlashcardSetEditPage extends BlocWidget<FlashcardSetBloc> {
  final _formKey = GlobalKey<FormState>();

  final String id;
  final String setName;
  final bool isNewSet;

  FlashcardSetEditPage.create()
      : id = '',
        setName = '',
        isNewSet = true,
        super(FlashcardSetBloc(nameController: TextEditingController())..add(CreateFlashcardSetEvent()));

  FlashcardSetEditPage.edit(this.id, this.setName)
      : isNewSet = false,
        super(FlashcardSetBloc(nameController: TextEditingController())..add(LoadFlashcardSetEvent(id)));

  @override
  Widget build(BuildContext context) {
    final LocaleBundle localeBundle = Localization.of(context).bundle;

    return Scaffold(
      appBar: AppBar(
        title: _buildForm(context, localeBundle),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.black38,
        ),
        leading: BackButton(),
        actions: [
          IconButton(
            onPressed: () => FlashcardDetailsDialog.show(
              context: context,
              onFlashcardSaved: (flashcard) => bloc.add(AddFlashcardEvent(flashcard)),
              backgroundColor: MemorizeTheme.getFlashcardColor(bloc.state.set.flashcards.length),
            ),
            icon: Icon(Icons.add),
          ),
          IconButton(
            onPressed: () => bloc.add(SaveSetEvent()),
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: BlocBuilder(
        bloc: bloc,
        builder: (_, FlashcardSetState state) => ConditionalSwitch.single(
          caseBuilders: {
            FlashcardSetStateType.loading: (_) => CircularProgressIndicator(),
            FlashcardSetStateType.error: (_) => Text(localeBundle.failedToLoadSet(setName)),
          },
          fallbackBuilder: (_) => _buildPage(context, state, localeBundle),
          valueBuilder: (_) => state.type,
          context: context,
        ),
      ),
    );
  }

  Widget _buildPage(BuildContext context, FlashcardSetState state, LocaleBundle localeBundle) =>
      state.set.flashcards.isNotEmpty
          ? _buildList(context, state, localeBundle)
          : _emptySetWidget(context, localeBundle);

  Widget _emptySetWidget(BuildContext context, LocaleBundle localeBundle) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.style_rounded,
              size: 96.0,
              color: Colors.black38,
            ),
            const SizedBox(
              height: 16.0,
            ),
            Text(
              localeBundle.noFlashcards,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
      );

  Widget _buildForm(BuildContext context, LocaleBundle localeBundle) => Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              onChanged: (text) => bloc.add(ChangeSetNameEvent(text)),
              decoration: InputDecoration(labelText: localeBundle.setNameLabel),
              controller: bloc.nameController,
            ),
          ],
        ),
      );

  Widget _buildList(BuildContext context, FlashcardSetState state, LocaleBundle localeBundle) => ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
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
