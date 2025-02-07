import 'package:connect_umadim_app/app/data/models/event_model.dart';
import 'package:connect_umadim_app/app/presentation/event/views/widgets/event_item_widget.dart';
import 'package:flutter/material.dart';

import '../../../../widgets/spacing/spacing.dart';

class NextEventListWidget extends StatelessWidget {
  const NextEventListWidget({
    super.key,
    required this.events,
  });

  final List<EventModel> events;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => Container(
          margin: EdgeInsets.only(
            left: index == 0 ? 16 : 0,
            right: index == events.length - 1 ? 16 : 0,
          ),
          child: EventItemWidget(
            event: events[index],
            isHorizontalScrolling: true,
          ),
        ),
        separatorBuilder: (context, index) => SpaceHorizontal.x2(),
        itemCount: events.length,
      ),
    );
  }
}
