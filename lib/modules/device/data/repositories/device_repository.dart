import '../../../../core/helpers/timeout_helper.dart';
import '../datasource/device_api.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class Result<T> {
  final T? data;
  final String? error;

  const Result._({this.data, this.error});

  factory Result.success([T? data]) => Result._(data: data);
  factory Result.failure(String message) => Result._(error: message);

  bool get isSuccess => error == null;
}

class DeviceRepository {
  final DeviceApi api;
  DeviceRepository({required this.api});

  static const int defaut_timeout = 5;

  Future<Result<void>> registerDevice({
    required String userId,
    required String deviceId,
    required String deviceName,
    required String password,
  }) async {
    try {
      await TimeoutHelper.run(
        api.registerDevice(
          userId: userId,
          deviceId: deviceId,
          deviceName: deviceName,
          password: password,
        ),
        duration: const Duration(seconds: defaut_timeout),
        timeoutMessage: 'Kết nối quá lâu, vui lòng thử lại',
      );

      return Result.success();
    } on DeviceException catch (e) {
      return Result.failure(e.message);
    } on TimeoutException catch (e) {
      return Result.failure(e.message ?? 'Timeout');
    } on FirebaseException catch (e) {
      return Result.failure(_mapFirebaseError(e));
    } catch (_) {
      return Result.failure('Đăng ký thiết bị thất bại');
    }
  }


  Future<Result<List<Map<String, dynamic>>>> getDevices(
      String userId,
      ) async {
    try {
      final devices = await TimeoutHelper.run(
        api.getDevices(userId),
        duration: const Duration(seconds: defaut_timeout),
      );

      return Result.success(devices);
    } on TimeoutException {
      return Result.failure('Tải danh sách thiết bị bị timeout');
    } on FirebaseException catch (e) {
      return Result.failure(_mapFirebaseError(e));
    } catch (_) {
      return Result.failure('Không thể tải danh sách thiết bị');
    }
  }


  Future<Result<void>> renameDevice({
    required String userId,
    required String deviceId,
    required String newName,
  }) async {
    try {
      await TimeoutHelper.run(
        api.renameDevice(
          userId: userId,
          deviceId: deviceId,
          newName: newName,
        ),
        duration: const Duration(seconds: defaut_timeout),
      );

      return Result.success();
    } on TimeoutException {
      return Result.failure('Đổi tên thiết bị bị timeout');
    } on FirebaseException catch (e) {
      return Result.failure(_mapFirebaseError(e));
    } catch (_) {
      return Result.failure('Đổi tên thiết bị thất bại');
    }
  }


  Future<Result<void>> deleteDevice({
    required String userId,
    required String deviceId,
  }) async {
    try {
      await TimeoutHelper.run(
        api.deleteDevice(
          userId: userId,
          deviceId: deviceId,
        ),
        duration: const Duration(seconds: defaut_timeout),
      );

      return Result.success();
    } on TimeoutException {
      return Result.failure('Xoá thiết bị bị timeout');
    } on FirebaseException catch (e) {
      return Result.failure(_mapFirebaseError(e));
    } catch (_) {
      return Result.failure('Xoá thiết bị thất bại');
    }
  }


  String _mapFirebaseError(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return 'Bạn không có quyền thực hiện thao tác này';
      case 'unavailable':
        return 'Không có kết nối mạng';
      case 'not-found':
        return 'Dữ liệu không tồn tại';
      case 'already-exists':
        return 'Thiết bị đã tồn tại';
      default:
        return 'Lỗi Firebase (${e.code})';
    }
  }
}
