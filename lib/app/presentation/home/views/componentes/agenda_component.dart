import 'package:connect_umadim_app/app/core/style/app_colors.dart';
import 'package:connect_umadim_app/app/core/style/app_text.dart';
import 'package:connect_umadim_app/app/data/models/event_model.dart';
import 'package:connect_umadim_app/app/presentation/event/provider/event_provider.dart';
import 'package:connect_umadim_app/app/presentation/home/views/widgets/agenda_calendar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../../core/style/app_decoration.dart';
import '../../../event/views/widgets/event_card_widget.dart';

class AgendaComponent extends ConsumerStatefulWidget {
  const AgendaComponent({super.key});

  @override
  ConsumerState<AgendaComponent> createState() => _AgendaComponentState();
}

class _AgendaComponentState extends ConsumerState<AgendaComponent> {
  DateTime focusedDay = DateTime.now();
  List<EventModel> filteredEvents = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(getAllEventsProvider.notifier).load(),
    );
  }

  List<EventModel> _filterByMonth(List<EventModel> events, DateTime date) {
    return events
        .where((e) =>
            e.eventDate?.month == date.month && e.eventDate?.year == date.year)
        .toList()
      ..sort((a, b) => a.eventDate!.compareTo(b.eventDate!));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(getAllEventsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return state.maybeWhen(
      loadInProgress: () => _buildLoading(),
      loadFailure: (_) => _buildError(context),
      loadSuccess: (events) {
        filteredEvents = _filterByMonth(events, focusedDay);
        return _buildContent(context, events, isDark);
      },
      orElse: () => const SizedBox.shrink(),
    );
  }

  Widget _buildContent(
    BuildContext context,
    List<EventModel> allEvents,
    bool isDark,
  ) {
    return Container(
      color: isDark ? AppColor.darkBackground : AppColor.lightBackground,
      child: Column(
        children: [
          // AppBar customizada com navegação de mês
          _AgendaAppBar(
            focusedDay: focusedDay,
            onPrevMonth: () => setState(() {
              focusedDay = DateTime(focusedDay.year, focusedDay.month - 1);
              filteredEvents = _filterByMonth(allEvents, focusedDay);
            }),
            onNextMonth: () => setState(() {
              focusedDay = DateTime(focusedDay.year, focusedDay.month + 1);
              filteredEvents = _filterByMonth(allEvents, focusedDay);
            }),
          ),

          // Calendário
          AgendaCalendarWidget(
            focusedDay: focusedDay,
            events: allEvents,
            onPageChanged: (day) => setState(() {
              focusedDay = day;
              filteredEvents = _filterByMonth(allEvents, day);
            }),
          ),

          const SizedBox(height: 14),

          // Header da lista
          _buildListHeader(context),

          // Lista de eventos
          Expanded(
            child: filteredEvents.isEmpty
                ? _buildEmpty(context)
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(14, 4, 14, 24),
                    itemCount: filteredEvents.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) =>
                        EventCardWidget(event: filteredEvents[i]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildListHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Eventos do mês', style: AppText.headlineSmall(context)),
          Text(
            '${filteredEvents.length} evento${filteredEvents.length != 1 ? 's' : ''}',
            style: AppText.labelSmall(context),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('📅', style: TextStyle(fontSize: 36)),
            const SizedBox(height: 12),
            Text(
              'Nenhum evento para este mês',
              style: AppText.bodySmall(context),
            ),
          ],
        ),
      );

  Widget _buildLoading() => Center(
        child: SizedBox(
          height: 8,
          width: 40,
          child: LoadingIndicator(
            indicatorType: Indicator.ballPulse,
            colors: const [AppColor.orange500],
          ),
        ),
      );

  Widget _buildError(BuildContext context) => Center(
        child: Text(
          'Erro ao carregar a agenda.\nTente novamente.',
          style: AppText.bodyMedium(context),
          textAlign: TextAlign.center,
        ),
      );
}

// ── AppBar customizada da agenda ──────────────────────────────

class _AgendaAppBar extends StatelessWidget {
  final DateTime focusedDay;
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;

  const _AgendaAppBar({
    required this.focusedDay,
    required this.onPrevMonth,
    required this.onNextMonth,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final monthLabel = toBeginningOfSentenceCase(
      DateFormat('MMMM yyyy', 'pt_BR').format(focusedDay),
    );

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 16,
        right: 16,
        bottom: 10,
      ),
      color: isDark ? AppColor.darkBackground : AppColor.lightBackground,
      child: Row(
        children: [
          Text('Agenda', style: AppText.headlineMedium(context)),
          const Spacer(),

          // Navegação de mês
          Row(
            children: [
              _NavBtn(icon: Icons.chevron_left_rounded, onTap: onPrevMonth),
              const SizedBox(width: 8),
              SizedBox(
                width: 110,
                child: Text(
                  monthLabel,
                  style: AppText.labelLarge(context).copyWith(fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 8),
              _NavBtn(icon: Icons.chevron_right_rounded, onTap: onNextMonth),
            ],
          ),
        ],
      ),
    );
  }
}

class _NavBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _NavBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: isDark
              ? AppColor.darkSurfaceVariant
              : AppColor.lightSurfaceVariant,
          borderRadius: AppDecoration.radiusMd,
          border: Border.all(
            color:
                isDark ? AppColor.darkBorderStrong : AppColor.lightBorderStrong,
          ),
        ),
        child: Icon(icon, size: 18, color: AppColor.amber400),
      ),
    );
  }
}
