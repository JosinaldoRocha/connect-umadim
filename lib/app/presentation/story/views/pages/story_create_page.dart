import 'dart:io';

import 'package:connect_umadim_app/app/core/style/app_colors.dart';
import 'package:connect_umadim_app/app/core/style/app_text.dart';
import 'package:connect_umadim_app/app/presentation/user/providers/user_provider.dart';
import 'package:connect_umadim_app/app/widgets/snack_bar/app_snack_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/style/app_decoration.dart';
import '../../provider/story_provider.dart';

class CreateStoryPage extends ConsumerStatefulWidget {
  const CreateStoryPage({super.key});

  @override
  ConsumerState<CreateStoryPage> createState() => _CreateStoryPageState();
}

class _CreateStoryPageState extends ConsumerState<CreateStoryPage>
    with SingleTickerProviderStateMixin {
  final _captionController = TextEditingController();
  final _picker = ImagePicker();

  File? _imageFile;
  bool _isLoading = false;

  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    ));
    _animController.forward();
  }

  @override
  void dispose() {
    _captionController.dispose();
    _animController.dispose();
    super.dispose();
  }

  // ── Seleção de imagem ─────────────────────────────────────

  Future<void> _pickFromCamera() async {
    final picked = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
      maxWidth: 1080,
    );
    if (picked != null) setState(() => _imageFile = File(picked.path));
  }

  Future<void> _pickFromGallery() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1080,
    );
    if (picked != null) setState(() => _imageFile = File(picked.path));
  }

  void _removeImage() => setState(() => _imageFile = null);

  bool get _canPublish => _imageFile != null && !_isLoading;

  // ── Publicar ──────────────────────────────────────────────

  Future<void> _publish() async {
    if (!_canPublish) return;

    final userState = ref.read(getUserProvider);
    userState.maybeWhen(
      loadInProgress: () {
        AppSnackBar.show(
          context,
          'Carregando dados do usuário, aguarde...',
          AppColor.orange500,
        );
      },
      loadFailure: (_) {
        AppSnackBar.show(
          context,
          'Erro ao carregar seu perfil. Faça logout e entre novamente.',
          AppColor.error,
        );
      },
      loadSuccess: (user) async {
        setState(() => _isLoading = true);

        await ref.read(createStoryProvider.notifier).create(
              mediaFile: _imageFile!,
              mediaType: 'image',
              congregation: user.congregation,
              areaId: user.areaId,
              caption: _captionController.text.trim().isEmpty
                  ? null
                  : _captionController.text.trim(),
            );

        if (!mounted) return;
        setState(() => _isLoading = false);

        final state = ref.read(createStoryProvider);
        state.maybeWhen(
          loadSuccess: (_) {
            ref.read(createStoryProvider.notifier).reset();
            Navigator.of(context).pop();
            AppSnackBar.show(
              context,
              'Story publicado! Ficará disponível por 24h 🎉',
              AppColor.success,
            );
          },
          loadFailure: (_) {
            AppSnackBar.show(
              context,
              'Erro ao publicar o story. Tente novamente.',
              AppColor.error,
            );
          },
          orElse: () {},
        );
      },
      orElse: () {},
    );
  }

  // ── Build ─────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColor.darkBackground : AppColor.lightBackground,
      appBar: _buildAppBar(context, isDark),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SlideTransition(
          position: _slideAnim,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Área de imagem
              _imageFile == null
                  ? _buildPickArea(context, isDark)
                  : _buildPreview(context, isDark),

              const SizedBox(height: 14),

              // Botões câmera / galeria
              _buildSourceButtons(context, isDark),

              const SizedBox(height: 16),

              // Legenda
              _buildCaptionField(context, isDark),

              const SizedBox(height: 14),

              // Dica de expiração
              _buildTip(context, isDark),
            ],
          ),
        ),
      ),
    );
  }

  // ── AppBar ────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isDark) {
    return AppBar(
      backgroundColor:
          isDark ? AppColor.darkBackground : AppColor.lightBackground,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: isDark
                ? AppColor.darkSurfaceVariant
                : AppColor.lightSurfaceVariant,
            borderRadius: AppDecoration.radiusMd,
            border: Border.all(
              color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
            ),
          ),
          child: Icon(
            Icons.close_rounded,
            size: 16,
            color:
                isDark ? AppColor.darkOnBackground : AppColor.lightOnBackground,
          ),
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text('Novo story', style: AppText.headlineMedium(context)),
      centerTitle: false,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: AnimatedOpacity(
            opacity: _canPublish ? 1.0 : 0.4,
            duration: const Duration(milliseconds: 200),
            child: GestureDetector(
              onTap: _canPublish ? _publish : null,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                decoration: BoxDecoration(
                  gradient: _canPublish ? AppColor.flamePrimary : null,
                  color: _canPublish
                      ? null
                      : (isDark
                          ? AppColor.darkSurfaceVariant
                          : AppColor.lightSurfaceVariant),
                  borderRadius: AppDecoration.radiusFull,
                  boxShadow: _canPublish ? AppDecoration.shadowOrangeSm : null,
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColor.light50,
                        ),
                      )
                    : Text(
                        'Publicar',
                        style: AppText.labelLarge(context).copyWith(
                          color: AppColor.light50,
                          fontSize: 13,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              AppColor.orange600,
              AppColor.orange400,
              AppColor.amber400,
            ]),
          ),
        ),
      ),
    );
  }

  // ── Área de seleção (sem imagem) ──────────────────────────

  Widget _buildPickArea(BuildContext context, bool isDark) {
    return GestureDetector(
      onTap: _pickFromGallery,
      child: AspectRatio(
        aspectRatio: 9 / 14,
        child: Container(
          decoration: BoxDecoration(
            color: isDark
                ? AppColor.darkSurfaceVariant
                : AppColor.lightSurfaceVariant,
            borderRadius: AppDecoration.radiusXl,
            border: Border.all(
              color: isDark
                  ? AppColor.darkBorderStrong
                  : AppColor.lightBorderStrong,
              width: 1.5,
              style: BorderStyle.solid,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_photo_alternate_outlined,
                size: 52,
                color: isDark
                    ? AppColor.darkOnSurfaceMuted
                    : AppColor.lightOnSurfaceMuted,
              ),
              const SizedBox(height: 14),
              Text(
                'Toque para adicionar\numa foto ao seu story',
                textAlign: TextAlign.center,
                style: AppText.bodySmall(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Preview da imagem selecionada ─────────────────────────

  Widget _buildPreview(BuildContext context, bool isDark) {
    return AspectRatio(
      aspectRatio: 9 / 14,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: AppDecoration.radiusXl,
            child: Image.file(
              _imageFile!,
              fit: BoxFit.cover,
            ),
          ),

          // Overlay gradiente
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: AppDecoration.radiusXl,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.2),
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
              onTap: _removeImage,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.6),
                ),
                child: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),

          // Botão trocar foto
          Positioned(
            bottom: 12,
            right: 12,
            child: GestureDetector(
              onTap: _pickFromGallery,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.55),
                  borderRadius: AppDecoration.radiusFull,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.swap_horiz_rounded,
                        size: 13, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(
                      'Trocar',
                      style: AppText.labelSmall(context)
                          .copyWith(color: Colors.white),
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

  // ── Botões de origem ──────────────────────────────────────

  Widget _buildSourceButtons(BuildContext context, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _SourceButton(
            icon: Icons.camera_alt_outlined,
            label: 'Câmera',
            isDark: isDark,
            isActive: false,
            onTap: _pickFromCamera,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _SourceButton(
            icon: Icons.photo_library_outlined,
            label: 'Galeria',
            isDark: isDark,
            isActive: _imageFile != null,
            onTap: _pickFromGallery,
          ),
        ),
      ],
    );
  }

  // ── Campo de legenda ──────────────────────────────────────

  Widget _buildCaptionField(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Legenda (opcional)',
          style: AppText.labelMedium(context).copyWith(
            color: isDark ? AppColor.light200 : AppColor.lightOnSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _captionController,
          maxLines: 3,
          maxLength: 150,
          buildCounter: (_,
                  {required currentLength, maxLength, required isFocused}) =>
              null,
          style: AppText.bodySmall(context).copyWith(fontSize: 13),
          decoration: InputDecoration(
            hintText: 'Escreva algo sobre esse momento...',
            hintStyle: AppText.bodySmall(context).copyWith(
              color: isDark
                  ? AppColor.darkOnSurfaceMuted
                  : AppColor.lightOnSurfaceMuted,
            ),
            filled: true,
            fillColor: isDark
                ? AppColor.darkSurfaceVariant
                : AppColor.lightSurfaceVariant,
            border: OutlineInputBorder(
              borderRadius: AppDecoration.radiusMd,
              borderSide: BorderSide(
                color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppDecoration.radiusMd,
              borderSide: BorderSide(
                color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppDecoration.radiusMd,
              borderSide: const BorderSide(color: AppColor.orange500),
            ),
            contentPadding: const EdgeInsets.all(14),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '${_captionController.text.length}/150',
            style: AppText.labelSmall(context),
          ),
        ),
      ],
    );
  }

  // ── Dica de expiração ─────────────────────────────────────

  Widget _buildTip(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColor.orange500.withOpacity(0.07),
        borderRadius: AppDecoration.radiusMd,
        border: Border.all(
          color: AppColor.orange500.withOpacity(0.15),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.timer_outlined, size: 16, color: AppColor.orange400),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Seu story ficará disponível por 24 horas e depois desaparecerá automaticamente.',
              style: AppText.bodySmall(context).copyWith(
                color: isDark ? AppColor.orange300 : AppColor.orange600,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Botão de origem ───────────────────────────────────────────

class _SourceButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;
  final bool isActive;
  final VoidCallback onTap;

  const _SourceButton({
    required this.icon,
    required this.label,
    required this.isDark,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive
              ? AppColor.orange500.withOpacity(0.08)
              : (isDark
                  ? AppColor.darkSurfaceVariant
                  : AppColor.lightSurfaceVariant),
          borderRadius: AppDecoration.radiusMd,
          border: Border.all(
            color: isActive
                ? AppColor.orange500
                : (isDark
                    ? AppColor.darkBorderStrong
                    : AppColor.lightBorderStrong),
            width: isActive ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isActive
                  ? AppColor.orange500
                  : (isDark
                      ? AppColor.darkOnSurfaceMuted
                      : AppColor.lightOnSurfaceMuted),
            ),
            const SizedBox(width: 7),
            Text(
              label,
              style: AppText.labelMedium(context).copyWith(
                color: isActive
                    ? AppColor.orange500
                    : (isDark
                        ? AppColor.darkOnSurfaceMuted
                        : AppColor.lightOnSurfaceMuted),
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
