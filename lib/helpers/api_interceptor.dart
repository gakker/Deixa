import 'dart:developer';

import 'package:dio/dio.dart';

class AppInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log(options.path);
    log(options.data?.toString() ?? "");
    super.onRequest(options, handler);
  }
}
