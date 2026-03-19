import 'package:connect_umadim_app/app/core/style/app_colors.dart';
import 'package:connect_umadim_app/app/core/style/app_text.dart';
import 'package:connect_umadim_app/app/data/models/event_model.dart';
import 'package:connect_umadim_app/app/presentation/event/provider/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'add_event_button_widget.dart';
import 'event_card_widget.dart';
import '../../../user/providers/user_provider.dart';

class NextEventWidget extends ConsumerStatefulWidget {
  const NextEventWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NextEventWidgetState();
}

class _NextEventWidgetState extends ConsumerState<NextEventWidget> {
  @override
  void initState() {
    super.initState();
    // Preservado: mesmo provider e lógica de carregamento do original
    Future.microtask(
      () => ref.read(getNextEventProvider.notifier).load(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(getNextEventProvider);

    return state.maybeWhen(
      loadSuccess: (data) {
        if (data.isEmpty) return const SizedBox.shrink();
        return _buildSection(context, data);
      },
      orElse: () => const SizedBox.shrink(),
    );
  }

  Widget _buildSection(BuildContext context, List<EventModel> events) {
    final isSingle = events.length == 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header ──────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isSingle ? 'Próximo evento' : 'Próximos eventos',
                style: AppText.headlineSmall(context),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AddEventButtonWidget(
                    onTap: () {
                      ref.read(getUserProvider).maybeWhen(
                            loadSuccess: (user) => Navigator.of(context,
                                    rootNavigator: true)
                                .pushNamed('/event/add', arguments: user),
                            orElse: () {},
                          );
                    },
                    compact: true,
                  ),
                  if (!isSingle) ...[
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        'Ver todos',
                        style: AppText.labelSmall(context)
                            .copyWith(color: AppColor.orange400),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),

        // ── Evento único: card full-width ────────────────────────
        if (isSingle)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: EventCardWidget(event: events[0], isCompact: false),
          ),

        // ── Múltiplos eventos: scroll horizontal ─────────────────
        if (!isSingle)
          SizedBox(
            height: 185,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: events.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, i) =>
                  EventCardWidget(event: events[i], isCompact: true),
            ),
          ),
      ],
    );
  }
}
