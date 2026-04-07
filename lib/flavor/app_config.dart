import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:swis_school/core/core.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppConfig {
  AppConfig._() {
    _getVersion();
    _getToken();
  }

  static final _instance = AppConfig._();
  static AppConfig get shared => _instance;

  String get baseUrl => dotenv.env[EnvKey.baseUrl.value] ?? '';

  String _token = '';
  String get token => 'Bearer $_token';
  set token(String value) => _token = value;

  bool isDeliveryTapOpened = false;

  Future<void> _getToken() async {
    _token = await SharedPreferencesManager.get(Credential.token.name) ?? '';
  }

  String _language = Language.kh.key;
  String get language => _language;

  // set as default language
  void setLanguage(String value) async {
    dynamic localLng = await SharedPreferencesManager.get(LanguageKey.language.name);
    _language = localLng ?? value;
  }

  // update later
  void updateLanguage(String value) {
    _language = value;
    Get.updateLocale(AppConfig.shared.languageLocale);
    SharedPreferencesManager.setValue(
      LanguageKey.language.name,
      _language,
    );
  }

  Locale get languageLocale {
    switch (language) {
      case 'EN':
        return const Locale('EN', 'US');
      default:
        return const Locale('KM', 'KH');
    }
  }

  String _version = '0.0.0';
  String get version => _version;

  Future<void> _getVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _version = packageInfo.version;
  }
}
