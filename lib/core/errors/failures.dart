/// Failure classes encapsulate failures that occur in domain/business layers.
abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No Internet connection. Please check your network.']);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'A server error occurred. Please try again later.']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Failed to load local data.']);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed. Please check credentials.']);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'An unexpected error occurred. Please try again.']);
}