import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:connect_umadim_app/app_routes.dart';
import 'package:connect_umadim_app/app/core/style/app_theme.dart';
import 'package:connect_umadim_app/app/core/style/theme_provider.dart';

class AppWidget extends ConsumerWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Conecta UMADIM',
      // ── Temas ──────────────────────────────────────────
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      // ── Rotas ──────────────────────────────────────────
      initialRoute: AppRoutes().initialRoute,
      routes: AppRoutes().allAppRoutes,
      // ── Localização ────────────────────────────────────
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [Locale('pt', 'BR')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
