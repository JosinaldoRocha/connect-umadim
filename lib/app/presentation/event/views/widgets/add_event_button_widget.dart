import 'package:connect_umadim_app/app/core/style/app_colors.dart';
import 'package:connect_umadim_app/app/core/style/app_text.dart';
import 'package:flutter/material.dart';

/// Botão para adicionar novo evento, seguindo o padrão de design
/// (borda branca, texto branco, cantos arredondados).
class AddEventButtonWidget extends StatelessWidget {
  const AddEventButtonWidget({
    super.key,
    required this.onTap,
    this.compact = false,
  });

  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppColor.light50 : AppColor.wine800;
    final textColor = isDark ? AppColor.light50 : AppColor.wine800;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: borderColor),
            boxShadow: isDark
                ? [
                    BoxShadow(
                      color: AppColor.orange500.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.add_rounded,
                size: compact ? 18 : 20,
                color: textColor,
              ),
              SizedBox(width: compact ? 6 : 8),
              Text(
                compact ? 'Adicionar' : 'Adicionar evento',
                style: AppText.labelLarge(context).copyWith(
                  color: textColor,
                  fontSize: compact ? 13 : 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
