import 'package:flutter/material.dart';

import 'screens/audit_log_screen.dart';
import 'screens/goods_receipt_screen.dart';
import 'screens/home_shell_screen.dart';
import 'screens/login_screen.dart';
import 'screens/po_tracking_screen.dart';
import 'theme/app_colors.dart';

class InvenTrackApp extends StatelessWidget {
  const InvenTrackApp({super.key});

  static const String loginRoute = '/';
  static const String homeRoute = '/home';
  static const String poTrackingRoute = '/po-tracking';
  static const String goodsReceiptRoute = '/goods-receipt';
  static const String auditLogRoute = '/audit-log';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'InvenTrack',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ).copyWith(
          primary: AppColors.primary,
          surface: AppColors.surface,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.surfaceLowest,
          foregroundColor: AppColors.onSurface,
          elevation: 0,
          centerTitle: false,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surfaceHigh,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
        ),
      ),
      initialRoute: loginRoute,
      routes: {
        loginRoute: (_) => const LoginScreen(),
        homeRoute: (_) => const HomeShellScreen(),
        poTrackingRoute: (_) => const PoTrackingScreen(),
        goodsReceiptRoute: (_) => const GoodsReceiptScreen(),
        auditLogRoute: (_) => const AuditLogScreen(),
      },
    );
  }
}
