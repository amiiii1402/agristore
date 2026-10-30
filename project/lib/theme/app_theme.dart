
import 'package:flutter/material.dart';

// Pertemuan 9: satu sumber gaya (design token) untuk seluruh aplikasi.
class AppTheme {
  AppTheme._();

  // Seed color baru AgriStore
  static const Color seed = Color(0xFF087F6A);

  static const double radius = 16;
  static const double radiusKecil = 12;

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: brightness,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
    );

    final text = _textTheme(base.textTheme);

    return base.copyWith(
      textTheme: text,

      appBarTheme: AppBarTheme(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        titleTextStyle: text.titleLarge?.copyWith(
          color: scheme.onPrimary,
        ),
      ),

      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: scheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusKecil),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusKecil),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(64, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusKecil),
          ),
        ),
      ),

      // Tugas Mandiri Nomor 2:
      // Tema khusus NavigationBar.
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        indicatorColor: scheme.secondaryContainer,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return TextStyle(
                color: scheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              );
            }

            return TextStyle(
              color: scheme.onSurfaceVariant,
              fontWeight: FontWeight.normal,
              fontSize: 12,
            );
          },
        ),
        iconTheme: WidgetStateProperty.resolveWith<IconThemeData?>(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return IconThemeData(color: scheme.primary);
            }

            return IconThemeData(color: scheme.onSurfaceVariant);
          },
        ),
      ),

      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Oswald hanya untuk judul.
  static TextTheme _textTheme(TextTheme base) {
    TextStyle? judul(TextStyle? style) {
      return style?.copyWith(
        fontFamily: 'Oswald',
        fontWeight: FontWeight.w600,
      );
    }

    return base.copyWith(
      headlineSmall: judul(base.headlineSmall),
      titleLarge: judul(base.titleLarge),
      titleMedium: base.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
