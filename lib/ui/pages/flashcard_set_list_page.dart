import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional_switch.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:memorize/bloc/flashcard_set_list_bloc.dart';
import 'package:memorize/i18n/locale_bundle.dart';
import 'package:memorize/i18n/localization.dart';
import 'package:memorize/model/flashcard_set.dart';
import 'package:memorize/ui/widgets/bloc_widget.dart';

class FlashcardSetListPage extends BlocWidget<FlashcardSetListBloc> {
  FlashcardSetListPage() : super(FlashcardSetListBloc()..add(FlashcardSetListEvent(FlashcardSetListEventType.load)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "MEMORIZE",
          style:
              TextStyle(fontFamily: 'Elianto', fontWeight: FontWeight.w200, letterSpacing: 4.0, color: Colors.black38),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
        actions: [
          IconButton(
            onPressed: () => bloc.add(FlashcardSetListEvent(FlashcardSetListEventType.create)),
            icon: Icon(Icons.add, color: Colors.black38,),
          ),
        ],
      ),
      body: Center(
        child: BlocBuilder(
          bloc: bloc,
          builder: (_, FlashcardSetListState state) => ConditionalSwitch.single(
            caseBuilders: {
              FlashcardSetListStateType.loading: (_) => CircularProgressIndicator(),
              FlashcardSetListStateType.initial: (_) => CircularProgressIndicator(),
              FlashcardSetListStateType.error: (_) => Text('Error loading set list'),
            },
            fallbackBuilder: (_) => _buildList(context, state),
            valueBuilder: (_) => state.type,
            context: context,
          ),
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, FlashcardSetListState state) {
    final LocaleBundle locale = Localization.of(context).bundle;

    if (state.sets != null && state.sets!.length > 0) {
      return ListView.builder(
        itemBuilder: (_, index) => _buildListItem(context, state.sets![index], locale),
        itemCount: state.sets!.length,
      );
    } else {
      return Center(
        child: Text(locale.noSets),
      );
    }
  }

  Widget _buildListItem(BuildContext context, FlashcardSet set, LocaleBundle locale) => Slidable(
        child: ListTile(
          title: Text(set.name),
          subtitle: Text(locale.sizeOfSet(set.flashcards.length)),
          onTap: () => bloc.add(FlashcardSetListEvent(FlashcardSetListEventType.open, set: set)),
        ),
        actionPane: SlidableDrawerActionPane(),
        actions: [
          IconSlideAction(
            caption: locale.edit,
            color: Colors.lightBlueAccent,
            icon: Icons.edit,
            onTap: () => bloc.add(FlashcardSetListEvent(FlashcardSetListEventType.edit, set: set)),
          ),
          IconSlideAction(
            caption: locale.delete,
            color: Colors.redAccent,
            icon: Icons.delete,
            onTap: () => bloc.add(FlashcardSetListEvent(FlashcardSetListEventType.delete, set: set)),
          ),
        ],
      );
}
