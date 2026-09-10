import 'dart:io';

enum DataFailure {
  network,
  timeout,
  authentication,
  rateLimited,
  server,
  invalidData,
}

class ApiException implements HttpException {
  final int statusCode;
  final Duration? retryAfter;
  @override
  final String message;
  @override
  final Uri? uri;

  const ApiException(
    this.statusCode,
    this.message, {
    this.retryAfter,
    this.uri,
  });

  @override
  String toString() => message;
}
