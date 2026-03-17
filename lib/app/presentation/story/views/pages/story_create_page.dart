import 'package:connect_umadim_app/app/core/style/app_colors.dart';
import 'package:connect_umadim_app/app/core/style/app_text.dart';
import 'package:flutter/material.dart';

/// Página placeholder para criar um story.
/// A funcionalidade completa será implementada futuramente.
class StoryCreatePage extends StatelessWidget {
  const StoryCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Novo story',
          style: AppText.headlineMedium(context),
        ),
        iconTheme: IconThemeData(
          color: isDark ? AppColor.darkOnSurface : AppColor.lightOnSurface,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_rounded,
              size: 64,
              color: AppColor.orange500.withOpacity(0.6),
            ),
            const SizedBox(height: 16),
            Text(
              'Em breve',
              style: AppText.headlineLarge(context),
            ),
            const SizedBox(height: 8),
            Text(
              'Criação de stories em desenvolvimento.',
              style: AppText.bodyMedium(context),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
