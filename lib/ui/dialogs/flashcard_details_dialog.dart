import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memorize/bloc/flashcard_cubit.dart';
import 'package:memorize/config/navigation.dart';
import 'package:memorize/model/flashcard.dart';

typedef OnFlashcardSaved = Function(Flashcard);

class FlashcardDetailsDialog extends StatelessWidget {
  final OnFlashcardSaved onFlashcardSaved;
  final _formKey = GlobalKey<FormState>();

  static Widget create({Flashcard? flashcard, required OnFlashcardSaved onFlashcardSaved}) => BlocProvider(
        create: (_) => FlashcardCubit(flashcard ?? Flashcard('', '')),
        child: FlashcardDetailsDialog(
          onFlashcardSaved: onFlashcardSaved,
        ),
      );

  FlashcardDetailsDialog({required this.onFlashcardSaved});

  @override
  Widget build(BuildContext context) => Dialog(
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(16.0),
          ),
          height: MediaQuery.of(context).size.height / 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<FlashcardCubit, Flashcard>(
              builder: (context, state) => Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Question',
                        border: OutlineInputBorder(),
                      ),
                      initialValue: state.question,
                      onChanged: (text) => context.read<FlashcardCubit>().setQuestion(text),
                      validator: (value) => _fieldRequiredValidator('Question', value),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Answer',
                        border: OutlineInputBorder(),
                      ),
                      initialValue: state.question,
                      onChanged: (text) => context.read<FlashcardCubit>().setAnswer(text),
                      validator: (value) => _fieldRequiredValidator('Answer', value),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => MemorizeNavigator.pop(),
                          icon: Icon(Icons.cancel),
                        ),
                        IconButton(
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              onFlashcardSaved.call(state);
                              Navigator.of(context).pop();
                            }
                          },
                          icon: Icon(Icons.check_circle),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}

String? _fieldRequiredValidator(String fieldName, String? value) =>
    (value == null || value.isEmpty) ? '$fieldName is required' : null;
