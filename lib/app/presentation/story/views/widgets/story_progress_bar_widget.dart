import 'package:flutter/material.dart';

class StoryProgressBarWidget extends StatelessWidget {
  final int totalStories;
  final int currentIndex;
  final AnimationController progressController;

  const StoryProgressBarWidget({
    super.key,
    required this.totalStories,
    required this.currentIndex,
    required this.progressController,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
        child: Row(
          children: List.generate(totalStories, (i) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: i < totalStories - 1 ? 4 : 0),
                child: _StoryBar(
                  state: i < currentIndex
                      ? _BarState.done
                      : i == currentIndex
                          ? _BarState.active
                          : _BarState.pending,
                  progressController: progressController,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

enum _BarState { done, active, pending }

class _StoryBar extends StatelessWidget {
  final _BarState state;
  final AnimationController progressController;

  const _StoryBar({
    required this.state,
    required this.progressController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2.5,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(99),
      ),
      clipBehavior: Clip.hardEdge,
      child: state == _BarState.active
          ? AnimatedBuilder(
              animation: progressController,
              builder: (_, __) => FractionallySizedBox(
                widthFactor: progressController.value,
                heightFactor: 1,
                alignment: Alignment.centerLeft,
                child: Container(color: Colors.white),
              ),
            )
          : state == _BarState.done
              ? Container(color: Colors.white)
              : const SizedBox.shrink(),
    );
  }
}
