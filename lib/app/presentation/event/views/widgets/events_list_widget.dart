import 'package:connect_umadim_app/app/core/style/app_text.dart';
import 'package:connect_umadim_app/app/data/models/event_model.dart';
import 'package:connect_umadim_app/app/presentation/event/views/widgets/event_card_widget.dart';
import 'package:connect_umadim_app/app/widgets/spacing/spacing.dart';
import 'package:flutter/material.dart';

class EventsListWidget extends StatelessWidget {
  const EventsListWidget({
    super.key,
    required this.events,
  });

  final List<EventModel> events;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: events.isEmpty
          ? Padding(
              padding: const EdgeInsets.only(top: 372),
              child: Center(
                child: Text(
                  'Nenhum evento para este mês 😕',
                  style: AppText.bodyMedium(context),
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.only(top: 372),
              itemCount: events.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                    top: index == 0 ? 16 : 0,
                    bottom: index == events.length - 1 ? 16 : 0,
                  ),
                  child: EventCardWidget(
                    event: events[index],
                    isCompact: false,
                  ),
                );
              },
              separatorBuilder: (context, index) => SpaceVertical.x2(),
            ),
    );
  }
}
