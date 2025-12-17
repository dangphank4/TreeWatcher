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

  @override
  String get weather => 'Weather';

  @override
  String get user => 'User';

  @override
  String get changePassword => 'Change Password';

  @override
  String get logOut => 'Log Out';

  @override
  String get pleaseEnterAValidEmail => 'Please enter a valid email';

  @override
  String get forgotPassword => 'Forgot password';

  @override
  String get email => 'Email';

  @override
  String get sendRequest => 'Send request';

  @override
  String get enterEmailToResetPassword => 'Enter email to reset password';

  @override
  String get register => 'Register';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get pleaseEnterRightPassword => 'Please enter right password';

  @override
  String get pleaseEnterCompleteInformation =>
      'Please enter complete information';

  @override
  String get youHaveAnAccount => 'You have an account? SignIn';

  @override
  String get logIn => 'LogIn';

  @override
  String get createAnAccount => 'Create an account';

  @override
  String get newPasswordDoesNotMatch => 'New password doesn\'t match';

  @override
  String get resetPasswordSuccess => 'Reset password successful';

  @override
  String get resetPassword => 'Reset pasword';

  @override
  String get oldPassword => 'Old password';

  @override
  String get newPassword => 'New password';

  @override
  String get newPasswordConfirm => 'Confirm new pasword';

  @override
  String get max => 'Max';

  @override
  String get min => 'Min';

  @override
  String get wind => 'Wind';

  @override
  String get precipitation => 'Precipitation';

  @override
  String get uvIndex => 'UV Index';

  @override
  String get cantLoadWeatherData => 'Can\'t load weather data';

  @override
  String get enteAreaName => 'Enter area name';

  @override
  String get area => 'Area';
}
