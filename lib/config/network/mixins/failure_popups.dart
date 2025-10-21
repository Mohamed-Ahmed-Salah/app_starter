import 'package:app_starter/config/errors/error_const.dart';
import 'package:app_starter/config/errors/failures.dart';

mixin FailurePopups{
  String getFailureMessage(Failure failure, bool isEn) {
    if (failure is GeneralFailure) {
      return "${failure.message} ${failure.statusCode} \n${failure.errors.join('\n')}";
    } else if (failure is NoInternetFailure) {
      String message = isEn
          ? ErrorConst.noInternetMessageEn
          : ErrorConst.noInternetMessageAr;
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

  void showToast(Failure failure, bool isEn) {
    final message = getFailureMessage(failure, isEn);
    // UtilFunctions.showSnackBar(message: message);
  }
}