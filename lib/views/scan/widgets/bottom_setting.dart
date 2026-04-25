import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolapp/views/views.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BottomSettingWidget extends StatelessWidget {
  BottomSettingWidget({super.key, this.bottomBarText = 'Scan QR Code'});

  final String bottomBarText;
  final ScanController scanCtl = Get.find<ScanController>();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: IconButton(
        tooltip: 'Switch Camera',
        onPressed: () => scanCtl.switchCamera(),
        icon: Icon(
          scanCtl.cameraFacing.value == CameraFacing.front
              ? Icons.camera_front
              : Icons.camera_rear,
        ),
      ),
      title: Text(
        bottomBarText,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      trailing: IconButton(
        tooltip: 'Flash',
        onPressed: () => scanCtl.switchFlash(),
        icon: Icon(
          scanCtl.isTorchOn.value ? Icons.flash_on : Icons.flash_off,
          color: scanCtl.isTorchOn.value ? Colors.orange : Colors.grey,
        ),
      ),
    );
  }
}
