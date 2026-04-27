import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolapp/core/core.dart';

class TermConditionView extends StatelessWidget {
  const TermConditionView({super.key});

  @override
  Widget build(BuildContext context) {
    final policyUrl = _getPolicyUrl();

    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.termAndCondition.tr)),
      body:
          policyUrl == null
              ? const Center(
                child: Text(
                  'Terms & conditions are unavailable right now.',
                  textAlign: TextAlign.center,
                ),
              )
              : Center(
                child: InteractiveViewer(
                  child: Image.network(
                    policyUrl,
                    fit: BoxFit.contain,
                    errorBuilder:
                        (_, __, ___) => const Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            'Unable to load terms & conditions image.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                  ),
                ),
              ),
    );
  }

  String? _getPolicyUrl() {
    try {
      final raw = UserRepository.shared.profile.policy.trim();
      if (raw.isEmpty || raw.toLowerCase() == 'n/a') {
        return null;
      }
      if (raw.startsWith('http://') || raw.startsWith('https://')) {
        return raw;
      }
      return 'https://$raw';
    } catch (_) {
      return null;
    }
  }
}
