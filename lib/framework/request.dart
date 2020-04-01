import 'package:dio/dio.dart';
import 'package:flutterdemo/framework/config.dart';
import 'package:flutterdemo/framework/private_cookie_manager.dart';
import 'package:flutterdemo/framework/toast.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';

Dio dio = Dio();

Future<Map> request(String url,
    {Options options, Map data, String errorMessage}) async {
  CookieJar cookieJar = CookieJar();
  dio.interceptors.add(PrivateCookieManager(cookieJar));
  try {
    var opt = Options(
        method: 'post', receiveTimeout: 1000 * 5, sendTimeout: 1000 * 5);

    if (options != null) {
      opt.merge(
        method: options.method,
        receiveTimeout: options.receiveTimeout,
        sendTimeout: options.sendTimeout,
      );
    }

    Response response =
        await dio.request('${AppConfig.host}$url', data: data, options: opt);
    if (response.data['success']) {
      return response.data['data'];
    }
    showToast(errorMessage ?? response.data['message']);
    return null;
  } on DioError catch (e) {
    String msg;
    switch (e.type) {
      case DioErrorType.CONNECT_TIMEOUT:
      case DioErrorType.SEND_TIMEOUT:
      case DioErrorType.RECEIVE_TIMEOUT:
        msg = '连接超时，请检查网络设置！';
        break;
      case DioErrorType.RESPONSE:
      default:
        msg = '[${e.response?.statusCode ?? 0}]糟糕，出错了！但是你要相信开发会及时解决的。';
        print('error');
        print(e);
    }
    showToast(msg);
    return null;
  }
}
