abstract class ErrorConst {
  static const String noInternetMessageEn =
      'Connection Error. Please try again';
  static const String timeoutMessageEn = 'Request Timed out. Please try again';
  static const String unknowErrorEn = 'Unknown Error. Please Contact Support';
  static const String noInternetMessageAr =
      'خطأ في الاتصال. حاول مرة ثانية';
  static const String timeoutMessageAr = 'انتهت مهلة الطلب. حاول مرة ثانية';
  static const String unknowErrorAr = 'خطأ غير معروف. تواصل مع الدعم الفني';

  static const int noInternet = 100;
  static const int timeout = 101;
  static const int parsingErrorCode = 102;
  static const int unknownStatusCode = 199;
}
