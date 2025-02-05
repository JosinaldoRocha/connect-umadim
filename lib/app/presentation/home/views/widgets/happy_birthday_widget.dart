import 'package:connect_umadim_app/app/core/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/style/app_text.dart';
import '../../../../widgets/spacing/spacing.dart';

class HappyBirthdayWidget extends ConsumerWidget {
  const HappyBirthdayWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        Lottie.asset(
          'assets/animations/confetti.json',
          width: 313,
          height: 200,
          fit: BoxFit.fill,
        ),
        Container(
          height: 215,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage(
                'assets/images/complete_profile_logo.png',
              ),
              opacity: 0.08,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Uhuu! Hoje é o seu aniversário!!!',
                style: AppText.text()
                    .bodyLarge!
                    .copyWith(color: AppColor.tertiary),
              ),
              SpaceVertical.x1(),
              Text(
                'E nós desejamos que seu dia seja\ncheio de alegria,\nbênçãos e momentos incríveis. '
                'Deus te abençoe sempre! 🙌✨\n🎉 Feliz aniversário! 🎉',
                textAlign: TextAlign.center,
                style: AppText.text().bodyMedium!.copyWith(fontSize: 14),
              ),
              SpaceVertical.x1(),
              Text(
                'Pa ra bééénsss!!! 🎈',
                style: AppText.text()
                    .bodyLarge!
                    .copyWith(color: AppColor.tertiary),
              ),
            ],
          ),
        ),
        Positioned(
          right: 0,
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.close_outlined),
          ),
        ),
      ],
    );
  }
}
