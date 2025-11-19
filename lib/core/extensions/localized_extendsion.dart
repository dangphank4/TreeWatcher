import 'package:flutter/cupertino.dart';
import 'package:flutter_api/l10n/app_localizations.dart';

extension LocalizedExtension on BuildContext {
  AppLocalizations get  localization => AppLocalizations.of(this)!;
}
