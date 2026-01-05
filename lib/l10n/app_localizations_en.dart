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

  @override
  String get updateUser => 'Update user';

  @override
  String get confirm => 'Confirm';

  @override
  String get areYouReallyWantToChangePassword =>
      'Are you really want to change password';

  @override
  String get areYouReallyWantToChangeAccountInfo =>
      'Are you really want to change account information';

  @override
  String get delete => 'Delete';

  @override
  String get accept => 'Accept';

  @override
  String get updateAccount => 'Update Account';

  @override
  String get fullName => 'Full Name';

  @override
  String get enterYourFullName => 'Enter your full name';

  @override
  String get emailHint => 'Your email address';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get phoneHint => 'Enter your phone number';

  @override
  String get gender => 'Gender';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get save => 'Save';

  @override
  String get accountTitle => 'My Account';

  @override
  String get addNewDevice => 'Add New Device';

  @override
  String get scanQr => 'Scan QR Code';

  @override
  String get scanQrDesc =>
      'Move the camera to the QR code on the device to identify it';

  @override
  String get manualInput => 'Or enter manually';

  @override
  String get deviceId => 'Device ID';

  @override
  String get deviceName => 'Device nickname';

  @override
  String get connectDevice => 'Connect device';

  @override
  String get scan => 'Scan';

  @override
  String get deviceListTitle => 'Device List';

  @override
  String get goodMorning => 'Good morning';

  @override
  String get welcomeBackMessage =>
      'Welcome back!\nHere you can manage and monitor your devices.';

  @override
  String get addDevice => 'Add device';

  @override
  String deviceIdLabel(Object deviceId) {
    return 'ID: $deviceId';
  }

  @override
  String get retry => 'Retry';

  @override
  String get deviceDetailTitle => 'Device Details';
}
