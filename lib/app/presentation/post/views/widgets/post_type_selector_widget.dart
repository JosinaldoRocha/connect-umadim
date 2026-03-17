import 'package:connect_umadim_app/app/core/style/app_colors.dart';
import 'package:connect_umadim_app/app/core/style/app_text.dart';
import 'package:connect_umadim_app/app/data/enums/post_type_enum.dart';
import 'package:flutter/material.dart';

import '../../../../core/style/app_decoration.dart';

class PostTypeSelectorWidget extends StatelessWidget {
  final PostType selectedType;
  final bool isLeader;
  final void Function(PostType) onSelected;

  const PostTypeSelectorWidget({
    super.key,
    required this.selectedType,
    required this.isLeader,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Tipos disponíveis baseados no role
    final types = [
      _TypeConfig(PostType.message, '✍️', 'Texto', false),
      _TypeConfig(PostType.photo, '📸', 'Foto', false),
      _TypeConfig(PostType.video, '🎥', 'Vídeo', false),
      if (isLeader) ...[
        _TypeConfig(PostType.notice, '📢', 'Aviso', true),
        _TypeConfig(PostType.event, '📅', 'Evento', true),
        _TypeConfig(PostType.poll, '📊', 'Enquete', true),
      ],
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TIPO DE PUBLICAÇÃO',
          style: AppText.labelSmall(context).copyWith(
            letterSpacing: 0.1,
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: types.asMap().entries.map((entry) {
              final i = entry.key;
              final config = entry.value;
              return Padding(
                padding: EdgeInsets.only(right: i < types.length - 1 ? 8 : 0),
                child: _TypeChip(
                  config: config,
                  isSelected: selectedType == config.type,
                  onTap: () => onSelected(config.type),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _TypeChip extends StatelessWidget {
  final _TypeConfig config;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeChip({
    required this.config,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Cores diferenciadas para tipos de líder
    final activeColor =
        config.isLeaderOnly ? AppColor.amber400 : AppColor.orange500;
    final activeBg = config.isLeaderOnly
        ? AppColor.amber500.withOpacity(0.15)
        : AppColor.orange500.withOpacity(0.15);
    final activeBorder =
        config.isLeaderOnly ? AppColor.amber400 : AppColor.orange500;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? activeBg
              : (isDark
                  ? AppColor.darkSurfaceVariant
                  : AppColor.lightSurfaceVariant),
          borderRadius: AppDecoration.radiusFull,
          border: Border.all(
            color: isSelected
                ? activeBorder
                : (isDark
                    ? AppColor.darkBorderStrong
                    : AppColor.lightBorderStrong),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(config.emoji, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 5),
            Text(
              config.label,
              style: AppText.labelMedium(context).copyWith(
                color: isSelected
                    ? activeColor
                    : (isDark
                        ? AppColor.darkOnSurfaceMuted
                        : AppColor.lightOnSurfaceMuted),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypeConfig {
  final PostType type;
  final String emoji;
  final String label;
  final bool isLeaderOnly;

  const _TypeConfig(this.type, this.emoji, this.label, this.isLeaderOnly);
}
