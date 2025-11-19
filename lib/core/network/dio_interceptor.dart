import 'package:dio/dio.dart';
import 'package:flutter_api/core/helpers/generalHeper.dart';
import 'package:flutter_api/core/utils/globals.dart';
import 'package:flutter_api/core/utils/utils.dart';

class DioInterceptor extends Interceptor {
  final Dio dio;

  DioInterceptor({required this.dio});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // options.headers['Device-Id'] = GeneralHelper.deviceId;
    // options.headers['App-Version'] = GeneralHelper.appVersion;
    // options.headers['OS-Info'] = GeneralHelper.osInfo;
    // options.headers['Device-Info'] = GeneralHelper.deviceInfo;
    // options.headers['OS-Version'] = GeneralHelper.osVersion;

    options.headers['Accept-Language'] = GeneralHelper.deviceLanguageCode;
    options.headers['device-uuid'] = Globals.globalUuid;
    options.headers['device-name'] = GeneralHelper.deviceModel;
    options.headers['app-version'] = GeneralHelper.appVersion;
    options.headers['build-number'] = GeneralHelper.buildNumber;
    options.headers['os'] = GeneralHelper.osInfo.toUpperCase();
    options.headers['device-type'] = GeneralHelper.osInfo.toUpperCase();
    options.headers['os-version'] = GeneralHelper.osVersion;
    options.headers['mode'] = 'mobile';
    options.headers['accept-encoding'] =
        options.headers['accept-encoding'] ?? 'gzip';
    options.headers['content-type'] =
        options.headers['content-type'] ?? 'application/json';

    if (options.extra['noAuth'] != true) {
      if (Globals.globalAccessToken != null) {
        options.headers['Authorization'] = '${Globals.globalAccessToken}';
      }
    }

    options.headers['notification-token'] = Globals.globalFcmToken;
    options.headers['flavor'] = GeneralHelper.appFlavor;

    if (options.extra['noAuth'] != true) {
      if (Globals.globalUserId != null) {
        options.headers['userid'] = Globals.globalUserId;
      }
    }

    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    Utils.debugLogSuccess(
      '${response.requestOptions.method} ${response.requestOptions.path} body:${response.requestOptions.data} query:${response.requestOptions.queryParameters}',
    );

    final statusCode = response.statusCode.toString();

    // only handle if response is json
    if (response.data is! Map<String, dynamic>) {
      return handler.next(response);
    }
    final Map<String, dynamic> mapData = response.data;
    final isError = mapData['result'] == 'failed';
    //get extra from request.options?
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    Utils.debugLogError(
      '${err.requestOptions.method} ${err.requestOptions.path} body:${err.requestOptions.data} query:${err.requestOptions.queryParameters} status:${err.response?.statusCode?.toString()} error:${err.response?.data}',
    );

    // check if 401 or 403, remove token and navigate to login
    if (err.response?.statusCode == 401 || err.response?.statusCode == 403) {
      Utils.debugLogError('Unauthorized');
    }

    return handler.reject(err);
  }
}
