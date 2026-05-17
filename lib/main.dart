import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:schoolapp/core/core.dart';
import 'package:schoolapp/flavor/flavor.dart';
import 'package:schoolapp/routes.dart';
import 'package:logging/logging.dart';
import 'package:upgrader/upgrader.dart';

Future<void> main() async {
  runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      await dotenv.load(fileName: '.env');
      print("ENV BASE_URL: ${dotenv.env['BASE_URL']}");
      await Firebase.initializeApp();
      await FirebaseMessaging.instance.requestPermission();

      await _initEnvironment();
      await _setAppSystemPreferences();
      await _initServices();
      await HomeworkNotificationService.instance.initialize();

      if (kDebugMode) {
        Logger.root.level = Level.ALL;
        Logger.root.onRecord.listen(customPrint);
      } else {
        Logger.root.level = Level.OFF;
      }
      runApp(const MyApp());
      unawaited(HomeworkNotificationService.instance.handleInitialMessage());
    },
    (exception, trace) {
      ExceptionHandler.handleException(exception);
    },
  );
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
      theme: AppStyle.themeData(
        fontFamily: AppFontFamily.forLanguage(AppConfig.shared.language),
      ),
      //initialRoute: Routes.start,
      initialRoute:
          AppConfig.shared.token.isNotEmpty ? Routes.root : Routes.login,
      getPages: Routes.pages,
      builder: (context, child) {
        final mediaQueryData = MediaQuery.of(context);

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
                textScaler: TextScaler.linear(
                  mediaQueryData.textScaler.scale(1.0).clamp(1.0, 1.125),
                ),
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
  await AppConfig.shared.setLanguage(Language.kh.key);
}

Future<void> _initServices() async {
  AppConfig.shared;
  Get.put<ApiService>(ApiService());
}
