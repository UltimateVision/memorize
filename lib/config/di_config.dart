import 'package:get_it/get_it.dart';
import 'package:memorize/config/navigation.dart';
import 'package:memorize/repository/flashcard_set_repository.dart';

var locator = GetIt.instance;

class LocatorConfig {

  static void init() {
    locator.registerSingleton<FlashcardSetRepository>(FlashcardSetRepository());
    locator.registerSingleton<MemorizeNavigator>(MemorizeNavigator());

    _postInit();
  }

  static void _postInit() {
    locator.get<FlashcardSetRepository>().initDummySet();
  }

}