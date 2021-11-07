import 'package:flutter/material.dart';
import 'package:memorize/ui/pages/flashcard_set_edit_page.dart';
import 'package:memorize/ui/pages/flashcard_set_page.dart';

class MemorizeNavigator {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Future<dynamic> push(MaterialPageRoute route) => navigatorKey.currentState?.push(route) ?? Future.value(null);

  static void pop() => navigatorKey.currentState?.pop();

  static MaterialPageRoute openSet(String name) => MaterialPageRoute(
        builder: (_) => FlashcardSetPage(name),
        settings: RouteSettings(name: '/set/open'),
      );

  static MaterialPageRoute editSet(String id, String name) => MaterialPageRoute(
        builder: (_) => FlashcardSetEditPage.edit(id, name),
        settings: RouteSettings(name: '/set/edit'),
      );

  static MaterialPageRoute createSet() => MaterialPageRoute(
        builder: (_) => FlashcardSetEditPage.create(),
        settings: RouteSettings(name: '/set/edit'),
      );
}
