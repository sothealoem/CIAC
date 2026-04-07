import 'package:flutter/material.dart';
import 'package:swis_school/core/core.dart';

class KeyboardHelper {
  static void dismissKeyboard() {
    final FocusScopeNode currentFocus = FocusScope.of(UserRepository.shared.context!);

    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus!.unfocus();
    }
  }
}
