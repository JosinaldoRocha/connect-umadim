import 'package:connect_umadim_app/app/core/style/app_colors.dart';
import 'package:connect_umadim_app/app/core/style/app_text.dart';
import 'package:connect_umadim_app/app/data/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/style/app_decoration.dart';

class AgendaCalendarWidget extends StatelessWidget {
  final DateTime focusedDay;
  final Function(DateTime) onPageChanged;
  final List<EventModel> events;

  const AgendaCalendarWidget({
    super.key,
    required this.focusedDay,
    required this.onPageChanged,
    required this.events,
  });

  List<EventModel> _eventsForDay(DateTime date) {
    return events
        .where((e) =>
            e.eventDate?.year == date.year &&
            e.eventDate?.month == date.month &&
            e.eventDate?.day == date.day)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
        borderRadius: AppDecoration.radiusLg,
        border: Border.all(
          color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
        ),
      ),
      child: TableCalendar(
        locale: 'pt_BR',
        focusedDay: focusedDay,
        firstDay: DateTime(DateTime.now().year - 1),
        lastDay: DateTime(DateTime.now().year + 2),
        calendarFormat: CalendarFormat.month,
        eventLoader: _eventsForDay,
        onPageChanged: onPageChanged,
        rowHeight: 38,
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          leftChevronVisible: false,
          rightChevronVisible: false,
          headerPadding: EdgeInsets.zero,
          headerMargin: EdgeInsets.zero,
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: AppText.labelSmall(context).copyWith(
            color: isDark
                ? AppColor.darkOnSurfaceMuted
                : AppColor.lightOnSurfaceMuted,
          ),
          weekendStyle: AppText.labelSmall(context).copyWith(
            color: AppColor.orange400,
          ),
          dowTextFormatter: (date, locale) =>
              toBeginningOfSentenceCase(DateFormat.E(locale).format(date)) ??
              '',
        ),
        calendarStyle: CalendarStyle(
          todayDecoration: const BoxDecoration(
            color: AppColor.orange500,
            shape: BoxShape.circle,
          ),
          todayTextStyle: AppText.labelMedium(context)
              .copyWith(color: AppColor.light50, fontWeight: FontWeight.w700),
          selectedDecoration: BoxDecoration(
            color: AppColor.orange500.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          selectedTextStyle: AppText.labelMedium(context)
              .copyWith(color: AppColor.orange400, fontWeight: FontWeight.w600),
          defaultTextStyle: AppText.labelMedium(context).copyWith(
            color: isDark ? AppColor.darkOnSurface : AppColor.lightOnSurface,
          ),
          weekendTextStyle: AppText.labelMedium(context)
              .copyWith(color: AppColor.orange400.withOpacity(0.8)),
          outsideTextStyle: AppText.labelMedium(context).copyWith(
            color: isDark
                ? AppColor.darkOnSurfaceMuted.withOpacity(0.4)
                : AppColor.lightOnSurfaceMuted.withOpacity(0.4),
          ),
          markerSize: 5,
          markerMargin: const EdgeInsets.only(top: 1),
          markerDecoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColor.wine600,
          ),
          cellMargin: const EdgeInsets.all(4),
          tablePadding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
        ),
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, date, events) {
            if (events.isEmpty) return const SizedBox.shrink();
            return Positioned(
              bottom: 4,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: events
                    .take(3)
                    .map((_) => Container(
                          width: 5,
                          height: 5,
                          margin: const EdgeInsets.symmetric(horizontal: 1),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColor.wine600,
                          ),
                        ))
                    .toList(),
              ),
            );
          },
        ),
      ),
    );
  }
}
