
import 'package:app_starter/config/errors/error_const.dart';
import 'package:app_starter/config/errors/failures.dart';

mixin FailurePopups{
  void showToast(Failure failure , bool isEn){
    if (failure is GeneralFailure) {
      // UtilFunctions.showSnackBar(
      //   message:
      //   "${failure.message} ${failure.statusCode} \n${failure.errors.join('\n')}",
      // );
    } else if (failure is NoInternetFailure) {
      String message = isEn
          ? ErrorConst.noInternetMessageEn
          : ErrorConst.noInternetMessageAr;
      // UtilFunctions.showSnackBar(message: "$message ${failure.statusCode}");
    } else if (failure is TimeOutFailure) {
      String message = isEn
          ? ErrorConst.timeoutMessageEn
          : ErrorConst.timeoutMessageEn;
      // UtilFunctions.showSnackBar(message: "$message ${failure.statusCode}");
    } else {
      // UtilFunctions.showSnackBar(
      //   message: "${failure.message} ${failure.statusCode}",
      // );
    }
  }
}