import 'package:flutter/material.dart';

import '../../core/style/app_colors.dart';
import '../../core/style/app_decoration.dart';
import '../../core/style/app_text.dart';

class TimeSelectorWidget extends StatelessWidget {
  const TimeSelectorWidget({
    super.key,
    required this.date,
    required this.onTap,
    required this.hintText,
    required this.onClean,
  });

  final DateTime? date;
  final Function() onTap;
  final String hintText;
  final Function() onClean;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasTime = date != null;

    final fillColor =
        isDark ? AppColor.darkSurfaceVariant : AppColor.lightSurfaceVariant;
    final borderColor = hasTime
        ? (isDark ? AppColor.darkBorder : AppColor.lightBorder)
        : AppColor.error;
    final textColor = hasTime
        ? (isDark ? AppColor.darkOnBackground : AppColor.lightOnBackground)
        : (isDark ? AppColor.darkOnSurfaceMuted : AppColor.lightOnSurfaceMuted);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: AppDecoration.radiusMd,
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              hasTime
                  ? '${TimeOfDay.fromDateTime(date!).format(context)}h'
                  : hintText,
              style: AppText.bodyMedium(context).copyWith(color: textColor),
            ),
            hasTime
                ? GestureDetector(
                    onTap: onClean,
                    child: Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: isDark
                          ? AppColor.darkOnSurfaceMuted
                          : AppColor.lightOnSurfaceMuted,
                    ),
                  )
                : Icon(
                    Icons.access_time_rounded,
                    size: 18,
                    color: isDark
                        ? AppColor.darkOnSurfaceMuted
                        : AppColor.lightOnSurfaceMuted,
                  ),
          ],
        ),
      ),
    );
  }
}
