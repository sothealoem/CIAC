import 'dart:convert';

import 'package:schoolapp/core/core.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class CardScanController extends GetxController {
  static const String _scanLogStorageKey = 'attendance_scan_logs_v1';

  var isLoading = false.obs;
  var isScanning = true.obs;
  final Rx<CameraFacing> cameraFacing = CameraFacing.back.obs;
  final RxBool isTorchOn = false.obs;
  late MobileScannerController mobileScannerCtl;
  bool _isConfirmingScan = false;
  static const Duration _duplicateWindow = Duration(seconds: 30);
  DateTime? _lastScanAt;
  String? _lastScanKey;

  @override
  void onInit() {
    mobileScannerCtl = MobileScannerController(
      facing: CameraFacing.back,
      torchEnabled: false,
    );
    super.onInit();
  }

  @override
  void onClose() {
    mobileScannerCtl.dispose();
    super.onClose();
  }

  Future<void> switchCamera() async {
    await mobileScannerCtl.switchCamera();
    cameraFacing.value =
        cameraFacing.value == CameraFacing.back
            ? CameraFacing.front
            : CameraFacing.back;
  }

  Future<void> switchFlash() async {
    await mobileScannerCtl.toggleTorch();
    isTorchOn.value = !isTorchOn.value;
  }

  Future<void> handleDetectedQr({
    required String raw,
    required double lat,
    required double lng,
  }) async {
    final parsed = _parseQrPayload(raw);
    if (parsed == null) {
      _handleFailure(
        "Invalid QR format. Expected JSON like {\"type\":\"staff\",\"code\":\"CIAC-001\"}.",
      );
      return;
    }

    if (_isConfirmingScan) {
      return;
    }
    _isConfirmingScan = true;
    await _confirmAndPostScan(parsed: parsed, lat: lat, lng: lng);
    _isConfirmingScan = false;
  }

  Future<void> _confirmAndPostScan({
    required _QrPayload parsed,
    required double lat,
    required double lng,
  }) async {
    final scannerUsername =
        await SharedPreferencesManager.get(Credential.username.name) ?? '';
    final scannerName = await SharedPreferencesManager.get('name') ?? '';

    final shouldLog = await Get.dialog<bool>(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 24,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.qr_code_scanner_rounded, color: Color(0xFF006E6D)),
                  SizedBox(width: 8),
                  Text(
                    'Scan Confirmation',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _infoTile(
                icon: Icons.person_outline_rounded,
                label: 'Scanner',
                value:
                    scannerName.toString().trim().isEmpty
                        ? 'Unknown'
                        : scannerName.toString().trim(),
              ),
              const SizedBox(height: 10),
              _infoTile(
                icon: Icons.alternate_email_rounded,
                label: 'Email',
                value:
                    scannerUsername.toString().trim().isEmpty
                        ? 'Unknown'
                        : scannerUsername.toString().trim(),
              ),
              const SizedBox(height: 18),
              const Text(
                'Log attendance now?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(result: false),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFD1D5DB)),
                        foregroundColor: const Color(0xFF374151),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Close',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Get.back(result: true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF006E6D),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Log',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );

    if (shouldLog != true) {
      isScanning.value = true;
      return;
    }

    await postScanCard(
      scanPoint: parsed.code,
      qrType: parsed.type,
      rawPayload: parsed.rawPayload,
      lat: lat,
      lng: lng,
    );
  }

  Future<void> postScanCard({
    required String scanPoint,
    required String qrType,
    required String rawPayload,
    required double lat,
    required double lng,
  }) async {
    try {
      isLoading.value = true;
      final token =
          await SharedPreferencesManager.get(Credential.token.name) ?? '';
      if (token.toString().trim().isEmpty) {
        _handleFailure("Please login first.");
        return;
      }

      final scannerUsername =
          await SharedPreferencesManager.get(Credential.username.name) ?? '';
      final scannerName = await SharedPreferencesManager.get('name') ?? '';
      final scannerOwnerId =
          await SharedPreferencesManager.get('scanner_owner_id') ?? '';
      if (scannerUsername.toString().trim().isEmpty) {
        _handleFailure("Scanner account not found. Please login again.");
        return;
      }
      final code = scanPoint.trim();
      final normalizedType = qrType.trim().toLowerCase();
      final dedupeKey = '$normalizedType|$code|$scannerUsername';
      final owner = scannerOwnerId.toString().trim();

      if (owner.isEmpty) {
        _handleFailure("Scanner owner id not found. Please login again.");
        return;
      }

      if (_isDuplicateWithinWindow(dedupeKey)) {
        _handleFailure("Already logged recently. Please wait and scan again.");
        return;
      }
      final response = await Get.find<ApiService>().post(EndPoints.scanCard, {
        "card_uid": owner,
        "code": owner,
        "staff_code": owner,
        "scan_point": code,
        "scanned_code": code,
        "type": normalizedType,
        "qr_type": normalizedType,
        "qr_code": code,
        "qr_payload": rawPayload,
        "qr_payload_type": normalizedType,
        "qr_payload_code": code,
        "scanned_by": scannerUsername,
        "scanner_username": scannerUsername,
        "scanner_name": scannerName,
        "lat": lat,
        "lng": lng,
      }, isShowLoading: false);

      final data = response.data;
      if (data is Map<String, dynamic>) {
        _handleApiPayload(data, fallbackMessage: "Server error");
        _markLogged(dedupeKey);
      } else {
        _handleFailure("Invalid server response");
      }
    } on DioException catch (e) {
      final errorData = e.response?.data;
      if (errorData is Map<String, dynamic>) {
        _handleApiPayload(errorData, fallbackMessage: "Connection failed");
      } else {
        final msg = e.response?.data?['message'] ?? "Connection failed";
        _handleFailure(msg);
      }
    } catch (_) {
      _handleFailure("System error");
    } finally {
      isLoading.value = false;
    }
  }

  void _handleApiPayload(
    Map<String, dynamic> data, {
    required String fallbackMessage,
  }) {
    final staff = data['staff'] ?? data['data']?['staff'] ?? data['data'];
    final message = data['message']?.toString() ?? fallbackMessage;

    if (staff == null) {
      _handleFailure(message);
      return;
    }

    _cacheScanLogRecord(staffData: staff, message: message);
    _showLogDialog(staff, message: message);

    final fullName = _getFullName(staff);
    final alreadyScanned = message.toLowerCase().contains("already");

    Get.snackbar(
      alreadyScanned ? "Attendance Log" : "Success",
      fullName.isEmpty
          ? message
          : alreadyScanned
          ? "$fullName\n$message"
          : "Attendance recorded for $fullName",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: alreadyScanned ? Colors.orange : Colors.green,
      colorText: Colors.white,
    );

    Future.delayed(const Duration(seconds: 3), () {
      isScanning.value = true;
    });
  }

  Future<void> _cacheScanLogRecord({
    required dynamic staffData,
    required String message,
  }) async {
    try {
      final fullName = _getFullName(staffData);
      final fallbackName =
          staffData['name']?.toString().trim().isNotEmpty == true
              ? staffData['name'].toString().trim()
              : 'Unknown';
      final name = fullName.isEmpty ? fallbackName : fullName;

      final scanLog =
          staffData['scan_log'] ??
          staffData['attendance_log'] ??
          staffData['attendance'] ??
          {};

      final date = _resolveLogDate(scanLog);
      final time = _resolveLogTime(scanLog);
      final status =
          scanLog is Map<String, dynamic>
              ? (scanLog['status'] ?? scanLog['attendance_status'] ?? '')
                  .toString()
                  .toLowerCase()
                  .trim()
              : '';

      final record = <String, dynamic>{
        'name': name,
        'date': date,
        'checkInMorning': time,
        'checkOutMorning': '-',
        'checkInAfternoon': '-',
        'checkOutAfternoon': '-',
        'status': _normalizeStatus(status, message),
        'createdAt': DateTime.now().toIso8601String(),
      };

      final raw = await SharedPreferencesManager.get(_scanLogStorageKey);
      final logs = <Map<String, dynamic>>[];

      if (raw is String && raw.trim().isNotEmpty) {
        final decoded = jsonDecode(raw);
        if (decoded is List) {
          logs.addAll(
            decoded.whereType<Map>().map((e) => Map<String, dynamic>.from(e)),
          );
        }
      }

      final dedupeKey =
          '${record['name']}|${record['date']}|${record['checkInMorning']}|${record['status']}';
      final exists = logs.any((e) {
        final key =
            '${e['name']}|${e['date']}|${e['checkInMorning']}|${e['status']}';
        return key == dedupeKey;
      });
      if (!exists) {
        logs.insert(0, record);
      }

      await SharedPreferencesManager.setValue(
        _scanLogStorageKey,
        jsonEncode(logs),
      );
    } catch (_) {
      // Do not block scanning flow if local cache fails.
    }
  }

  String _todayIsoDate() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  String _resolveLogDate(dynamic scanLog) {
    if (scanLog is Map<String, dynamic>) {
      final rawDate =
          (scanLog['date'] ?? scanLog['scan_date'] ?? '').toString().trim();
      if (rawDate.isNotEmpty) {
        return rawDate;
      }

      final createdAt = (scanLog['created_at'] ?? '').toString().trim();
      final parsed = DateTime.tryParse(createdAt);
      if (parsed != null) {
        return '${parsed.year}-${parsed.month.toString().padLeft(2, '0')}-${parsed.day.toString().padLeft(2, '0')}';
      }
    }
    return _todayIsoDate();
  }

  String _resolveLogTime(dynamic scanLog) {
    if (scanLog is Map<String, dynamic>) {
      final rawTime =
          (scanLog['time'] ?? scanLog['scan_time'] ?? '').toString().trim();
      if (rawTime.isNotEmpty) {
        return rawTime;
      }

      final createdAt = (scanLog['created_at'] ?? '').toString().trim();
      final parsed = DateTime.tryParse(createdAt);
      if (parsed != null) {
        return _formatTime(parsed);
      }
    }
    return _formatTime(DateTime.now());
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $period';
  }

  String _normalizeStatus(String apiStatus, String message) {
    if (apiStatus.contains('late')) {
      return 'late';
    }
    if (apiStatus.contains('absent')) {
      return 'absent';
    }
    if (message.toLowerCase().contains('late')) {
      return 'late';
    }
    return 'present';
  }

  String _getFullName(dynamic staffData) {
    final firstName =
        staffData['firstname']?.toString() ??
        staffData['first_name']?.toString() ??
        '';
    final lastName =
        staffData['lastname']?.toString() ??
        staffData['last_name']?.toString() ??
        '';
    return '$firstName $lastName'.trim();
  }

  void _showLogDialog(dynamic staffData, {required String message}) {
    final fullName = _getFullName(staffData);
    final scanLog =
        staffData['scan_log'] ??
        staffData['attendance_log'] ??
        staffData['attendance'] ??
        {};

    final scanTime =
        scanLog is Map<String, dynamic>
            ? (scanLog['time'] ??
                    scanLog['scan_time'] ??
                    scanLog['created_at'] ??
                    '')
                .toString()
            : '';
    final scanDate =
        scanLog is Map<String, dynamic>
            ? (scanLog['date'] ?? scanLog['scan_date'] ?? '').toString()
            : '';
    final status =
        scanLog is Map<String, dynamic>
            ? (scanLog['status'] ?? scanLog['attendance_status'] ?? '')
                .toString()
            : '';

    final subtitle = [
      if (fullName.isNotEmpty) fullName,
      message,
      if (scanDate.isNotEmpty) 'Date: $scanDate',
      if (scanTime.isNotEmpty) 'Time: $scanTime',
      if (status.isNotEmpty) 'Status: $status',
    ].join('\n');

    DialogManager.showCustom(
      PrimaryDialog(
        title: "Attendance Log",
        subTitle: subtitle,
        onPressed: () => Get.back(),
      ),
    );
  }

  void _handleFailure(String message) {
    Get.snackbar(
      message.toLowerCase().contains("already")
          ? "Attendance Log"
          : "Scan Error",
      message.toLowerCase().contains("already") ? message : message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor:
          message.toLowerCase().contains("already")
              ? Colors.orange
              : Colors.red,
      colorText: Colors.white,
    );

    Future.delayed(const Duration(seconds: 2), () {
      isScanning.value = true;
    });
  }

  bool _isDuplicateWithinWindow(String key) {
    if (_lastScanAt == null || _lastScanKey == null) {
      return false;
    }
    return _lastScanKey == key &&
        DateTime.now().difference(_lastScanAt!) < _duplicateWindow;
  }

  void _markLogged(String key) {
    _lastScanKey = key;
    _lastScanAt = DateTime.now();
  }

  Widget _infoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF334155)),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF334155),
                  fontFamily: 'Battambang',
                ),
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(
                    text: value,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _QrPayload? _parseQrPayload(String raw) {
    final normalized = raw.trim().replaceAll(RegExp(r'[\r\n\t]'), '');

    try {
      final decoded = jsonDecode(normalized);
      if (decoded is! Map) {
        return null;
      }

      final type = decoded['type']?.toString().trim().toLowerCase();
      final code = decoded['code']?.toString().trim();
      final displayNameRaw = decoded['name']?.toString().trim();
      final firstName = decoded['firstname']?.toString().trim();
      final lastName = decoded['lastname']?.toString().trim();
      final fullName = '${firstName ?? ''} ${lastName ?? ''}'.trim();
      final displayName =
          (displayNameRaw != null && displayNameRaw.isNotEmpty)
              ? displayNameRaw
              : (fullName.isNotEmpty ? fullName : null);

      if (type == null || type.isEmpty || code == null || code.isEmpty) {
        return null;
      }

      if (type != 'staff') {
        return null;
      }

      return _QrPayload(
        type: type,
        code: code,
        rawPayload: normalized,
        displayName: displayName,
      );
    } catch (_) {
      return null;
    }
  }
}

class _QrPayload {
  final String type;
  final String code;
  final String rawPayload;
  final String? displayName;

  const _QrPayload({
    required this.type,
    required this.code,
    required this.rawPayload,
    this.displayName,
  });
}
