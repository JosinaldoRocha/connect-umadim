import 'package:connect_umadim_app/app/core/style/app_text.dart';
import 'package:connect_umadim_app/app/data/models/event_model.dart';
import 'package:connect_umadim_app/app/presentation/event/provider/event_provider.dart';
import 'package:connect_umadim_app/app/presentation/event/views/widgets/events_list_widget.dart';
import 'package:connect_umadim_app/app/presentation/home/views/widgets/agenda_calendar_widget.dart';
import 'package:connect_umadim_app/app/widgets/spacing/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../../core/style/app_colors.dart';

class AgendaComponent extends ConsumerStatefulWidget {
  const AgendaComponent({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AgendaComponentState();
}

class _AgendaComponentState extends ConsumerState<AgendaComponent> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(getAllEventsProvider.notifier).load());
  }

  DateTime now = DateTime.now();
  DateTime focusedDay = DateTime.now();
  List<EventModel> filteredEvents = [];

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(getAllEventsProvider);

    return state.maybeWhen(
      //TODO: create component for loading
      loadInProgress: () => _buildLoadingIndicator(),
      loadSuccess: (data) {
        filterEventsByMonth(data, focusedDay);

        return Container(
          color: AppColor.lightBgColor,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Stack(
            children: [
              Positioned(
                child: EventsListWidget(events: filteredEvents),
              ),
              Column(
                children: [
                  SpaceVertical.x10(),
                  SpaceVertical.x2(),
                  Text(
                    'Agenda - 2025',
                    style: AppText.text().titleMedium,
                  ),
                  SpaceVertical.x4(),
                  AgendaCalendarWidget(
                    focusedDay: focusedDay,
                    onPageChanged: (newFocusedDay) => setState(() {
                      focusedDay = newFocusedDay;
                      filterEventsByMonth(data, newFocusedDay);
                    }),
                  ),
                ],
              ),
            ],
          ),
        );
      },

      loadFailure: (failure) => Center(
        child: Text(
          'Houve um erro ao carregar a agenda,\ntente novamente!',
          textAlign: TextAlign.center,
        ),
      ),
      orElse: () => Container(),
    );
  }

  List<EventModel> filterEventsByMonth(
    List<EventModel> events,
    DateTime date,
  ) {
    filteredEvents = events
        .where((event) =>
            event.eventDate?.month == date.month &&
            event.eventDate?.year == date.year)
        .toList();

    return filteredEvents;
  }

  Center _buildLoadingIndicator() {
    return Center(
      child: SizedBox(
        height: 8,
        width: 40,
        child: LoadingIndicator(
          indicatorType: Indicator.ballPulse,
          colors: [AppColor.primary],
        ),
      ),
    );
  }
}
