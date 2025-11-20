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

/// Exception thrown when the  user does not have an internet connection
class NoInternetException extends Equatable implements Exception {
  final String message;
  final int statusCode;
  final StackTrace? stackTrace;

  const NoInternetException({
    required this.message,
    this.stackTrace,
    required this.statusCode,
  });

  // TODO: implement props
  @override
  List<Object?> get props => [message, statusCode];
}

/// Exception thrown when the  user does not have an internet connection
class TimeOutException extends Equatable implements Exception {
  final String message;
  final StackTrace? stackTrace;

  final int statusCode;

  const TimeOutException({
    required this.message,
    this.stackTrace,
    required this.statusCode,
  });

  // TODO: implement props
  @override
  List<Object?> get props => [message, statusCode];
}

class FormatParserException extends Equatable implements Exception {
  final String message;
  final StackTrace? stackTrace;

  final int statusCode;

  const FormatParserException({
    required this.message,
    this.stackTrace,
    required this.statusCode,
  });

  // TODO: implement props
  @override
  List<Object?> get props => [message, statusCode];
}

class UnauthenticatedException extends Equatable implements Exception {
  final String message;
  final StackTrace? stackTrace;

  final int statusCode;

  const UnauthenticatedException({
    required this.message,
    this.stackTrace,
    required this.statusCode,
  });

  // TODO: implement props
  @override
  List<Object?> get props => [message, statusCode];
}

class GeneralException extends Equatable implements Exception {
  const GeneralException({
    this.stackTrace,
    required this.errors,
    required this.statusCode,
    this.message = 'Validation failed',
  });

  final StackTrace? stackTrace;

  final List<String> errors;
  final int statusCode;
  final String message;

  @override
  List<Object> get props => [errors, statusCode, message];
}
