import 'package:connect_umadim_app/app/core/style/app_colors.dart';
import 'package:connect_umadim_app/app/core/style/app_text.dart';
import 'package:connect_umadim_app/app/data/enums/department_enum.dart';
import 'package:connect_umadim_app/app/data/models/event_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/style/app_decoration.dart';

class EventCardWidget extends StatefulWidget {
  final EventModel event;
  final bool isCompact;

  const EventCardWidget({
    super.key,
    required this.event,
    this.isCompact = false,
  });

  @override
  State<EventCardWidget> createState() => _EventCardWidgetState();
}

class _EventCardWidgetState extends State<EventCardWidget> {
  late bool _confirmed;
  String get _uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void initState() {
    super.initState();
    _confirmed = widget.event.confirmedPresences.contains(_uid);
  }

  bool get _isUmadim => widget.event.promotedBy == Department.umadim;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => Navigator.of(context, rootNavigator: true)
          .pushNamed('/event/details', arguments: widget.event),
      child: Container(
        width: widget.isCompact ? 260 : double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
          borderRadius: AppDecoration.radiusLg,
          border: Border.all(
            color: _isUmadim
                ? AppColor.amber500.withOpacity(0.25)
                : (isDark ? AppColor.darkBorder : AppColor.lightBorder),
          ),
          gradient: _isUmadim
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColor.wine700.withOpacity(0.3),
                    isDark ? AppColor.darkSurface : AppColor.lightSurface,
                  ],
                )
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    widget.event.title,
                    style: AppText.headlineSmall(context),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                _DateBadge(event: widget.event),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 12,
              runSpacing: 4,
              children: [
                _MetaItem(
                  icon: Icons.location_on_outlined,
                  label: widget.event.eventLocation,
                ),
                _MetaItem(
                  icon: Icons.access_time_rounded,
                  label: DateFormat('HH:mm').format(widget.event.eventTime),
                ),
                _MetaItem(
                  icon: Icons.group_outlined,
                  label: widget.event.promotedBy.text,
                  highlight: _isUmadim,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _confirmed = !_confirmed),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: _confirmed
                            ? AppColor.success.withOpacity(0.15)
                            : (isDark
                                ? AppColor.darkSurfaceVariant
                                : AppColor.lightSurfaceVariant),
                        borderRadius: AppDecoration.radiusFull,
                        border: Border.all(
                          color: _confirmed
                              ? AppColor.success.withOpacity(0.3)
                              : (isDark
                                  ? AppColor.darkBorder
                                  : AppColor.lightBorder),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _confirmed
                                ? Icons.check_circle_rounded
                                : Icons.check_circle_outline_rounded,
                            size: 13,
                            color: _confirmed
                                ? AppColor.success
                                : (isDark
                                    ? AppColor.darkOnSurfaceMuted
                                    : AppColor.lightOnSurfaceMuted),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            _confirmed ? 'Confirmado' : 'Confirmar presença',
                            style: AppText.labelSmall(context).copyWith(
                              color: _confirmed
                                  ? AppColor.success
                                  : (isDark
                                      ? AppColor.darkOnSurfaceMuted
                                      : AppColor.lightOnSurfaceMuted),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    '${widget.event.confirmedPresences.length} confirmação${widget.event.confirmedPresences.length != 1 ? 's' : ''}',
                    style: AppText.labelSmall(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateBadge extends StatelessWidget {
  final EventModel event;
  const _DateBadge({required this.event});

  @override
  Widget build(BuildContext context) {
    if (event.eventDate == null) {
      return _badge(context, event.status.text, AppColor.darkSurfaceVariant,
          AppColor.darkOnSurfaceMuted, AppColor.darkBorder);
    }

    final now = DateTime.now();
    final date = event.eventDate!;
    final isToday =
        date.day == now.day && date.month == now.month && date.year == now.year;
    final isTomorrow =
        date.difference(DateTime(now.year, now.month, now.day)).inDays == 1;
    final isPast = date.isBefore(DateTime(now.year, now.month, now.day));

    if (isToday)
      return _badge(context, 'Hoje', AppColor.success.withOpacity(0.15),
          const Color(0xFF6EE09A), AppColor.success.withOpacity(0.25));
    if (isTomorrow)
      return _badge(context, 'Amanhã', AppColor.orange500.withOpacity(0.15),
          AppColor.orange300, AppColor.orange500.withOpacity(0.25));
    if (isPast)
      return _badge(
          context,
          DateFormat('dd/MM').format(date),
          AppColor.darkSurfaceVariant,
          AppColor.darkOnSurfaceMuted,
          AppColor.darkBorder);

    return _badge(
        context,
        DateFormat('dd/MM').format(date),
        AppColor.amber500.withOpacity(0.12),
        AppColor.amber300,
        AppColor.amber500.withOpacity(0.2));
  }

  Widget _badge(
      BuildContext context, String label, Color bg, Color fg, Color border) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppDecoration.radiusFull,
        border: Border.all(color: border),
      ),
      child: Text(label,
          style: AppText.labelSmall(context)
              .copyWith(color: fg, fontWeight: FontWeight.w600)),
    );
  }
}

class _MetaItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool highlight;
  const _MetaItem(
      {required this.icon, required this.label, this.highlight = false});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = highlight
        ? AppColor.amber400
        : (isDark ? AppColor.darkOnSurfaceMuted : AppColor.lightOnSurfaceMuted);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 4),
        Text(label,
            style: AppText.labelSmall(context).copyWith(color: color),
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
      ],
    );
  }
}
