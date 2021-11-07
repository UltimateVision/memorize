import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:flutter_conditional_rendering/conditional_switch.dart';
import 'package:memorize/bloc/flashcard_set_bloc.dart';
import 'package:memorize/config/theme.dart';
import 'package:memorize/i18n/locale_bundle.dart';
import 'package:memorize/i18n/localization.dart';
import 'package:memorize/model/flashcard.dart';
import 'package:memorize/ui/dialogs/flashcard_details_dialog.dart';
import 'package:memorize/ui/widgets/bloc_widget.dart';

class FlashcardSetEditPage extends BlocWidget<FlashcardSetBloc> {
  final String id;
  final String setName;
  final bool isNewSet;

  FlashcardSetEditPage.create()
      : id = '',
        setName = 'Create set',
        isNewSet = true,
        super(FlashcardSetBloc()..add(CreateFlashcardSetEvent()));

  FlashcardSetEditPage.edit(this.id, this.setName)
      : isNewSet = false,
        super(FlashcardSetBloc()..add(LoadFlashcardSetEvent(id)));

  @override
  Widget build(BuildContext context) {
    final LocaleBundle localeBundle = Localization.of(context).bundle;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          setName,
          style: TextStyle(color: Colors.black38),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.black38,
        ),
        actions: [
          IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (_) => FlashcardDetailsDialog.create(
                  onFlashcardSaved: (flashcard) => bloc.add(AddFlashcardEvent(flashcard))),
              barrierDismissible: false,
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

  Widget _buildPage(BuildContext context, FlashcardSetState state, LocaleBundle localeBundle) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Conditional.single(
                context: context,
                conditionBuilder: (_) => isNewSet,
                widgetBuilder: (_) => _buildForm(context, state, localeBundle),
                fallbackBuilder: (_) => const SizedBox.shrink(),
              ),
              Conditional.single(
                context: context,
                conditionBuilder: (_) => state.set.flashcards.isNotEmpty,
                widgetBuilder: (_) => _buildList(context, state, localeBundle),
                fallbackBuilder: (_) => _emptySetWidget(context, localeBundle),
              ),
            ],
          ),
        ),
      );

  Widget _emptySetWidget(BuildContext context, LocaleBundle localeBundle) => Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 16.0,
          ),
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
      );

  Widget _buildForm(BuildContext context, FlashcardSetState state, LocaleBundle localeBundle) => Form(
        child: Column(
          children: [
            TextFormField(
              onChanged: (text) => bloc.add(ChangeSetNameEvent(text)),
              decoration: InputDecoration(border: OutlineInputBorder(), labelText: localeBundle.setNameLabel),
              initialValue: state.set.name,
            ),
            const SizedBox(
              height: 8.0,
            ),
          ],
        ),
      );

  Widget _buildList(BuildContext context, FlashcardSetState state, LocaleBundle localeBundle) => ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemBuilder: (_, index) => _buildFlashcard(state.set.flashcards[index], MemorizeTheme.getFlashcardColor(index)),
        itemCount: state.set.flashcards.length,
      );

  Widget _buildFlashcard(Flashcard flashcard, Color color) => Card(
        color: color,
        child: ListTile(
          title: Text(flashcard.question),
          subtitle: Text(flashcard.answer),
        ),
      );
}
