import 'package:connect_umadim_app/app/core/style/app_colors.dart';
import 'package:connect_umadim_app/app/core/style/app_text.dart';
import 'package:connect_umadim_app/app/data/models/verse_model.dart';
import 'package:flutter/material.dart';

import '../../../../core/style/app_decoration.dart';

class VerseCardWidget extends StatelessWidget {
  final VerseModel verse;
  const VerseCardWidget({super.key, required this.verse});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 10),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        borderRadius: AppDecoration.radiusLg,
        gradient: isDark
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColor.wine800, AppColor.dark800],
              )
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColor.wine600.withOpacity(0.07),
                  AppColor.orange500.withOpacity(0.04),
                ],
              ),
        border: Border.all(
          color: isDark
              ? AppColor.wine600.withOpacity(0.4)
              : AppColor.wine600.withOpacity(0.15),
        ),
      ),
      child: Stack(
        children: [
          // Aspa decorativa
          Positioned(
            top: -12,
            left: -4,
            child: Text(
              '"',
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 80,
                height: 1,
                color: AppColor.orange500.withOpacity(0.12),
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Badge "Versículo do dia"
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColor.orange500.withOpacity(0.15),
                  borderRadius: AppDecoration.radiusFull,
                  border: Border.all(
                    color: AppColor.orange500.withOpacity(0.25),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('✦',
                        style:
                            TextStyle(fontSize: 9, color: AppColor.orange300)),
                    const SizedBox(width: 5),
                    Text(
                      'VERSÍCULO DO DIA',
                      style: AppText.labelSmall(context).copyWith(
                        color: AppColor.orange300,
                        letterSpacing: 0.08,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Texto do versículo
              Text(
                verse.text,
                style: AppText.verse(context).copyWith(
                  color: isDark ? AppColor.light200 : AppColor.lightOnSurface,
                ),
              ),
              const SizedBox(height: 8),

              // Referência
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  verse.reference,
                  style: AppText.labelMedium(context).copyWith(
                    color: AppColor.orange400,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
