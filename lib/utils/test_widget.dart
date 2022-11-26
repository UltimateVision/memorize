import 'package:flutter/material.dart';
import 'package:memorize/config/navigation.dart';
import 'package:memorize/i18n/localization.dart';

class TestWidget extends StatelessWidget {

  final Widget child;

  const TestWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: const [
        LocalizationDelegate(),
      ],
      supportedLocales: LocalizationDelegate.supportedLocales,
      navigatorKey: MemorizeNavigator.navigatorKey,
      home: child,
    );
  }

}