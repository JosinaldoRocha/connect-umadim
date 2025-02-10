import 'package:connect_umadim_app/app/core/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/style/app_text.dart';

class ConfirmPresenceDialogWidget extends ConsumerWidget {
  const ConfirmPresenceDialogWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        Lottie.asset(
          'assets/animations/confetti.json',
          width: 313,
          height: 150,
          fit: BoxFit.fitHeight,
        ),
        Container(
          height: 150,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              fit: BoxFit.fitHeight,
              image: AssetImage(
                'assets/images/complete_profile_logo.png',
              ),
              opacity: 0.10,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Uhuu!\nQue bom que você vai estar conosco 😀\n'
                'Nos vemos lá então!!!',
                textAlign: TextAlign.center,
                style: AppText.text()
                    .bodyLarge!
                    .copyWith(color: AppColor.tertiary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
