import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en', 'US'),
    Locale('ar', 'SA'),
  ];

  // Welcome Screen
  String get welcomeTitle => locale.languageCode == 'ar' ? 'مرحباً بك في Bix' : 'Welcome to Bix';
  String get welcomeSubtitle => locale.languageCode == 'ar' 
      ? 'شارك لحظاتك مع العالم من خلال الفيديوهات القصيرة' 
      : 'Share your moments with the world through short videos';

  // Authentication
  String get login => locale.languageCode == 'ar' ? 'تسجيل الدخول' : 'Login';
  String get register => locale.languageCode == 'ar' ? 'إنشاء حساب' : 'Register';
  String get guest => locale.languageCode == 'ar' ? 'ضيف' : 'Guest';
  String get email => locale.languageCode == 'ar' ? 'البريد الإلكتروني' : 'Email';
  String get password => locale.languageCode == 'ar' ? 'كلمة المرور' : 'Password';
  String get confirmPassword => locale.languageCode == 'ar' ? 'تأكيد كلمة المرور' : 'Confirm Password';
  String get username => locale.languageCode == 'ar' ? 'اسم المستخدم' : 'Username';
  String get displayName => locale.languageCode == 'ar' ? 'الاسم المعروض' : 'Display Name';
  String get phoneNumber => locale.languageCode == 'ar' ? 'رقم الهاتف' : 'Phone Number';
  String get forgotPassword => locale.languageCode == 'ar' ? 'نسيت كلمة المرور؟' : 'Forgot Password?';
  String get signInWithGoogle => locale.languageCode == 'ar' ? 'تسجيل الدخول بجوجل' : 'Sign in with Google';
  String get signInWithPhone => locale.languageCode == 'ar' ? 'تسجيل الدخول بالهاتف' : 'Sign in with Phone';
  String get continueAsGuest => locale.languageCode == 'ar' ? 'المتابعة كضيف' : 'Continue as Guest';

  // Navigation
  String get home => locale.languageCode == 'ar' ? 'الرئيسية' : 'Home';
  String get search => locale.languageCode == 'ar' ? 'البحث' : 'Search';
  String get create => locale.languageCode == 'ar' ? 'إنشاء' : 'Create';
  String get messages => locale.languageCode == 'ar' ? 'الرسائل' : 'Messages';
  String get profile => locale.languageCode == 'ar' ? 'الملف الشخصي' : 'Profile';

  // Settings
  String get settings => locale.languageCode == 'ar' ? 'الإعدادات' : 'Settings';
  String get language => locale.languageCode == 'ar' ? 'اللغة' : 'Language';
  String get theme => locale.languageCode == 'ar' ? 'المظهر' : 'Theme';
  String get darkMode => locale.languageCode == 'ar' ? 'الوضع المظلم' : 'Dark Mode';
  String get lightMode => locale.languageCode == 'ar' ? 'الوضع الفاتح' : 'Light Mode';
  String get systemMode => locale.languageCode == 'ar' ? 'وضع النظام' : 'System Mode';
  String get notifications => locale.languageCode == 'ar' ? 'الإشعارات' : 'Notifications';
  String get privacy => locale.languageCode == 'ar' ? 'الخصوصية' : 'Privacy';
  String get security => locale.languageCode == 'ar' ? 'الأمان' : 'Security';
  String get about => locale.languageCode == 'ar' ? 'حول التطبيق' : 'About';
  String get logout => locale.languageCode == 'ar' ? 'تسجيل الخروج' : 'Logout';

  // Profile
  String get editProfile => locale.languageCode == 'ar' ? 'تعديل الملف الشخصي' : 'Edit Profile';
  String get followers => locale.languageCode == 'ar' ? 'المتابعون' : 'Followers';
  String get following => locale.languageCode == 'ar' ? 'المتابَعون' : 'Following';
  String get posts => locale.languageCode == 'ar' ? 'المنشورات' : 'Posts';
  String get bio => locale.languageCode == 'ar' ? 'النبذة الشخصية' : 'Bio';

  // Actions
  String get save => locale.languageCode == 'ar' ? 'حفظ' : 'Save';
  String get cancel => locale.languageCode == 'ar' ? 'إلغاء' : 'Cancel';
  String get delete => locale.languageCode == 'ar' ? 'حذف' : 'Delete';
  String get edit => locale.languageCode == 'ar' ? 'تعديل' : 'Edit';
  String get share => locale.languageCode == 'ar' ? 'مشاركة' : 'Share';
  String get like => locale.languageCode == 'ar' ? 'إعجاب' : 'Like';
  String get comment => locale.languageCode == 'ar' ? 'تعليق' : 'Comment';
  String get follow => locale.languageCode == 'ar' ? 'متابعة' : 'Follow';
  String get unfollow => locale.languageCode == 'ar' ? 'إلغاء المتابعة' : 'Unfollow';

  // Messages
  String get typeMessage => locale.languageCode == 'ar' ? 'اكتب رسالة...' : 'Type a message...';
  String get send => locale.languageCode == 'ar' ? 'إرسال' : 'Send';
  String get online => locale.languageCode == 'ar' ? 'متصل' : 'Online';
  String get offline => locale.languageCode == 'ar' ? 'غير متصل' : 'Offline';

  // Errors
  String get error => locale.languageCode == 'ar' ? 'خطأ' : 'Error';
  String get success => locale.languageCode == 'ar' ? 'نجح' : 'Success';
  String get loading => locale.languageCode == 'ar' ? 'جاري التحميل...' : 'Loading...';
  String get noInternetConnection => locale.languageCode == 'ar' 
      ? 'لا يوجد اتصال بالإنترنت' 
      : 'No internet connection';
  String get somethingWentWrong => locale.languageCode == 'ar' 
      ? 'حدث خطأ ما' 
      : 'Something went wrong';

  // Validation
  String get fieldRequired => locale.languageCode == 'ar' ? 'هذا الحقل مطلوب' : 'This field is required';
  String get invalidEmail => locale.languageCode == 'ar' ? 'بريد إلكتروني غير صحيح' : 'Invalid email';
  String get passwordTooShort => locale.languageCode == 'ar' 
      ? 'كلمة المرور قصيرة جداً' 
      : 'Password is too short';
  String get passwordsDoNotMatch => locale.languageCode == 'ar' 
      ? 'كلمات المرور غير متطابقة' 
      : 'Passwords do not match';

  // Languages
  String get arabic => locale.languageCode == 'ar' ? 'العربية' : 'Arabic';
  String get english => locale.languageCode == 'ar' ? 'الإنجليزية' : 'English';
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}