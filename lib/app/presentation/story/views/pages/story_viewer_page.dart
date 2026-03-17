import 'package:connect_umadim_app/app/core/style/app_colors.dart';
import 'package:connect_umadim_app/app/data/models/story_model.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/story_provider.dart';
import '../widgets/story_header_widget.dart';
import '../widgets/story_progress_bar_widget.dart';
import '../widgets/story_reactions_widget.dart';
import '../widgets/story_reply_bar_widget.dart';
import '../widgets/story_viewers_sheet_widget.dart';

/// Argumentos passados via Navigator para a tela de stories
class StoryViewerArgs {
  final List<StoryGroup> groups;
  final int initialGroupIndex;
  final String currentUid;

  const StoryViewerArgs({
    required this.groups,
    required this.initialGroupIndex,
    required this.currentUid,
  });
}

class StoryViewerPage extends ConsumerStatefulWidget {
  const StoryViewerPage({super.key});

  @override
  ConsumerState<StoryViewerPage> createState() => _StoryViewerPageState();
}

class _StoryViewerPageState extends ConsumerState<StoryViewerPage>
    with SingleTickerProviderStateMixin {
  late StoryViewerArgs _args;
  late int _groupIndex;
  late int _storyIndex;
  bool _argsLoaded = false;

  // Animação da barra de progresso
  late AnimationController _progressController;

  // Duração de cada story (imagem = 5s)
  static const _storyDuration = Duration(seconds: 5);

  // Estado da UI
  bool _isPaused = false;
  bool _showViewers = false;
  bool _liked = false;

  StoryGroup get _currentGroup => _args.groups[_groupIndex];
  StoryModel get _currentStory => _currentGroup.stories[_storyIndex];
  bool get _isAuthor => _currentStory.authorId == _args.currentUid;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(vsync: this);
    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) _onStoryComplete();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_argsLoaded) {
      final args =
          ModalRoute.of(context)!.settings.arguments as StoryViewerArgs;
      _args = args;
      _groupIndex = args.initialGroupIndex;
      _storyIndex = 0;
      _argsLoaded = true;
      _startStory();
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  // ── Navegação ─────────────────────────────────────────────

  void _startStory() {
    _liked = false;
    _progressController.stop();
    _progressController.reset();
    _progressController.duration = _storyDuration;
    _progressController.forward();

    // Marca como visto
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (!_currentStory.isViewedBy(uid)) {
      ref.read(markStoryViewedProvider(_currentStory.id));
    }
  }

  void _onStoryComplete() {
    // Avança para o próximo story dentro do grupo
    if (_storyIndex < _currentGroup.stories.length - 1) {
      setState(() => _storyIndex++);
      _startStory();
      return;
    }

    // Avança para o próximo grupo
    if (_groupIndex < _args.groups.length - 1) {
      setState(() {
        _groupIndex++;
        _storyIndex = 0;
      });
      _startStory();
      return;
    }

    // Todos os stories acabaram
    if (mounted) Navigator.of(context).pop();
  }

  void _goNext() {
    if (_storyIndex < _currentGroup.stories.length - 1) {
      setState(() => _storyIndex++);
      _startStory();
    } else if (_groupIndex < _args.groups.length - 1) {
      setState(() {
        _groupIndex++;
        _storyIndex = 0;
      });
      _startStory();
    } else {
      Navigator.of(context).pop();
    }
  }

  void _goPrev() {
    if (_storyIndex > 0) {
      setState(() => _storyIndex--);
      _startStory();
    } else if (_groupIndex > 0) {
      setState(() {
        _groupIndex--;
        _storyIndex = _currentGroup.stories.length - 1;
      });
      _startStory();
    }
  }

  void _pause() {
    if (!_isPaused) {
      _progressController.stop();
      setState(() => _isPaused = true);
    }
  }

  void _resume() {
    if (_isPaused) {
      _progressController.forward();
      setState(() => _isPaused = false);
    }
  }

  void _openViewers() {
    _pause();
    setState(() => _showViewers = true);
  }

  void _closeViewers() {
    setState(() => _showViewers = false);
    _resume();
  }

  void _toggleLike() {
    setState(() => _liked = !_liked);
    HapticFeedback.lightImpact();
  }

  // ── Build ─────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (!_argsLoaded) return const SizedBox.shrink();

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onLongPressStart: (_) => _pause(),
        onLongPressEnd: (_) => _resume(),
        child: Stack(
          children: [
            // ── Imagem do story ──────────────────────────────
            _buildStoryImage(),

            // ── Overlay de gradiente ─────────────────────────
            _buildGradientOverlay(),

            // ── Barras de progresso ──────────────────────────
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: StoryProgressBarWidget(
                totalStories: _currentGroup.stories.length,
                currentIndex: _storyIndex,
                progressController: _progressController,
              ),
            ),

            // ── Header: avatar + nome + fechar ───────────────
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: StoryHeaderWidget(
                group: _currentGroup,
                story: _currentStory,
                groupsCount: _args.groups.length,
                currentGroupIndex: _groupIndex,
                onClose: () => Navigator.of(context).pop(),
              ),
            ),

            // ── Zonas de toque prev/next ─────────────────────
            _buildTapZones(),

            // ── Legenda ──────────────────────────────────────
            if (_currentStory.caption != null &&
                _currentStory.caption!.isNotEmpty)
              Positioned(
                bottom: 100,
                left: 16,
                right: 72,
                child: Text(
                  _currentStory.caption!,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: Colors.white,
                    height: 1.5,
                    shadows: [
                      Shadow(
                          color: Colors.black54,
                          blurRadius: 8,
                          offset: Offset(0, 1))
                    ],
                  ),
                ),
              ),

            // ── Botão de visualizações (só para o autor) ─────
            if (_isAuthor)
              Positioned(
                bottom: 80,
                left: 0,
                right: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: _openViewers,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(99),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.15),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('👁', style: TextStyle(fontSize: 14)),
                          const SizedBox(width: 6),
                          Text(
                            '${_currentStory.viewerIds.length} visualizações',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            // ── Reações + curtir ─────────────────────────────
            Positioned(
              bottom: 56,
              left: 14,
              right: 14,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StoryReactionsWidget(
                    story: _currentStory,
                    currentUid: _args.currentUid,
                    onReact: (_) => HapticFeedback.lightImpact(),
                  ),
                  // Curtir
                  GestureDetector(
                    onTap: _toggleLike,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: (child, anim) =>
                          ScaleTransition(scale: anim, child: child),
                      child: Text(
                        _liked ? '❤️' : '🤍',
                        key: ValueKey(_liked),
                        style: const TextStyle(fontSize: 26),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Barra de resposta ────────────────────────────
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: StoryReplyBarWidget(
                story: _currentStory,
                onFocusChanged: (focused) => focused ? _pause() : _resume(),
                onSend: (_) => _resume(),
              ),
            ),

            // ── Sheet de visualizações ───────────────────────
            if (_showViewers)
              StoryViewersSheetWidget(
                story: _currentStory,
                onClose: _closeViewers,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryImage() {
    return Positioned.fill(
      child: _currentStory.mediaUrl.isNotEmpty
          ? Image.network(
              _currentStory.mediaUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _buildImageFallback(),
            )
          : _buildImageFallback(),
    );
  }

  Widget _buildImageFallback() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColor.wine900, AppColor.wine800, AppColor.dark800],
        ),
      ),
      child: const Center(
        child: Text('🙏', style: TextStyle(fontSize: 80)),
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.45),
              Colors.transparent,
              Colors.transparent,
              Colors.black.withOpacity(0.7),
            ],
            stops: const [0.0, 0.25, 0.6, 1.0],
          ),
        ),
      ),
    );
  }

  Widget _buildTapZones() {
    return Positioned.fill(
      child: Row(
        children: [
          // Zona esquerda — voltar
          Expanded(
            child: GestureDetector(
              onTap: _goPrev,
              behavior: HitTestBehavior.translucent,
              child: const SizedBox.expand(),
            ),
          ),
          // Zona direita — avançar
          Expanded(
            child: GestureDetector(
              onTap: _goNext,
              behavior: HitTestBehavior.translucent,
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }
}
