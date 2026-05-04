import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolapp/core/core.dart';
import 'package:schoolapp/views/views.dart';

class ContactUsView extends GetView<ContactUsController> {
  const ContactUsView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctl =
        Get.isRegistered<ContactUsController>()
            ? Get.find<ContactUsController>()
            : Get.put(ContactUsController());

    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.contactUs.tr)),
      backgroundColor: const Color(0xFFF7F7F7),
      body: Obx(() {
        final data = ctl.contactUs.value;
        final address = _clean(data?.address, fallback: 'Phnom Penh, Cambodia');
        final phone = _clean(data?.phone, fallback: '');
        final email = _clean(data?.email, fallback: '');
        final mapUrl = _ensureHttp(
          _clean(
            data?.mapUrl,
            fallback: 'https://maps.google.com/?q=11.5335286,104.881178',
          ),
        );

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.contactUs.tr,
                style: const TextStyle(
                  color: Color(0xFF1F2937),
                  fontSize: 13,
                  fontFamily: 'battambang',
                ),
              ),
              12.height,
              _buildProgressLine(),
              18.height,
              _locationCard(address: address, mapUrl: mapUrl),
              16.height,
              if (phone.isNotEmpty) ...[
                _infoCard(
                  icon: Icons.phone_in_talk_outlined,
                  title: LocaleKeys.phoneNumber.tr,
                  value: phone,
                  onTap: () => UrlLauncherManager.call(phone),
                ),
                const SizedBox(height: 12),
              ],
              if (email.isNotEmpty) ...[
                _infoCard(
                  icon: Icons.mail_outline_rounded,
                  title: LocaleKeys.email.tr,
                  value: email,
                  onTap: () => UrlLauncherManager.launch('mailto:$email'),
                ),
                const SizedBox(height: 18),
              ],
              Row(
                children: [
                  Expanded(
                    child: _actionBtn(
                      icon: Icons.map_outlined,
                      label: LocaleKeys.openMap.tr,
                      onTap: () => UrlLauncherManager.launch(mapUrl),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _actionBtn(
                      icon: Icons.phone,
                      label: LocaleKeys.callNow.tr,
                      onTap:
                          phone.isEmpty
                              ? () {}
                              : () => UrlLauncherManager.call(phone),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProgressLine() {
    return Stack(
      children: [
        Container(height: 2, color: Colors.grey.shade300),
        Container(height: 3, width: 82, color: AppColor.primary),
      ],
    );
  }

  Widget _locationCard({required String address, required String mapUrl}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: AppColor.primary,
                size: 30,
              ),
              const SizedBox(width: 8),
              Text(
                LocaleKeys.address.tr,
                style: AppTextStyle.regularPrimarytextPrimary,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            address,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Material(
            color: const Color(0xFFE7EEED),
            borderRadius: BorderRadius.circular(30),
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () => UrlLauncherManager.launch(mapUrl),
              child: SizedBox(
                height: 42,
                width: double.infinity,
                child: Center(
                  child: Text(
                    LocaleKeys.address.tr,
                    style: AppTextStyle.regularPrimarytextPrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFE7EEED),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: AppColor.primary, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyle.regularPrimarytextPrimary),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionBtn({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: AppColor.primary, size: 20),
      label: Text(label, style: AppTextStyle.regularPrimarytextPrimary),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.grey.shade400),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      ),
    );
  }

  String _clean(String? value, {String fallback = ''}) {
    final text = (value ?? '').trim();
    if (text.isEmpty ||
        text.toLowerCase() == 'n/a' ||
        text.toLowerCase() == 'null') {
      return fallback;
    }
    return text;
  }

  String _ensureHttp(String value) {
    final v = value.trim();
    if (v.startsWith('http://') || v.startsWith('https://')) {
      return v;
    }
    return 'https://$v';
  }
}
