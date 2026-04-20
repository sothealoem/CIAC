import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:swis_school/core/configs/app_style.dart';
import 'package:swis_school/core/constants/storage_key.dart';
import 'package:swis_school/core/resources/locales.g.dart';
import 'package:swis_school/core/services/api_service.dart';
import 'package:swis_school/core/utils/keyboard_helper.dart';
import 'package:swis_school/flavor/app_config.dart';
import 'package:swis_school/routes.dart';
import 'package:upgrader/upgrader.dart';

Future<void> main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await dotenv.load(fileName: '.env');
    print("ENV BASE_URL: ${dotenv.env['BASE_URL']}");

    await _initEnvironment();
    await _setAppSystemPreferences();
    await _initServices();

    if (kDebugMode) {
      Logger.root.level = Level.ALL;
      Logger.root.onRecord.listen(customPrint);
    } else {
      Logger.root.level = Level.OFF;
    }

    runApp(const MyApp());
  }, (exception, trace) {});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'CIAC School',
      translationsKeys: AppTranslation.translations,
      locale: AppConfig.shared.languageLocale,
      fallbackLocale: const Locale('KM', 'KH'),
      debugShowCheckedModeBanner: false,
      theme: AppStyle.themeData(),
      initialRoute: Routes.start,
      //initialRoute:
      //  AppConfig.shared.token.isNotEmpty ? Routes.root : Routes.login,
      getPages: Routes.pages,
      builder: (context, child) {
        final mediaQueryData = MediaQuery.of(context);
        final constrainedTextScaleFactor = mediaQueryData.textScaler.clamp(
          minScaleFactor: 1.1,
          maxScaleFactor: 1.125,
        );

        return UpgradeAlert(
          barrierDismissible: false,
          showLater: false,
          showIgnore: false,
          dialogStyle:
              Platform.isIOS
                  ? UpgradeDialogStyle.cupertino
                  : UpgradeDialogStyle.material,
          child: GestureDetector(
            onTap: () => KeyboardHelper.dismissKeyboard(),
            child: MediaQuery(
              data: mediaQueryData.copyWith(
                textScaler: constrainedTextScaleFactor,
              ),
              child: child!,
            ),
          ),
        );
      },
    );
  }
}

void customPrint(dynamic value) {
  if (kDebugMode) {
    debugPrint('[INFO] : $value');
  }
}

Future<void> _setAppSystemPreferences() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

Future<void> _initEnvironment() async {
  AppConfig.shared.setLanguage(Language.kh.key);
}

Future<void> _initServices() async {
  AppConfig.shared;
  Get.put<ApiService>(ApiService());
}
