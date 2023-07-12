import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CustomInterceptor extends Interceptor {
// 1.요청을 보낼때
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print("[REQ] [${options.method}] [${options.uri}]");
    return super.onRequest(options, handler);
  }

// 2.응답을 받을떄

// 3.에러가 발생했을때
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    //만약 1일 트래픽 허용량을 초과해서 데이터를 가져오지 못할때
    //flutterSecureStorage에 저장해둔 과거의 데이터를 반환해준다
    const storage = FlutterSecureStorage();
    print("만약 1일 트래픽 허용량을 초과");
    print("[ERR] [${err.requestOptions.method}] [${err.requestOptions.uri}]");
    return super.onError(err, handler);
  }
}
