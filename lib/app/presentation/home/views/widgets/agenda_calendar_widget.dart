import 'package:connect_umadim_app/app/core/style/app_colors.dart';
import 'package:connect_umadim_app/app/core/style/app_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../data/models/event_model.dart';

class AgendaCalendarWidget extends StatelessWidget {
  const AgendaCalendarWidget({
    super.key,
    required this.focusedDay,
    required this.onPageChanged,
    required this.events,
  });

  final DateTime focusedDay;
  final Function(DateTime) onPageChanged;
  final List<EventModel> events;

  List<EventModel> getEventsForDay(DateTime date) {
    return events.where((event) {
      return event.eventDate?.year == date.year &&
          event.eventDate?.month == date.month &&
          event.eventDate?.day == date.day;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 310,
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xE6FFECD7),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0x78000000),
            offset: Offset(0, 5),
            blurRadius: 5,
          ),
        ],
      ),
      child: TableCalendar(
        locale: 'pt_BR',
        focusedDay: focusedDay,
        firstDay: DateTime(DateTime.now().year),
        lastDay: DateTime(DateTime.now().year + 1),
        calendarFormat: CalendarFormat.month,
        eventLoader: getEventsForDay,
        headerStyle: HeaderStyle(
          titleTextStyle: AppText.text().titleMedium!,
          leftChevronIcon: Icon(
            Icons.arrow_back_ios_rounded,
            size: 22,
            color: AppColor.tertiary,
          ),
          rightChevronIcon: Icon(
            Icons.arrow_forward_ios_rounded,
            size: 22,
            color: AppColor.tertiary,
          ),
          headerPadding: EdgeInsets.symmetric(vertical: 4),
          formatButtonVisible: false,
          titleCentered: true,
          titleTextFormatter: (date, locale) => toBeginningOfSentenceCase(
            DateFormat.MMMM(locale).format(date),
          ),
        ),
        onPageChanged: onPageChanged,
        daysOfWeekStyle: DaysOfWeekStyle(
          dowTextFormatter: (date, locale) => toBeginningOfSentenceCase(
            DateFormat.E(locale).format(date),
          ),
        ),
        rowHeight: 36,
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: AppColor.primary,
            shape: BoxShape.circle,
          ),
          markerSize: 6,
          markerMargin: EdgeInsets.only(top: 2),
          markerDecoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColor.secondary,
          ),
        ),
      ),
    );
  }
}
