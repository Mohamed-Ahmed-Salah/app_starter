// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'التطبيق';

  @override
  String get errorNoInternet => 'خطأ في الاتصال. حاول مرة ثانية';

  @override
  String get errorParsing =>
      'تعذر تحميل المعلومات. يرجى المحاولة مرة أخرى أو التواصل مع الدعم إذا استمرت المشكلة.';

  @override
  String get errorTimeout => 'انتهت مهلة الطلب. حاول مرة ثانية';

  @override
  String get errorUnknown => 'خطأ غير معروف. تواصل مع الدعم الفني';

  @override
  String get requiredField => 'هذا الحقل مطلوب';

  @override
  String get fieldOnlyNumbers => 'يجب أن يحتوي هذا الحقل على أرقام فقط';

  @override
  String get onlyNineNumber => 'يجب أن يحتوي هذا الحقل على 9 أرقام';

  @override
  String get amountMustBePositive => 'أدخل مبلغًا أكبر من صفر';

  @override
  String get amountExceedsBalance => 'المبلغ يتجاوز رصيدك المتاح';

  @override
  String get enterValidEmail => 'يرجى إدخال البريد الإلكتروني الصحيح';

  @override
  String get enterFullName => 'الرجاء إدخال الاسم الكامل';

  @override
  String get enterValidFullName => 'الرجاء إدخال الاسم الكامل الصحيح';

  @override
  String get enterNameWithNoNumber => 'يرجى إدخال اسم كامل بدون أي أرقام';

  @override
  String get passwordTooShort =>
      'يجب أن تتكون كلمة المرور من 8 أحرف على الأقل.';

  @override
  String get passwordMissingNumber =>
      'يجب أن تحتوي كلمة المرور على رقم واحد على الأقل.';

  @override
  String get passwordEnOnly => 'يجب أن يحتوي هذا الحقل على أحرف إنجليزية فقط.';

  @override
  String get passwordConfirmationMessage =>
      'كلمتا المرور غير متطابقتين. يرجى المحاولة مرة أخرى.';

  @override
  String get failureDialogTitle => 'عذراً';

  @override
  String get warningDialogTitle => 'تنبيه';

  @override
  String get infoDialogTitle => 'انتبه';

  @override
  String get products => 'المنتجات';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get couldntStartApp => 'تعذر تشغيل التطبيق. يرجى المحاولة مرة أخرى.';

  @override
  String get updateRequiredTitle => 'التحديث مطلوب';

  @override
  String get updateRequiredBody =>
      'هذا الإصدار لم يعد مدعومًا. يرجى التحديث للمتابعة.';

  @override
  String get updateNow => 'تحديث الآن';

  @override
  String get onboardingTitle => 'مرحبًا';

  @override
  String get getStarted => 'ابدأ';

  @override
  String get languageTitle => 'اللغة';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';
}
