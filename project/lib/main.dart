
import 'package:flutter/material.dart';

import 'routes/app_routes.dart';
import 'theme/app_theme.dart';
import 'theme/theme_controller.dart';

void main() {
  runApp(const AgriStoreApp());
}

class AgriStoreApp extends StatelessWidget {
  const AgriStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp dibangun ulang setiap kali mode tema berubah.
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.mode,
      builder: (context, mode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Agri Store',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: mode,
          initialRoute: AppRoutes.home,
          onGenerateRoute: AppRoutes.onGenerateRoute,
        );
      },
    );
  }
}
