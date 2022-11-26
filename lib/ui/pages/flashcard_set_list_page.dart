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
  FlashcardSetListPage({super.key})
      : super(FlashcardSetListBloc()..add(FlashcardSetListEvent(FlashcardSetListEventType.load)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "MEMORIZE",
          style: TextStyle(
              fontFamily: 'Elianto',
              fontWeight: FontWeight.w200,
              letterSpacing: 4.0,
              color: Colors.black38),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
        actions: [
          IconButton(
            onPressed: () => bloc.add(FlashcardSetListEvent.create()),
            icon: const Icon(
              Icons.add,
              color: Colors.black38,
            ),
          ),
        ],
      ),
      body: Center(
        child: BlocBuilder(
          bloc: bloc,
          builder: (_, FlashcardSetListState state) => ConditionalSwitch.single(
            caseBuilders: {
              FlashcardSetListStateType.loading: (_) => const CircularProgressIndicator(),
              FlashcardSetListStateType.initial: (_) => const CircularProgressIndicator(),
              FlashcardSetListStateType.error: (_) => const Text('Error loading set list'),
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

    if (state.sets != null && state.sets!.isNotEmpty) {
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
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              label: locale.edit,
              backgroundColor: Colors.lightBlueAccent,
              icon: Icons.edit,
              onPressed: (_) => bloc.add(FlashcardSetListEvent.edit(set.id)),
            ),
            SlidableAction(
              label: locale.delete,
              backgroundColor: Colors.redAccent,
              icon: Icons.delete,
              onPressed: (_) => bloc.add(FlashcardSetListEvent.delete(set.id)),
            ),
          ],
        ),
        child: ListTile(
          title: Text(set.name),
          subtitle: Text(locale.sizeOfSet(set.flashcards.length)),
          onTap: () => bloc.add(FlashcardSetListEvent.open(set.id)),
        ),
      );
}
