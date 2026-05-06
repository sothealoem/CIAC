import 'package:get/get.dart';
import 'package:schoolapp/core/constants/storage_key.dart';

class AppFontFamily {
  AppFontFamily._();

  static const roboto = 'Roboto';
  static const battambang = 'Battambang';

  static String forLanguage(String language) {
    return language.toUpperCase() == Language.en.key ? roboto : battambang;
  }

  static String get localized {
    final languageCode = Get.locale?.languageCode.toUpperCase();
    return languageCode == Language.en.key ? roboto : battambang;
  }
}
