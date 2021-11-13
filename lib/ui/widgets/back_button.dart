import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memorize/config/di_config.dart';
import 'package:memorize/config/navigation.dart';

class BackButton extends StatelessWidget {
  final MemorizeNavigator _navigator = locator.get();

  @override
  Widget build(BuildContext context) => IconButton(
        icon: Icon(Icons.chevron_left),
        onPressed: () => _navigator.pop(),
      );
}
