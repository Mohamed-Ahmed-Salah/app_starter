abstract class ErrorConst {
  static const String noInternetMessageEn =
      'Connection Error. Please try again';
  static const String timeoutMessageEn = 'Request Timed out. Please try again';
  static const String unknowErrorEn = 'Something Went Wrong. Please Contact Support';
  static const String noInternetMessageAr =
      'خطأ في الاتصال. حاول مرة ثانية';
  static const String timeoutMessageAr = 'انتهت مهلة الطلب. حاول مرة ثانية';
  static const String unknowErrorAr = 'خطأ غير معروف. تواصل مع الدعم الفني';

// Parsing Errors
  static const String parsingErrorMessageEn =
      'We couldn’t load the information. Please try again or contact support if the issue continues.';

  static const String parsingErrorMessageAr =
      'تعذر تحميل المعلومات. يرجى المحاولة مرة أخرى أو التواصل مع الدعم إذا استمرت المشكلة.';

  static const int noInternet = 100;
  static const int timeout = 101;
  static const int parsingErrorCode = 102;
  static const int unknownStatusCode = 103;
  static const int unauthenticated = 401;
}
