/// CustomException encapsulates low-level errors raised at data source levels.
class CustomException implements Exception {
  final String message;
  final int? statusCode;

  const CustomException(this.message, {this.statusCode});

  @override
  String toString() => 'CustomException: $message (Status: $statusCode)';
}

class NetworkException extends CustomException {
  const NetworkException([super.message = 'Network connection issue.']);
}

class ServerException extends CustomException {
  const ServerException([super.message = 'Internal server error.', int? statusCode])
      : super(statusCode: statusCode);
}

class AuthException extends CustomException {
  const AuthException([super.message = 'Session expired or invalid credentials.', int? statusCode])
      : super(statusCode: statusCode);
}

class ValidationException extends CustomException {
  const ValidationException(super.message, {super.statusCode = 400});
}