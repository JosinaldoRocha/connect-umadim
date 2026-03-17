import 'package:connect_umadim_app/app/data/models/story_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StoryReactionsWidget extends StatefulWidget {
  final StoryModel story;
  final String currentUid;
  final void Function(String emoji) onReact;

  const StoryReactionsWidget({
    super.key,
    required this.story,
    required this.currentUid,
    required this.onReact,
  });

  @override
  State<StoryReactionsWidget> createState() => _StoryReactionsWidgetState();
}

class _StoryReactionsWidgetState extends State<StoryReactionsWidget> {
  static const _emojis = ['🔥', '🙏', '😍', '👏'];
  String? _activeEmoji;

  void _react(String emoji) {
    setState(() => _activeEmoji = _activeEmoji == emoji ? null : emoji);
    HapticFeedback.lightImpact();
    widget.onReact(emoji);
    // TODO: salvar reação no Firestore em /stories/{id}/reactions
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: _emojis.map((emoji) {
        final isActive = _activeEmoji == emoji;
        return GestureDetector(
          onTap: () => _react(emoji),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 40,
            height: 40,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive
                  ? Colors.black.withOpacity(0.55)
                  : Colors.black.withOpacity(0.35),
              border: Border.all(
                color: isActive
                    ? Colors.white.withOpacity(0.4)
                    : Colors.white.withOpacity(0.15),
              ),
            ),
            child: Center(
              child: AnimatedScale(
                scale: isActive ? 1.25 : 1.0,
                duration: const Duration(milliseconds: 180),
                child: Text(emoji, style: const TextStyle(fontSize: 18)),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
