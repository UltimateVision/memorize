import 'package:flutter/material.dart' hide BackButton;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional_switch.dart';
import 'package:memorize/bloc/flashcard_set_bloc.dart';
import 'package:memorize/config/theme.dart';
import 'package:memorize/i18n/locale_bundle.dart';
import 'package:memorize/i18n/localization.dart';
import 'package:memorize/ui/dialogs/flashcard_details_dialog.dart';
import 'package:memorize/ui/widgets/app_error_widget.dart';
import 'package:memorize/ui/widgets/back_button.dart';
import 'package:memorize/ui/widgets/bloc_widget.dart';
import 'package:memorize/ui/widgets/flashcard_list_field.dart';
import 'package:memorize/utils/form_utils.dart';

class FlashcardSetEditPage extends BlocWidget<FlashcardSetBloc> {
  final _formKey = GlobalKey<FormState>();

  FlashcardSetEditPage.create({super.key})
      : super(FlashcardSetBloc(nameController: TextEditingController())..add(CreateFlashcardSetEvent()));

  FlashcardSetEditPage.edit(String id, {super.key})
      : super(FlashcardSetBloc(nameController: TextEditingController())..add(LoadFlashcardSetEvent(id)));

  @override
  Widget build(BuildContext context) {
    final LocaleBundle localeBundle = Localization.of(context).bundle;

    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: _buildTitle(context, localeBundle),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0.0,
          iconTheme: const IconThemeData(
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
              icon: const Icon(Icons.add),
            ),
            IconButton(
              onPressed: () => bloc.add(SaveFlashcardSetEvent(_formKey.currentState)),
              icon: const Icon(Icons.save),
            ),
          ],
        ),
        body: BlocBuilder(
          bloc: bloc,
          builder: (_, FlashcardSetState state) => ConditionalSwitch.single(
            caseBuilders: {
              FlashcardSetStateType.loading: (_) => const CircularProgressIndicator(),
              FlashcardSetStateType.error: (_) => const AppErrorWidget(),
            },
            fallbackBuilder: (_) => EditableFlashcardListField(bloc: bloc),
            valueBuilder: (_) => state.type,
            context: context,
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context, LocaleBundle localeBundle) => TextFormField(
        onChanged: (text) => bloc.add(ChangeSetNameEvent(text)),
        decoration: InputDecoration(labelText: localeBundle.setNameLabel),
        controller: bloc.nameController,
        validator: (value) => FormUtils.requiredFieldValidator(localeBundle.setNameLabel, value),
      );
}
