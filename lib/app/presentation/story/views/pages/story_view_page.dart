import 'package:connect_umadim_app/app/core/style/app_colors.dart';
import 'package:connect_umadim_app/app/core/style/app_text.dart';
import 'package:flutter/material.dart';

/// Página placeholder para visualizar um story.
/// A funcionalidade completa será implementada futuramente.
class StoryViewPage extends StatelessWidget {
  const StoryViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final storyId = ModalRoute.of(context)?.settings.arguments as int?;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Story',
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
              Icons.auto_stories_rounded,
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
              storyId != null
                  ? 'Story #$storyId será exibido aqui.'
                  : 'Visualização de stories em desenvolvimento.',
              style: AppText.bodyMedium(context),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
