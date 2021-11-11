import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memorize/bloc/flashcard_cubit.dart';
import 'package:memorize/config/navigation.dart';
import 'package:memorize/i18n/locale_bundle.dart';
import 'package:memorize/i18n/localization.dart';
import 'package:memorize/model/flashcard.dart';

typedef OnFlashcardSaved = Function(Flashcard);

class FlashcardDetailsDialog extends StatelessWidget {
  final OnFlashcardSaved onFlashcardSaved;
  final Color? backgroundColor;
  final _formKey = GlobalKey<FormState>();

  static Widget create({Flashcard? flashcard, Color? backgroundColor, required OnFlashcardSaved onFlashcardSaved}) =>
      BlocProvider(
        create: (_) => FlashcardCubit(flashcard ?? Flashcard('', '')),
        child: FlashcardDetailsDialog(
          onFlashcardSaved: onFlashcardSaved,
          backgroundColor: backgroundColor,
        ),
      );

  FlashcardDetailsDialog({required this.onFlashcardSaved, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    LocaleBundle localeBundle = Localization.of(context).bundle;

    return Dialog(
      child: Container(
        height: MediaQuery.of(context).size.height / 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<FlashcardCubit, Flashcard>(
            builder: (context, state) => Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'New flashcard',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: localeBundle.questionLabel,
                        ),
                        initialValue: state.question,
                        onChanged: (text) => context.read<FlashcardCubit>().setQuestion(text),
                        validator: (value) => _fieldRequiredValidator(localeBundle.questionLabel, value),
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: localeBundle.answerLabel,
                        ),
                        initialValue: state.answer,
                        onChanged: (text) => context.read<FlashcardCubit>().setAnswer(text),
                        validator: (value) => _fieldRequiredValidator(localeBundle.answerLabel, value),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => MemorizeNavigator.pop(),
                        icon: Icon(Icons.cancel, color: Colors.redAccent, size: 32.0,),
                      ),
                      IconButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            onFlashcardSaved.call(state);
                            Navigator.of(context).pop();
                          }
                        },
                        icon: Icon(Icons.check_circle, color: Colors.greenAccent, size: 32.0,),
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
}

String? _fieldRequiredValidator(String fieldName, String? value) =>
    (value == null || value.isEmpty) ? '$fieldName is required' : null;
