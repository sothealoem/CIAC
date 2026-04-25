import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:schoolapp/views/scan/scan_log_controller.dart';
import 'package:schoolapp/views/scan/widgets/overlay.dart';

class CardScanView extends StatelessWidget {
  CardScanView({super.key});

  final CardScanController controller = Get.put(CardScanController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            controller: controller.mobileScannerCtl,
            onDetect: (capture) {
              if (!controller.isScanning.value || controller.isLoading.value) {
                return;
              }

              for (final barcode in capture.barcodes) {
                final raw = barcode.rawValue;

                if (raw != null && raw.isNotEmpty) {
                  controller.isScanning.value = false;
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
              center: Offset(Get.width / 2, Get.height * 0.45),
              width: 250,
              height: 250,
            ),
          ),

          _buildScannerOverlay(),

          Obx(
            () =>
                controller.isLoading.value
                    ? Container(
                      color: Colors.black54,
                      child: const Center(child: CircularProgressIndicator()),
                    )
                    : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildScannerOverlay() {
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
                cutOutBottomOffset: 88,
                overlayColor: Colors.black.withOpacity(0.85),
              ),
            ),
          ),
        ),
        Positioned(
          top: 100,
          left: 24,
          right: 24,
          child: const Text(
            'ដាក់កូដ QR ដើម្បីស្កេនវត្តមាន',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF007A79),
              fontSize: 23,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Positioned(
          top: Get.height * 0.69,
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
