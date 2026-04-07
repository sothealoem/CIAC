import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swis_school/core/core.dart';
import 'package:swis_school/models/models.dart';
import 'package:swis_school/routes.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController getProdCtl = TextEditingController();
  final TextEditingController finishDeliveryCtl = TextEditingController();

  late MobileScannerController mobileScannerCtl;
  late StreamSubscription<Object?> subscription;
  final Rx<CameraFacing> cameraFacing = CameraFacing.back.obs;
  final RxBool isTorchOn = false.obs;
  @override
  void onInit() async {
    mobileScannerCtl = MobileScannerController();
    await cameraListen();
    super.onInit();
  }

  Future<void> cameraListen() async {
    // Call listen over here instead of onDetect property because https://github.com/juliansteenbakker/mobile_scanner/issues/925
    subscription = mobileScannerCtl.barcodes.listen((BarcodeCapture capture) async {
      final List<Barcode> barcodes = capture.barcodes;

      for (final barcode in barcodes) {
        if ((barcode.rawValue ?? '').isEmpty) {
          ExceptionHandler.handleException('Cannot get result from the QRCode');
          return;
        }
        await onDetected(barcode.rawValue!);

        // Access only first time detect of QR code
        return;
      }
    });
  }

  @override
  void onClose() {
    mobileScannerCtl.dispose();
    subscription.cancel();
    getProdCtl.dispose();
    finishDeliveryCtl.dispose();
    super.onClose();
  }

  Future<void> switchCamera() async {
    await mobileScannerCtl.switchCamera();
    cameraFacing.value = cameraFacing.value == CameraFacing.back
        ? CameraFacing.front
        : CameraFacing.back;
  }


  Future<void> switchFlash() async {
    mobileScannerCtl.toggleTorch();
  }

  void clear() {
    getProdCtl.text = '';
    finishDeliveryCtl.text = '';
  }

  Future<void> onDetected(String value) async {
    try {
      final String id = value.split('-')[0];
      if (value.contains(QrCodeResult.complete.key)) {
        await scanComplete(id: id, isFromScanner: true);
        return;
      }
      await scanGetProduct(id: id, isFromScanner: true);
    } catch (e) {
      ExceptionHandler.handleException('Scan complete failed. Please try again.');
    }
  }

  Future<void> scanComplete({required String id, bool isFromScanner = false}) async {
    try {
      if (isFromScanner) {
        mobileScannerCtl.stop();
      }

      final String endPoint = '${EndPoints.scanComplete}/$id';
      final res = await Get.find<ApiService>().get(endPoint, isShowLoading: true);

      final data = getPropertyFromJson(res.data, 'data');
      final ScanCompleteModel model = ScanCompleteModel.fromJson(data);

      final Map<String, dynamic> arg = {
        'deliveryId': model.id,
        'totalAmount': model.totalAmount,
      };

      DialogManager.hideLoading();

      Get.toNamed(Routes.finishDelivery, arguments: arg)?.then((value) {
        mobileScannerCtl.start();
      });
    } catch (e) {
      ExceptionHandler.handleException(e, onValue: (p0) {
        mobileScannerCtl.start();
      });
    }
  }

  Future<void> scanGetProduct({required String id, bool isFromScanner = false}) async {
    try {
      if (isFromScanner) {
        mobileScannerCtl.stop();
      }

      final String endPoint = '${EndPoints.scanGetProduct}/$id';
      final res = await Get.find<ApiService>().get(endPoint, isShowLoading: true);
      final message = getPropertyFromJson(res.data, 'message');

      DialogManager.showCustom(PrimaryDialog(
        title: LocaleKeys.getProduct.tr,
        subTitle: message,
        onPressed: () => Get.back(),
      )).then((value) {
        mobileScannerCtl.start();
      });
    } catch (e) {
      ExceptionHandler.handleException(e, onValue: (p0) {
        mobileScannerCtl.start();
      });
    }
  }
}
