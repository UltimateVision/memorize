import 'package:flutter/material.dart';
import 'package:memorize/i18n/localization.dart';

class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const Color color = Colors.lightBlueAccent;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.sentiment_dissatisfied,
            size: 96.0,
            color: color,
          ),
          const SizedBox(
            height: 16.0,
          ),
          Text(
            Localization.of(context).bundle.appError,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.caption?.copyWith(color: color),
          ),
        ],
      ),
    );
  }

}