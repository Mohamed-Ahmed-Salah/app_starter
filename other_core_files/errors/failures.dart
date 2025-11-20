import 'package:equatable/equatable.dart';

import 'exceptions.dart';

///Each Exception has a failure type to handle and catch error for functional programming.
abstract class Failure extends Equatable {
  const Failure({
    required this.message,
    required this.statusCode,
    required this.errors,
  });

  final String message;
  final int statusCode;
  final List<String> errors;

  String get errorMessage => message;

  @override
  List<Object> get props => [message, statusCode];
}

class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    required super.statusCode,
    super.errors = const [],
  });

  ServerFailure.fromException(ServerException e)
    : this(message: e.message, statusCode: e.statusCode);
}

class UnauthenticatedFailure extends Failure {
  const UnauthenticatedFailure({
    required super.message,
    required super.statusCode,
    super.errors = const [],
  });

  UnauthenticatedFailure.fromException(UnauthenticatedException e)
    : this(message: e.message, statusCode: e.statusCode);
}

class NoInternetFailure extends Failure {
  const NoInternetFailure({
    required super.message,
    required super.statusCode,
    super.errors = const [],
  });

  NoInternetFailure.fromException(NoInternetException e)
    : this(message: e.message, statusCode: e.statusCode);
}

class TimeOutFailure extends Failure {
  const TimeOutFailure({
    required super.message,
    required super.statusCode,
    super.errors = const [],
  });

  TimeOutFailure.fromException(TimeOutException e)
    : this(message: e.message, statusCode: e.statusCode);
}

class FormatParserFailure extends Failure {
  const FormatParserFailure({
    required super.message,
    required super.statusCode,
    super.errors = const [],
  });

  FormatParserFailure.fromException(FormatParserException e)
    : this(message: e.message, statusCode: e.statusCode);
}

class GeneralFailure extends Failure {
  const GeneralFailure({
    required super.errors,
    required super.statusCode,
    super.message = 'Request failed',
  });

  GeneralFailure.fromException(GeneralException e)
    : this(message: e.message, statusCode: e.statusCode, errors: e.errors);

  // Convenient getter for displaying errors
  String get errorsAsString => errors.join('\n');

  // Get first error (useful for simple UI display)
  String get firstError => errors.isNotEmpty ? errors.first : message;

  @override
  List<Object> get props => [errors, message, statusCode];
}
