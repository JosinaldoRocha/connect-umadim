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
        style: Theme.of(context).textTheme.titleMedium!.copyWith(color: AppColor.amber500),
      ),
      content: Text(
        'Essa ação não pode ser desfeita. Deseja continuar?',
        style: AppText.bodyMedium(context).copyWith(color: AppColor.amber500),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancelar',
            style: AppText.bodyLarge(context).copyWith(color: AppColor.amber500),
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
