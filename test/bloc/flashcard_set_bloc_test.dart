import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memorize/bloc/flashcard_set_bloc.dart';
import 'package:memorize/config/di_config.dart';
import 'package:memorize/config/navigation.dart';
import 'package:memorize/model/flashcard.dart';
import 'package:memorize/model/flashcard_set.dart';
import 'package:memorize/repository/flashcard_set_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockedFlashcardSetRepository extends Mock implements FlashcardSetRepository {}

class _MockedMemorizeNavigator extends Mock implements MemorizeNavigator {}

class _MockedFormState extends Mock implements FormState {

  @override
  String toString({DiagnosticLevel? minLevel}) => 'MOCK';

}

void main() {
  const String dummyID = '123-qwe-rty';
  final FlashcardSet dummySet = FlashcardSet(
    dummyID,
    FlashcardSetRepository.dummySet.name,
    FlashcardSetRepository.dummySet.flashcards,
  );
  final _MockedFormState validFormState = _MockedFormState();
  final _MockedFormState invalidFormState = _MockedFormState();
  final _MockedFlashcardSetRepository repository = _MockedFlashcardSetRepository();
  final _MockedMemorizeNavigator navigator = _MockedMemorizeNavigator();

  locator.registerSingleton<FlashcardSetRepository>(repository);
  locator.registerSingleton<MemorizeNavigator>(navigator);

  when(() => validFormState.validate()).thenReturn(true);
  when(() => invalidFormState.validate()).thenReturn(false);

  setUpAll(() {
    registerFallbackValue(const FlashcardSet('', '', []));
  });

  group('FlashcardSetState', () {
    test('state equality', () {
      FlashcardSetState state1 = FlashcardSetState(
        dummySet,
        FlashcardSetStateType.ready,
      );
      FlashcardSetState state2 = FlashcardSetState(
        dummySet,
        FlashcardSetStateType.ready,
      );

      expect(state1 == state2, isTrue);
    });

    test('set equality', () {
      FlashcardSet set1 = FlashcardSet('id', 'name', dummySet.flashcards);
      FlashcardSet set2 = FlashcardSet('id', 'name', dummySet.flashcards);

      expect(set1 == set2, isTrue);
    });

    test('flashcard equality', () {
      Flashcard flashcard1 = const Flashcard('A', 'B');
      Flashcard flashcard2 = const Flashcard('A', 'B');

      expect(flashcard1 == flashcard2, isTrue);
    });
  });

  group('FlashcardSetBloc', () {
    late FlashcardSetBloc bloc;
    late TextEditingController textEditingController;

    setUp(() {
      bloc = FlashcardSetBloc();
      textEditingController = TextEditingController();
      when(() => repository.get(dummyID)).thenAnswer((_) => Future.value(dummySet));
      when(() => repository.add(any())).thenAnswer((invocation) => Future.value(invocation.positionalArguments[0]));
    });

    blocTest<FlashcardSetBloc, FlashcardSetState>(
      'on LoadFlashcardSetEvent should emit state with requested set',
      build: () => bloc,
      act: (bloc) => bloc.add(LoadFlashcardSetEvent(dummyID)),
      expect: () => [
        FlashcardSetState(dummySet, FlashcardSetStateType.ready),
      ],
      verify: (_) => verify(() => repository.get(dummyID)).called(1),
    );

    blocTest<FlashcardSetBloc, FlashcardSetState>(
      'on LoadFlashcardSetEvent should init TextEditingController value with requested set name',
      build: () => FlashcardSetBloc(nameController: textEditingController),
      act: (bloc) => bloc.add(LoadFlashcardSetEvent(dummyID)),
      expect: () => [
        FlashcardSetState(dummySet, FlashcardSetStateType.ready),
      ],
      verify: (_) {
        verify(() => repository.get(dummyID)).called(1);
        expect(textEditingController.text == dummySet.name, isTrue);
      },
    );

    blocTest<FlashcardSetBloc, FlashcardSetState>(
      'on CreateFlashcardSetEvent should initialize state with empty set',
      build: () => bloc,
      act: (bloc) => bloc.add(CreateFlashcardSetEvent()),
      expect: () => [
        const FlashcardSetState(FlashcardSet('', '', []), FlashcardSetStateType.ready),
      ],
    );

    blocTest<FlashcardSetBloc, FlashcardSetState>('on AddFlashcardEvent should extend set with given flashcard',
        build: () => bloc,
        act: (bloc) {
          bloc.add(LoadFlashcardSetEvent(dummyID));
          bloc.add(AddFlashcardEvent(const Flashcard('A', 'B')));
        },
        expect: () => [
              FlashcardSetState(dummySet, FlashcardSetStateType.ready),
              FlashcardSetState(dummySet.copyWith(flashcards: [...dummySet.flashcards, const Flashcard('A', 'B')]),
                  FlashcardSetStateType.ready),
            ]);

    blocTest<FlashcardSetBloc, FlashcardSetState>('on EditFlashcardEvent should replace flashcard under given index',
        build: () => bloc,
        act: (bloc) {
          bloc.add(LoadFlashcardSetEvent(dummyID));
          bloc.add(EditFlashcardEvent(const Flashcard('A', 'B'), 0));
        },
        expect: () => [
              FlashcardSetState(dummySet, FlashcardSetStateType.ready),
              FlashcardSetState(dummySet.copyWith(flashcards: [const Flashcard('A', 'B'), ...dummySet.flashcards.sublist(1)]),
                  FlashcardSetStateType.ready),
            ]);

    blocTest<FlashcardSetBloc, FlashcardSetState>('on ChangeSetNameEvent should change set name',
        build: () => bloc,
        act: (bloc) {
          bloc.add(LoadFlashcardSetEvent(dummyID));
          bloc.add(ChangeSetNameEvent('Definitely not a dummy set'));
        },
        expect: () => [
              FlashcardSetState(dummySet, FlashcardSetStateType.ready),
              FlashcardSetState(dummySet.copyWith(name: 'Definitely not a dummy set'), FlashcardSetStateType.ready),
            ]);

    blocTest<FlashcardSetBloc, FlashcardSetState>('on SaveSetEvent should save valid set',
        build: () => bloc,
        act: (bloc) {
          bloc.add(LoadFlashcardSetEvent(dummyID));
          bloc.add(SaveFlashcardSetEvent(validFormState));
        },
        expect: () => [
              FlashcardSetState(dummySet, FlashcardSetStateType.ready),
            ],
        verify: (_) {
          verify(() => repository.add(dummySet)).called(1);
          verify(() => navigator.pop()).called(1);
        });

    blocTest<FlashcardSetBloc, FlashcardSetState>(
        'on SaveSetEvent should not save set invalid form',
        build: () => bloc,
        act: (bloc) {
          bloc.add(CreateFlashcardSetEvent());
          bloc.add(AddFlashcardEvent(const Flashcard('a', 'b')));
          bloc.add(SaveFlashcardSetEvent(invalidFormState));
        },
        expect: () => [
          const FlashcardSetState(FlashcardSet('', '', []), FlashcardSetStateType.ready),
          const FlashcardSetState(FlashcardSet('', '', [Flashcard('a', 'b')]), FlashcardSetStateType.ready),
        ],
        verify: (_) {
          verifyNever(() => repository.add(dummySet));
          verifyNever(() => navigator.pop());
        }
    );

    // FIXME: move form validation testing to widget test
    // blocTest<FlashcardSetBloc, FlashcardSetState>(
    //   'on SaveSetEvent should not save set without name',
    //   build: () => bloc,
    //   act: (bloc) {
    //     bloc.add(CreateFlashcardSetEvent());
    //     bloc.add(AddFlashcardEvent(Flashcard('a', 'b')));
    //     bloc.add(SaveSetEvent(invalidFormState));
    //   },
    //   expect: () => [
    //     FlashcardSetState(FlashcardSet('', '', []), FlashcardSetStateType.ready),
    //     FlashcardSetState(FlashcardSet('', '', [Flashcard('a', 'b')]), FlashcardSetStateType.ready),
    //   ],
    //     verify: (_) {
    //       verifyNever(() => repository.add(dummySet));
    //       verifyNever(() => navigator.pop());
    //     }
    // );
    //
    // blocTest<FlashcardSetBloc, FlashcardSetState>(
    //   'on SaveSetEvent should not save set without flashcards',
    //     build: () => bloc,
    //     act: (bloc) {
    //       bloc.add(CreateFlashcardSetEvent());
    //       bloc.add(ChangeSetNameEvent('My set'));
    //       bloc.add(SaveSetEvent(invalidFormState));
    //     },
    //     expect: () => [
    //       FlashcardSetState(FlashcardSet('', '', []), FlashcardSetStateType.ready),
    //       FlashcardSetState(FlashcardSet('', 'My set', []), FlashcardSetStateType.ready),
    //     ],
    //     verify: (_) {
    //       verifyNever(() => repository.add(dummySet));
    //       verifyNever(() => navigator.pop());
    //     }
    // );
  });
}
