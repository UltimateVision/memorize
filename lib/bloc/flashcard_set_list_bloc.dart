import 'package:bloc/bloc.dart';
import 'package:memorize/config/di_config.dart';
import 'package:memorize/config/navigation.dart';
import 'package:memorize/model/flashcard_set.dart';
import 'package:memorize/repository/flashcard_set_repository.dart';

class FlashcardSetListBloc extends Bloc<FlashcardSetListEvent, FlashcardSetListState> {
  final FlashcardSetRepository _repository = locator.get();
  final MemorizeNavigator _navigator = locator.get();

  FlashcardSetListBloc() : super(FlashcardSetListState(FlashcardSetListStateType.initial));

  @override
  Stream<FlashcardSetListState> mapEventToState(FlashcardSetListEvent event) async* {
    switch (event.type) {
      case FlashcardSetListEventType.load:
        yield FlashcardSetListState(FlashcardSetListStateType.loading);
        List<FlashcardSet> sets = await _repository.getAll();
        yield FlashcardSetListState(FlashcardSetListStateType.loaded, sets: sets);
        break;
      case FlashcardSetListEventType.open:
        _navigator.push(MemorizeNavigator.openSet(
          event.set!.id,
        ));
        break;
      case FlashcardSetListEventType.edit:
        _navigator.push(MemorizeNavigator.editSet(event.set!.id))
            .then((_) => add(FlashcardSetListEvent(FlashcardSetListEventType.load)));
        break;
      case FlashcardSetListEventType.delete:
        List<FlashcardSet> sets = _delete(event);
        yield state.copyWith(sets: sets);
        break;
      case FlashcardSetListEventType.create:
        _navigator.push(MemorizeNavigator.createSet())
            .then((_) => add(FlashcardSetListEvent(FlashcardSetListEventType.load)));
        break;
    }
  }

  List<FlashcardSet> _delete(FlashcardSetListEvent event) {
    final String removedSet = event.set!.id;
    _repository.remove(removedSet);
    List<FlashcardSet> sets = state.sets!.where((set) => set.id != removedSet).toList();
    return sets;
  }
}

class FlashcardSetListState {
  final FlashcardSetListStateType type;
  final List<FlashcardSet>? sets;

  FlashcardSetListState(this.type, {this.sets});

  FlashcardSetListState copyWith({FlashcardSetListStateType? type, List<FlashcardSet>? sets}) {
    return FlashcardSetListState(type ?? this.type, sets: sets ?? this.sets);
  }
}

enum FlashcardSetListStateType { initial, loading, loaded, error }

class FlashcardSetListEvent {
  final FlashcardSetListEventType type;
  final FlashcardSet? set;

  FlashcardSetListEvent(this.type, {this.set});
}

enum FlashcardSetListEventType { load, create, open, edit, delete }
