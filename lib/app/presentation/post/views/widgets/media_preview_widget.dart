import 'dart:io';

import 'package:connect_umadim_app/app/core/style/app_colors.dart';
import 'package:connect_umadim_app/app/core/style/app_text.dart';
import 'package:flutter/material.dart';

import '../../../../core/style/app_decoration.dart';

class MediaPreviewWidget extends StatelessWidget {
  final File? mediaFile;
  final bool isVideo;
  final VoidCallback onPickMedia;
  final VoidCallback onRemove;

  const MediaPreviewWidget({
    super.key,
    required this.mediaFile,
    required this.isVideo,
    required this.onPickMedia,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (mediaFile != null) {
      return _buildPreview(context, isDark);
    }
    return _buildPickerButton(context, isDark);
  }

  // ── Preview da mídia selecionada ──────────────────────────────
  Widget _buildPreview(BuildContext context, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      height: 200,
      decoration: BoxDecoration(
        borderRadius: AppDecoration.radiusLg,
        color: AppColor.darkSurfaceVariant,
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Imagem ou ícone de vídeo
          isVideo
              ? _buildVideoPlaceholder(context)
              : Image.file(mediaFile!, fit: BoxFit.cover),

          // Overlay escuro no topo
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColor.dark950.withOpacity(0.6),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Botão remover
          Positioned(
            top: 10,
            right: 10,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColor.dark950.withOpacity(0.75),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close_rounded,
                  size: 16,
                  color: AppColor.light50,
                ),
              ),
            ),
          ),

          // Botão trocar mídia
          Positioned(
            bottom: 10,
            right: 10,
            child: GestureDetector(
              onTap: onPickMedia,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColor.dark950.withOpacity(0.75),
                  borderRadius: AppDecoration.radiusFull,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.swap_horiz_rounded,
                        size: 13, color: AppColor.light50),
                    const SizedBox(width: 4),
                    Text(
                      'Trocar',
                      style: AppText.labelSmall(context)
                          .copyWith(color: AppColor.light50),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPlaceholder(BuildContext context) {
    return Container(
      color: AppColor.darkSurfaceVariant,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.videocam_rounded,
              size: 48, color: AppColor.orange400),
          const SizedBox(height: 8),
          Text(
            'Vídeo selecionado',
            style: AppText.bodySmall(context)
                .copyWith(color: AppColor.darkOnSurface),
          ),
          Text(
            mediaFile!.path.split('/').last,
            style: AppText.labelSmall(context),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ── Botão para selecionar mídia ───────────────────────────────
  Widget _buildPickerButton(BuildContext context, bool isDark) {
    return GestureDetector(
      onTap: onPickMedia,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 28),
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: isDark
              ? AppColor.darkSurfaceVariant
              : AppColor.lightSurfaceVariant,
          borderRadius: AppDecoration.radiusLg,
          border: Border.all(
            color:
                isDark ? AppColor.darkBorderStrong : AppColor.lightBorderStrong,
            width: 1.5,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          children: [
            Icon(
              isVideo ? Icons.videocam_outlined : Icons.photo_library_outlined,
              size: 36,
              color: isDark
                  ? AppColor.darkOnSurfaceMuted
                  : AppColor.lightOnSurfaceMuted,
            ),
            const SizedBox(height: 8),
            Text(
              isVideo
                  ? 'Adicionar vídeo da galeria'
                  : 'Adicionar foto da galeria',
              style: AppText.bodySmall(context),
            ),
            const SizedBox(height: 4),
            Text(
              isVideo ? 'MP4, MOV · máx. 60s' : 'JPG, PNG · máx. 10MB',
              style: AppText.labelSmall(context),
            ),
          ],
        ),
      ),
    );
  }
}
