import 'package:connect_umadim_app/app/data/models/event_model.dart';
import 'package:flutter/material.dart';

import '../../../../core/style/app_text.dart';
import '../../../../widgets/spacing/spacing.dart';
import 'event_item_widget.dart';

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
                  style: AppText.text().bodyMedium,
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
                  child: EventItemWidget(
                    event: events[index],
                    isHorizontalScrolling: false,
                  ),
                );
              },
              separatorBuilder: (context, index) => SpaceVertical.x2(),
            ),
    );
  }
}
