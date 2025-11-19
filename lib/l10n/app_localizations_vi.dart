// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get justNow => 'vừa xong';

  @override
  String get minuteAgo => '1 phút trước';

  @override
  String minutesAgo(Object count) {
    return '$count phút trước';
  }

  @override
  String get hourAgo => '1 giờ trước';

  @override
  String hoursAgo(Object count) {
    return '$count giờ trước';
  }

  @override
  String get dayAgo => '1 ngày trước';

  @override
  String daysAgo(Object count) {
    return '$count ngày trước';
  }

  @override
  String get monthAgo => '1 tháng trước';

  @override
  String monthsAgo(Object count) {
    return '$count tháng trước';
  }

  @override
  String get sec => 'giây';

  @override
  String get mins => 'phút';

  @override
  String get hours => 'giờ';
}
