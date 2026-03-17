import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_umadim_app/app/core/supabase/supabase_init.dart';
import 'package:connect_umadim_app/app/core/style/app_colors.dart';
import 'package:connect_umadim_app/app/core/style/app_text.dart';
import 'package:connect_umadim_app/app/data/models/story_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_umadim_app/app/data/models/user_model.dart';
import 'package:flutter/material.dart';

import '../../../../core/style/app_decoration.dart';

class StoryViewersSheetWidget extends StatefulWidget {
  final StoryModel story;
  final VoidCallback onClose;

  const StoryViewersSheetWidget({
    super.key,
    required this.story,
    required this.onClose,
  });

  @override
  State<StoryViewersSheetWidget> createState() =>
      _StoryViewersSheetWidgetState();
}

class _StoryViewersSheetWidgetState extends State<StoryViewersSheetWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<Offset> _slideAnim;
  List<UserModel> _viewers = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
    _loadViewers();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _loadViewers() async {
    if (widget.story.viewerIds.isEmpty) {
      setState(() => _loading = false);
      return;
    }

    try {
      // Busca os dados dos usuários que visualizaram
      final snapshots = await Future.wait(
        widget.story.viewerIds.map((uid) =>
            FirebaseFirestore.instance.collection('users').doc(uid).get()),
      );

      final users = snapshots
          .where((s) => s.exists)
          .map((s) => UserModel.fromSnapShot(s))
          .toList();

      if (mounted)
        setState(() {
          _viewers = users;
          _loading = false;
        });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _close() {
    _animController.reverse().then((_) => widget.onClose());
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: _close,
        child: Container(
          color: Colors.black.withOpacity(0.5),
          child: SlideTransition(
            position: _slideAnim,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {}, // evita fechar ao tocar no sheet
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.6,
                  ),
                  decoration: const BoxDecoration(
                    color: AppColor.darkBackground,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                    border: Border(
                      top: BorderSide(color: AppColor.darkBorder),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Handle
                      Center(
                        child: Container(
                          width: 36,
                          height: 4,
                          margin: const EdgeInsets.only(top: 12),
                          decoration: BoxDecoration(
                            color: AppColor.darkBorderStrong,
                            borderRadius: AppDecoration.radiusFull,
                          ),
                        ),
                      ),

                      // Título
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                        child: Row(
                          children: [
                            const Text('👁', style: TextStyle(fontSize: 18)),
                            const SizedBox(width: 8),
                            Text(
                              '${widget.story.viewerIds.length} visualizações',
                              style: AppText.headlineSmall(context),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: _close,
                              child: Icon(Icons.close_rounded,
                                  size: 20, color: AppColor.darkOnSurfaceMuted),
                            ),
                          ],
                        ),
                      ),

                      const Divider(height: 1, color: AppColor.darkBorder),

                      // Lista de viewers
                      Flexible(
                        child: _loading
                            ? const Padding(
                                padding: EdgeInsets.all(32),
                                child: CircularProgressIndicator(
                                  color: AppColor.orange500,
                                  strokeWidth: 2,
                                ),
                              )
                            : _viewers.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(32),
                                    child: Text(
                                      'Nenhuma visualização ainda',
                                      style: AppText.bodySmall(context),
                                    ),
                                  )
                                : ListView.separated(
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.fromLTRB(
                                        16, 8, 16, 24),
                                    itemCount: _viewers.length,
                                    separatorBuilder: (_, __) => const Divider(
                                        height: 1, color: AppColor.darkBorder),
                                    itemBuilder: (_, i) =>
                                        _ViewerItem(user: _viewers[i]),
                                  ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ViewerItem extends StatelessWidget {
  final UserModel user;
  const _ViewerItem({required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppColor.wine700, AppColor.orange600],
              ),
            ),
            child: ClipOval(
              child: user.photoUrl != null &&
                      user.photoUrl!.isNotEmpty &&
                      isSupabaseImageUrlValid(user.photoUrl)
                  ? CachedNetworkImage(
                      imageUrl: user.photoUrl!,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => _fallback(user),
                    )
                  : _fallback(user),
            ),
          ),
          const SizedBox(width: 12),

          // Nome e congregação
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name, style: AppText.username(context)),
                Text(user.congregation, style: AppText.labelSmall(context)),
              ],
            ),
          ),

          const Icon(Icons.visibility_outlined,
              size: 16, color: AppColor.darkOnSurfaceMuted),
        ],
      ),
    );
  }

  Widget _fallback(UserModel user) => Container(
        color: AppColor.darkSurfaceVariant,
        child: Center(
          child: Text(
            user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
            style: const TextStyle(
              color: AppColor.light50,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
}
