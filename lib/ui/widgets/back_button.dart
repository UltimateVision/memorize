import 'package:flutter/material.dart';
import 'package:memorize/config/di_config.dart';
import 'package:memorize/config/navigation.dart';

class BackButton extends StatelessWidget {
  final MemorizeNavigator _navigator = locator.get();

  BackButton({super.key});

  @override
  Widget build(BuildContext context) => IconButton(
        icon: const Icon(Icons.chevron_left),
        onPressed: () => _navigator.pop(),
      );
}
