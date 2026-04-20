import 'package:dio/dio.dart' as dio;
import 'package:swis_school/core/libraries/connectivity_plus.dart';
import 'package:swis_school/core/utils/dialog_manager.dart';

class ConnectivityInterceptor extends dio.Interceptor {
  ConnectivityInterceptor();

  @override
  void onRequest(
    dio.RequestOptions options,
    dio.RequestInterceptorHandler handler,
  ) async {
    if (await ConnectivityPlusManager.shared.isConnected) {
      return super.onRequest(options, handler);
    } else {
      DialogManager.showConnectionDialog();
      return;
    }
  }
}
