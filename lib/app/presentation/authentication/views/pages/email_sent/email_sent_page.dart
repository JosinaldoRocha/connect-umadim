import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../../core/style/app_colors.dart';
import '../../../../../core/style/app_text.dart';
import '../../../../../widgets/spacing/spacing.dart';

class EmailSentPage extends StatelessWidget {
  const EmailSentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColor.tertiary),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: SizedBox(
                  height: 210,
                  width: 210,
                  child: Lottie.asset(
                    'assets/animations/email-successfully-sent.json',
                  ),
                ),
              ),
              Text(
                'E-mail enviado!',
                style: AppText.text().titleLarge!.copyWith(
                      color: AppColor.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SpaceVertical.x2(),
              Text(
                'Enviamos para seu e-mail um link para recuperação da sua senha!',
                textAlign: TextAlign.center,
                style: AppText.text().bodyMedium!,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
