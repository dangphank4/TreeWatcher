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

  @override
  String get weather => 'Thời tiết';

  @override
  String get user => 'Người dùng';

  @override
  String get changePassword => 'Đổi mật khẩu';

  @override
  String get logOut => 'Đăng xuất';

  @override
  String get pleaseEnterAValidEmail => 'Vui lòng nhập email hợp lệ';

  @override
  String get forgotPassword => 'Quên mật khẩu';

  @override
  String get email => 'Email';

  @override
  String get sendRequest => 'Gửi yêu cầu';

  @override
  String get enterEmailToResetPassword =>
      'Nhập email để nhận link đặt lại mật khẩu';

  @override
  String get register => 'Đăng ký';

  @override
  String get password => 'Mật khẩu';

  @override
  String get confirmPassword => 'Nhập lại mật khẩu';

  @override
  String get pleaseEnterRightPassword => 'Vui lòng nhập đúng mật khẩu';

  @override
  String get pleaseEnterCompleteInformation => 'Vui lòng nhập đủ thông tin';

  @override
  String get youHaveAnAccount => 'Bạn đã có tài khoản? Đăng nhập';

  @override
  String get logIn => 'Đăng nhập';

  @override
  String get createAnAccount => 'Tạo tài khoản';

  @override
  String get newPasswordDoesNotMatch => 'Mật khẩu mới không khớp';

  @override
  String get resetPasswordSuccess => 'Đặt lại mật khẩu thành công';

  @override
  String get resetPassword => 'Đặt lại mật khẩu';

  @override
  String get oldPassword => 'Mật khẩu cũ';

  @override
  String get newPassword => 'Mật khẩu mới';

  @override
  String get newPasswordConfirm => 'Xác nhận mật khẩu mới';

  @override
  String get max => 'Tối đa';

  @override
  String get min => 'Tối thiểu';

  @override
  String get wind => 'Tốc độ gió';

  @override
  String get precipitation => 'Lượng mưa';

  @override
  String get uvIndex => 'Tia UV';

  @override
  String get cantLoadWeatherData => 'Không thể tải dữ liệu thời tiết';

  @override
  String get enteAreaName => 'Nhập tên khu vực';

  @override
  String get area => 'Địa điểm';

  @override
  String get updateUser => 'Cập nhật thông tin';

  @override
  String get confirm => 'Xác nhận';

  @override
  String get areYouReallyWantToChangePassword =>
      'Bạn có chắc chắn muốn đổi mật khẩu không';

  @override
  String get areYouReallyWantToChangeAccountInfo =>
      'Bạn có chắc chắn muốn đổi thông tin tài khoản không';

  @override
  String get delete => 'Huỷ';

  @override
  String get accept => 'Đồng ý';

  @override
  String get updateAccount => 'Cập nhật tài khoản';

  @override
  String get fullName => 'Họ và tên';

  @override
  String get enterYourFullName => 'Nhập họ và tên';

  @override
  String get emailHint => 'Địa chỉ email của bạn';

  @override
  String get phoneNumber => 'Số điện thoại';

  @override
  String get phoneHint => 'Nhập số điện thoại';

  @override
  String get gender => 'Giới tính';

  @override
  String get male => 'Nam';

  @override
  String get female => 'Nữ';

  @override
  String get save => 'Lưu';

  @override
  String get accountTitle => 'Tài khoản của tôi';
}
