// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get justNow => 'just now';

  @override
  String get minuteAgo => '1 minute ago';

  @override
  String minutesAgo(Object count) {
    return '$count minutes ago';
  }

  @override
  String get hourAgo => '1 hour ago';

  @override
  String hoursAgo(Object count) {
    return '$count hours ago';
  }

  @override
  String get dayAgo => '1 day ago';

  @override
  String daysAgo(Object count) {
    return '$count days ago';
  }

  @override
  String get monthAgo => '1 month ago';

  @override
  String monthsAgo(Object count) {
    return '$count months ago';
  }

  @override
  String get sec => 'sec';

  @override
  String get mins => 'min';

  @override
  String get hours => 'hours';
}
