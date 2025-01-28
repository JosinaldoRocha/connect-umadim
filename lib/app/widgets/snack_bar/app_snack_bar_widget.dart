import 'package:flutter/material.dart';

import '../../core/style/app_colors.dart';

class AppSnackBar {
  static void show(
    BuildContext context,
    String title,
    Color bgColor,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: bgColor,
        content: Text(
          title,
          style: const TextStyle(color: AppColor.white),
        ),
      ),
    );
  }
}
