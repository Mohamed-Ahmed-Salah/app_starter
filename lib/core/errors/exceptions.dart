import 'package:equatable/equatable.dart';

class ServerException extends Equatable implements Exception {
  const ServerException({
    required this.message,
    required this.statusCode,
    this.stackTrace,
  });

  final StackTrace? stackTrace;
  final String message;
  final int statusCode;

  @override
  List<Object> get props => [message, statusCode];
}

/// Exception thrown when the user does not have an internet connection
class NoInternetException extends Equatable implements Exception {
  const NoInternetException({
    required this.message,
    required this.statusCode,
    this.stackTrace,
  });

  final String message;
  final int statusCode;
  final StackTrace? stackTrace;

  @override
  List<Object?> get props => [message, statusCode];
}

/// Exception thrown when a request exceeds its timeout
class TimeOutException extends Equatable implements Exception {
  const TimeOutException({
    required this.message,
    required this.statusCode,
    this.stackTrace,
  });

  final String message;
  final int statusCode;
  final StackTrace? stackTrace;

  @override
  List<Object?> get props => [message, statusCode];
}

class FormatParserException extends Equatable implements Exception {
  const FormatParserException({
    required this.message,
    required this.statusCode,
    this.stackTrace,
  });

  final String message;
  final int statusCode;
  final StackTrace? stackTrace;

  @override
  List<Object?> get props => [message, statusCode];
}

class UnauthenticatedException extends Equatable implements Exception {
  const UnauthenticatedException({
    required this.message,
    required this.statusCode,
    this.stackTrace,
  });

  final String message;
  final int statusCode;
  final StackTrace? stackTrace;

  @override
  List<Object?> get props => [message, statusCode];
}

class GeneralException extends Equatable implements Exception {
  const GeneralException({
    required this.errors,
    required this.statusCode,
    this.message = 'Validation failed',
    this.stackTrace,
  });

  final List<String> errors;
  final int statusCode;
  final String message;
  final StackTrace? stackTrace;

  @override
  List<Object> get props => [errors, statusCode, message];
}

class AuthException extends Equatable implements Exception {
  const AuthException({
    required this.message,
    required this.statusCode,
    this.stackTrace,
  });

  final String message;
  final int statusCode;
  final StackTrace? stackTrace;

  @override
  List<Object?> get props => [message, statusCode];
}

class AuthCancelledByUserException extends Equatable implements Exception {
  const AuthCancelledByUserException({this.stackTrace});

  final StackTrace? stackTrace;

  @override
  List<Object?> get props => [];
}
