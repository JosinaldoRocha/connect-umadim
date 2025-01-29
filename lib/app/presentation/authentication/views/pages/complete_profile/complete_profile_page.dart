import 'package:connect_umadim_app/app/widgets/spacing/spacing.dart';
import 'package:flutter/material.dart';

import '../../../../../core/style/app_colors.dart';
import '../../../../../core/style/app_text.dart';
import '../../../../../widgets/button/button_widget.dart';

class CompleteProfilePage extends StatelessWidget {
  const CompleteProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacer(),
            Center(
              child: Image.asset('assets/images/complete_profile_logo.png'),
            ),
            Spacer(),
            Text(
              'Estamos quase lá!',
              style: AppText.text().titleLarge!.copyWith(
                    color: AppColor.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SpaceVertical.x10(),
            Text(
              'Agora, complete seu cadastro e comece a usar o conecta umadim!',
              style: AppText.text().bodyMedium!.copyWith(
                    color: AppColor.tertiary,
                    fontSize: 18,
                  ),
            ),
            SpaceVertical.x10(),
            ButtonWidget(
              title: 'Completar cadastro',
              onTap: () {
                Navigator.of(context).pushReplacementNamed(
                  '/auth/complete-profile-form',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
