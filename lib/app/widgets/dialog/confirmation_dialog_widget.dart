import 'package:connect_umadim_app/app/widgets/button/button_widget.dart';
import 'package:flutter/material.dart';

import '../../core/style/app_colors.dart';
import '../../core/style/app_text.dart';

class ConfirmationDialogWidget extends StatelessWidget {
  const ConfirmationDialogWidget({
    super.key,
    required this.onTap,
  });

  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Importante!',
        style: AppText.text().titleMedium!.copyWith(color: AppColor.tertiary),
      ),
      content: Text(
        'Essa ação não pode ser desfeita. Deseja continuar?',
        style: AppText.text().bodyMedium!.copyWith(color: AppColor.tertiary),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancelar',
            style: AppText.text().bodyLarge!.copyWith(color: AppColor.tertiary),
          ),
        ),
        ButtonWidget(
          height: 40,
          width: 130,
          onTap: onTap,
          title: 'Continuar',
        ),
      ],
    );
  }
}
