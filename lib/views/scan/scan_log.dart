import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:schoolapp/core/core.dart';
import 'package:schoolapp/views/scan/scan_log_controller.dart';
import 'package:schoolapp/views/scan/widgets/overlay.dart';

class CardScanView extends StatefulWidget {
  const CardScanView({super.key});

  @override
  State<CardScanView> createState() => _CardScanViewState();
}

class _CardScanViewState extends State<CardScanView> {
  late final CardScanController controller;

  @override
  void initState() {
    super.initState();
    controller =
        Get.isRegistered<CardScanController>()
            ? Get.find<CardScanController>()
            : Get.put(CardScanController());
    controller.isScanning.value = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.biggest;
          final scannerBottomOffset =
              MediaQuery.of(context).padding.bottom + 80;

          return Stack(
            children: [
              MobileScanner(
                controller: controller.mobileScannerCtl,
                onDetect: (capture) {
                  if (!controller.isScanning.value ||
                      controller.isLoading.value) {
                    return;
                  }

                  for (final barcode in capture.barcodes) {
                    final raw = barcode.rawValue;

                    if (raw != null && raw.isNotEmpty) {
                      controller.isScanning.value = false;
                      HapticFeedback.mediumImpact();
                      controller.handleDetectedQr(
                        raw: raw,
                        lat: 11.5621,
                        lng: 104.9243,
                      );
                      break;
                    }
                  }
                },
                scanWindow: Rect.fromCenter(
                  center: Offset(size.width / 2, size.height / 2),
                  width: 250,
                  height: 250,
                ),
              ),

              _buildScannerOverlay(controller, scannerBottomOffset),

              Obx(
                () =>
                    controller.isLoading.value
                        ? Container(
                          color: Colors.black54,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                        : const SizedBox.shrink(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildScannerOverlay(
    CardScanController controller,
    double scannerBottomOffset,
  ) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: ShapeDecoration(
              shape: OverlayShape(
                borderColor: Colors.white,
                borderWidth: 4,
                borderRadius: 14,
                borderLength: 34,
                cutOutSize: 0.0,
                cutOutWidth: 250,
                cutOutHeight: 250,
                cutOutBottomOffset: 0,
                overlayColor: Colors.black.withOpacity(0.85),
              ),
            ),
          ),
        ),
        Positioned(
          top: 120,
          left: 24,
          right: 24,
          child: Text(
            LocaleKeys.scanQrCodeToLogAttendance.tr,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Positioned(
          bottom: scannerBottomOffset,
          left: 0,
          right: 0,
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: controller.switchCamera,
                  iconSize: 34,
                  color: Colors.white,
                  icon: Icon(
                    controller.cameraFacing.value == CameraFacing.front
                        ? Icons.cameraswitch
                        : Icons.cameraswitch_outlined,
                  ),
                ),
                const SizedBox(width: 42),
                IconButton(
                  onPressed: controller.switchFlash,
                  iconSize: 34,
                  color: Colors.white,
                  icon: Icon(
                    controller.isTorchOn.value
                        ? Icons.flash_on_rounded
                        : Icons.flash_off_outlined,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
