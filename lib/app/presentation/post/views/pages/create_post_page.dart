import 'dart:io';

import 'package:connect_umadim_app/app/core/auth/auth_permission_service.dart';
import 'package:connect_umadim_app/app/core/supabase/supabase_init.dart';
import 'package:connect_umadim_app/app/core/style/app_colors.dart';
import 'package:connect_umadim_app/app/core/style/app_text.dart';
import 'package:connect_umadim_app/app/data/enums/post_type_enum.dart';
import 'package:connect_umadim_app/app/data/models/user_model.dart';
import 'package:connect_umadim_app/app/widgets/snack_bar/app_snack_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/helpers/helpers.dart';
import '../../../../core/style/app_decoration.dart';
import '../../../user/providers/user_provider.dart';
import '../../provider/post_provider.dart';
import '../widgets/media_preview_widget.dart';
import '../widgets/poll_builder_widget.dart';
import '../widgets/post_type_selector_widget.dart';

class CreatePostPage extends ConsumerStatefulWidget {
  const CreatePostPage({super.key});

  @override
  ConsumerState<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends ConsumerState<CreatePostPage>
    with _CreatePostMixin, SingleTickerProviderStateMixin {
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
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userState = ref.watch(getUserProvider);
    final isLeader = ref.watch(isLeaderProvider);
    final createState = ref.watch(createPostProvider);

    // Navega de volta após publicar com sucesso
    ref.listen<CreatePostState>(createPostProvider, (_, next) {
      next.maybeWhen(
        loadSuccess: (_) {
          ref.read(createPostProvider.notifier).reset();
          Navigator.of(context).pop();
          AppSnackBar.show(
            context,
            'Publicação criada com sucesso! 🎉',
            AppColor.success,
          );
        },
        loadFailure: (err) {
          AppSnackBar.show(
            context,
            'Erro ao publicar. Tente novamente.',
            AppColor.error,
          );
        },
        orElse: () {},
      );
    });

    return Scaffold(
      backgroundColor:
          isDark ? AppColor.darkBackground : AppColor.lightBackground,
      appBar: _buildAppBar(context, isDark, createState),
      body: userState.maybeWhen(
        loadSuccess: (user) => FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: _buildBody(context, isDark, user, isLeader, createState),
          ),
        ),
        orElse: () => const Center(
          child: CircularProgressIndicator(color: AppColor.orange500),
        ),
      ),
    );
  }

  // ── AppBar ────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    bool isDark,
    CreatePostState createState,
  ) {
    final isLoading = createState is CommonStateLoadInProgress;

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
        onPressed: () => _confirmDiscard(context),
      ),
      title: Text('Nova publicação', style: AppText.headlineMedium(context)),
      centerTitle: false,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: AnimatedOpacity(
            opacity: isPublishEnabled && !isLoading ? 1.0 : 0.4,
            duration: const Duration(milliseconds: 200),
            child: GestureDetector(
              onTap: isPublishEnabled && !isLoading
                  ? () => _onPublish(context, ref)
                  : null,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                decoration: BoxDecoration(
                  gradient: isPublishEnabled ? AppColor.flamePrimary : null,
                  color: isPublishEnabled
                      ? null
                      : (isDark
                          ? AppColor.darkSurfaceVariant
                          : AppColor.lightSurfaceVariant),
                  borderRadius: AppDecoration.radiusFull,
                  boxShadow:
                      isPublishEnabled ? AppDecoration.shadowOrangeSm : null,
                ),
                child: isLoading
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

  // ── Body ──────────────────────────────────────────────────────

  Widget _buildBody(
    BuildContext context,
    bool isDark,
    UserModel user,
    bool isLeader,
    CreatePostState createState,
  ) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
            children: [
              // Autor
              _buildAuthorRow(context, isDark, user, isLeader),
              const SizedBox(height: 16),

              // Seletor de tipo
              PostTypeSelectorWidget(
                selectedType: selectedType,
                isLeader: isLeader,
                onSelected: (type) {
                  setState(() {
                    selectedType = type;
                    mediaFile = null;
                    pollOptions = ['', ''];
                  });
                  checkPublishEnabled();
                },
              ),
              const SizedBox(height: 14),

              // Badge de líder
              if (isLeader) _buildLeaderBadge(context),

              // Textarea
              _buildTextarea(context, isDark),
              const SizedBox(height: 14),

              // Upload de mídia (foto/vídeo)
              if (selectedType == PostType.photo ||
                  selectedType == PostType.video)
                MediaPreviewWidget(
                  mediaFile: mediaFile,
                  isVideo: selectedType == PostType.video,
                  onPickMedia: () => pickMedia(
                    selectedType == PostType.video
                        ? ImageSource.gallery
                        : ImageSource.gallery,
                    isVideo: selectedType == PostType.video,
                    onPicked: (file) {
                      setState(() => mediaFile = file);
                      checkPublishEnabled();
                    },
                  ),
                  onRemove: () {
                    setState(() => mediaFile = null);
                    checkPublishEnabled();
                  },
                ),

              // Construtor de enquete
              if (selectedType == PostType.poll)
                PollBuilderWidget(
                  options: pollOptions,
                  pollEndsAt: pollEndsAt,
                  onOptionsChanged: (opts) {
                    setState(() => pollOptions = opts);
                    checkPublishEnabled();
                  },
                  onExpiryChanged: (dt) => setState(() => pollEndsAt = dt),
                ),
            ],
          ),
        ),

        // Toolbar de mídia rápida (só para tipos com mídia)
        if (selectedType != PostType.poll) _buildMediaToolbar(context, isDark),
      ],
    );
  }

  // ── Widgets auxiliares ────────────────────────────────────────

  Widget _buildAuthorRow(
    BuildContext context,
    bool isDark,
    UserModel user,
    bool isLeader,
  ) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            borderRadius: AppDecoration.radiusMd,
            gradient: const LinearGradient(
                colors: [AppColor.wine700, AppColor.orange600]),
          ),
          child: user.photoUrl != null &&
                  user.photoUrl!.isNotEmpty &&
                  isSupabaseImageUrlValid(user.photoUrl)
              ? ClipRRect(
                  borderRadius: AppDecoration.radiusMd,
                  child: Image.network(
                    user.photoUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Center(
                      child: Text(
                        user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                        style: AppText.labelLarge(context)
                            .copyWith(color: AppColor.light50),
                      ),
                    ),
                  ),
                )
              : Center(
                  child: Text(
                    user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                    style: AppText.labelLarge(context)
                        .copyWith(color: AppColor.light50),
                  ),
                ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.name, style: AppText.username(context)),
            Text(
              '${user.congregation} · ${user.areaId}',
              style: AppText.labelSmall(context),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLeaderBadge(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColor.amber500.withOpacity(0.07),
        borderRadius: AppDecoration.radiusMd,
        border: Border.all(color: AppColor.amber500.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.verified_rounded,
              size: 15, color: AppColor.amber400),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              'Postando como líder — aviso, evento e enquete disponíveis',
              style: AppText.labelSmall(context).copyWith(
                color: AppColor.amber300,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextarea(BuildContext context, bool isDark) {
    final placeholders = {
      PostType.message: 'O que você quer compartilhar?',
      PostType.photo: 'Escreva uma legenda para a foto...',
      PostType.video: 'Escreva uma descrição para o vídeo...',
      PostType.notice: 'Escreva o aviso para os jovens...',
      PostType.event: 'Descreva o evento, local e horário...',
      PostType.poll: 'Faça uma pergunta para os jovens...',
    };

    return Stack(
      children: [
        TextField(
          controller: contentController,
          maxLines: null,
          maxLength: 500,
          buildCounter: (_,
                  {required currentLength, maxLength, required isFocused}) =>
              null,
          style: AppText.bodyMedium(context),
          decoration: InputDecoration(
            hintText: placeholders[selectedType] ?? '',
            hintStyle: AppText.bodyMedium(context).copyWith(
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
          onChanged: (_) => checkPublishEnabled(),
        ),
        // Contador de caracteres
        Positioned(
          bottom: 10,
          right: 12,
          child: ValueListenableBuilder<TextEditingValue>(
            valueListenable: contentController,
            builder: (_, value, __) => Text(
              '${value.text.length}/500',
              style: AppText.labelSmall(context),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMediaToolbar(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 32),
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkBackground : AppColor.lightBackground,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
          ),
        ),
      ),
      child: Row(
        children: [
          _MediaActionButton(
            icon: Icons.photo_library_outlined,
            label: 'Foto',
            onTap: () {
              setState(() => selectedType = PostType.photo);
              pickMedia(
                ImageSource.gallery,
                isVideo: false,
                onPicked: (file) {
                  setState(() => mediaFile = file);
                  checkPublishEnabled();
                },
              );
            },
          ),
          const SizedBox(width: 10),
          _MediaActionButton(
            icon: Icons.videocam_outlined,
            label: 'Vídeo',
            onTap: () {
              setState(() => selectedType = PostType.video);
              pickMedia(
                ImageSource.gallery,
                isVideo: true,
                onPicked: (file) {
                  setState(() => mediaFile = file);
                  checkPublishEnabled();
                },
              );
            },
          ),
        ],
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────

  void _onPublish(BuildContext context, WidgetRef ref) {
    final userAsync = ref.read(getUserProvider);
    userAsync.maybeWhen(
      loadSuccess: (user) {
        ref.read(createPostProvider.notifier).create(
              type: selectedType,
              content: contentController.text.trim(),
              congregation: user.congregation,
              areaId: user.areaId,
              mediaFile: mediaFile,
              pollOptionTexts: selectedType == PostType.poll
                  ? pollOptions.where((o) => o.isNotEmpty).toList()
                  : null,
              pollEndsAt: pollEndsAt,
            );
      },
      orElse: () {},
    );
  }

  Future<void> _confirmDiscard(BuildContext context) async {
    final hasContent = contentController.text.isNotEmpty || mediaFile != null;
    if (!hasContent) {
      Navigator.of(context).pop();
      return;
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: isDark ? AppColor.darkSurface : AppColor.lightSurface,
        title: Text('Descartar publicação?',
            style: AppText.headlineSmall(context)),
        content: Text(
          'O conteúdo que você escreveu será perdido.',
          style: AppText.bodySmall(context),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Continuar editando',
                style: TextStyle(color: AppColor.orange500)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Descartar', style: TextStyle(color: AppColor.error)),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      Navigator.of(context).pop();
    }
  }
}

// ── Mixin com estado e lógica do formulário ────────────────────

mixin _CreatePostMixin on ConsumerState<CreatePostPage> {
  late final TextEditingController contentController;
  late PostType selectedType;
  File? mediaFile;
  late List<String> pollOptions;
  DateTime? pollEndsAt;
  late bool isPublishEnabled;

  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    contentController = TextEditingController();
    selectedType = PostType.message;
    pollOptions = ['', ''];
    isPublishEnabled = false;
  }

  @override
  void dispose() {
    contentController.dispose();
    super.dispose();
  }

  void checkPublishEnabled() {
    final hasContent = contentController.text.trim().isNotEmpty;

    final valid = switch (selectedType) {
      PostType.photo => hasContent && mediaFile != null,
      PostType.video => hasContent && mediaFile != null,
      PostType.poll =>
        hasContent && pollOptions.where((o) => o.trim().isNotEmpty).length >= 2,
      _ => hasContent,
    };

    if (valid != isPublishEnabled) {
      setState(() => isPublishEnabled = valid);
    }
  }

  Future<void> pickMedia(
    ImageSource source, {
    required bool isVideo,
    required void Function(File file) onPicked,
  }) async {
    try {
      final XFile? picked = isVideo
          ? await _picker.pickVideo(source: source)
          : await _picker.pickImage(
              source: source,
              imageQuality: 85,
              maxWidth: 1920,
            );

      if (picked != null) {
        onPicked(File(picked.path));
      }
    } catch (e) {
      debugPrint('Erro ao selecionar mídia: $e');
    }
  }
}

// ── Botão de ação rápida de mídia ─────────────────────────────

class _MediaActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MediaActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: isDark
              ? AppColor.darkSurfaceVariant
              : AppColor.lightSurfaceVariant,
          borderRadius: AppDecoration.radiusFull,
          border: Border.all(
            color:
                isDark ? AppColor.darkBorderStrong : AppColor.lightBorderStrong,
          ),
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 16,
                color:
                    isDark ? AppColor.darkOnSurface : AppColor.lightOnSurface),
            const SizedBox(width: 6),
            Text(label, style: AppText.labelMedium(context)),
          ],
        ),
      ),
    );
  }
}
