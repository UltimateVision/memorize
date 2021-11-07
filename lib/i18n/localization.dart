import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:memorize/i18n/locale_bundle.dart';

class Localization {
  Localization(this.locale);

  final Locale locale;

  static Localization of(BuildContext context) {
    Localization? localization = Localizations.of<Localization>(context, Localization);
    if (localization != null) {
      return localization;
    }

    throw Exception('Missing localization!');
  }

  static final Map<String, LocaleBundle> _localizedValues = {
    'en': LocaleBundleEn(),
  };

  LocaleBundle get bundle {
    return _localizedValues[locale.languageCode] ?? LocaleBundleEn();
  }
}


class LocalizationDelegate extends LocalizationsDelegate<Localization> {
  static const List<Locale> supportedLocales = [Locale('en')];

  const LocalizationDelegate();

  @override
  bool isSupported(Locale locale) => supportedLocales.map((e) => e.languageCode).contains(locale.languageCode);

  @override
  Future<Localization> load(Locale locale) {
    return SynchronousFuture<Localization>(Localization(locale));
  }

  @override
  bool shouldReload(LocalizationDelegate old) => false;
}
