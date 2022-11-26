import 'package:flutter/material.dart';
import 'package:memorize/config/di_config.dart';
import 'package:memorize/config/hive_config.dart';
import 'package:memorize/config/navigation.dart';
import 'package:memorize/i18n/localization.dart';
import 'package:memorize/ui/pages/flashcard_set_list_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveConfig.init();
  LocatorConfig.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: const [
        LocalizationDelegate(),
      ],
      supportedLocales: LocalizationDelegate.supportedLocales,
      navigatorKey: MemorizeNavigator.navigatorKey,
      home: FlashcardSetListPage(),
      // home: FlashcardSetPage('dummy'),
    );
  }
}
