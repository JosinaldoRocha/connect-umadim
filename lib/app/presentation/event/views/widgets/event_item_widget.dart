import 'package:connect_umadim_app/app/core/style/app_colors.dart';
import 'package:connect_umadim_app/app/core/style/app_text.dart';
import 'package:connect_umadim_app/app/data/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventItemWidget extends StatelessWidget {
  const EventItemWidget({
    super.key,
    required this.event,
    required this.isHorizontalScrolling,
  });
  final EventModel event;
  final bool isHorizontalScrolling;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).pushNamed(
          '/event/details',
          arguments: event,
        );
      },
      child: Container(
        height: 202,
        width: isHorizontalScrolling ? 300 : double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColor.cardBackground,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              spreadRadius: 1,
              offset: Offset(0, 2),
              blurRadius: 3,
              color: AppColor.lightGrey,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: AppText.text()
                      .titleSmall!
                      .copyWith(color: AppColor.secondary),
                ),
                Text(
                  event.eventDate != null
                      ? '📌 ${DateFormat('dd/MM/yyyy').format(event.eventDate!)}'
                      : event.status.text,
                  style: AppText.text().bodySmall!.copyWith(fontSize: 14),
                ),
              ],
            ),
            Image.asset('assets/images/bible_study.png'),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                event.promotedBy.text,
                overflow: TextOverflow.ellipsis,
                style: AppText.text().titleSmall!.copyWith(
                      fontSize: 14,
                      color: AppColor.mediumGrey,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
