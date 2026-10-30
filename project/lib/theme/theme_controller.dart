
import 'package:flutter/material.dart';

// Menyimpan pilihan mode tema (terang, gelap, sistem).
class ThemeController {
  ThemeController._();

  static final ValueNotifier<ThemeMode> mode =
      ValueNotifier<ThemeMode>(ThemeMode.system);

  static void ubah(ThemeMode baru) {
    mode.value = baru;
  }
}
