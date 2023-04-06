import '../constant/strings.dart';

class AppException implements Exception {
  String message;

  AppException({required this.message});

  AppException.internalError() : message = DEFAULT_ERROR;

  AppException.message(String errorMessage) : message = errorMessage;

  @override
  String toString() => message;
}
