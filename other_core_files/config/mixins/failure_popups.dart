import 'package:attendance/core/errors/error_const.dart';
import 'package:attendance/core/errors/exceptions.dart';
import 'package:attendance/core/errors/failures.dart';
import 'package:attendance/core/utils/util_functions.dart';

mixin FailurePopups {
  String getFailureMessage(Failure failure, bool isEn) {
    if (failure is GeneralFailure) {
      return "${failure.message} ${failure.statusCode} \n${failure.errors.join('\n')}";
    } else if (failure is NoInternetFailure) {
      String message = isEn
          ? ErrorConst.noInternetMessageEn
          : ErrorConst.noInternetMessageAr;
      return "$message ${failure.statusCode}";
    } else if (failure is FormatParserException ||
        failure is FormatParserFailure) {
      String message = isEn
          ? ErrorConst.parsingErrorMessageEn
          : ErrorConst.parsingErrorMessageAr;
      return "$message ${failure.statusCode}";
    } else if (failure is TimeOutFailure) {
      String message = isEn
          ? ErrorConst.timeoutMessageEn
          : ErrorConst.timeoutMessageEn;
      return "$message ${failure.statusCode}";
    } else {
      return "${failure.message} ${failure.statusCode}";
    }
  }

  String showToast(Failure failure, bool isEn) {
    final message = getFailureMessage(failure, isEn);
    UtilFunctions.showSnackBar(message: message);
    return message;
  }
}
