import 'package:connect_umadim_app/app/core/style/app_colors.dart';
import 'package:connect_umadim_app/app/core/style/app_text.dart';
import 'package:connect_umadim_app/app/core/supabase/supabase_init.dart';
import 'package:connect_umadim_app/app/data/models/event_model.dart';
import 'package:connect_umadim_app/app/presentation/event/views/mixin/event_details_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/style/app_decoration.dart';

class EventDetailsPage extends ConsumerStatefulWidget {
  const EventDetailsPage({super.key, required this.event});
  final EventModel event;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EventDetailsPageState();
}

class _EventDetailsPageState extends ConsumerState<EventDetailsPage>
    with EventDetailsMixin {
  @override
  Widget build(BuildContext context) {
    listen();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasImage = widget.event.imageUrl != null &&
        widget.event.imageUrl!.isNotEmpty &&
        isSupabaseImageUrlValid(widget.event.imageUrl);

    return Scaffold(
      backgroundColor:
          isDark ? AppColor.darkBackground : AppColor.lightBackground,
      body: Column(
        children: [
          hasImage
              ? _buildHero(context, isDark)
              : _buildAppBar(context, isDark),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              children: [
                _buildStatusBadge(context),
                const SizedBox(height: 14),
                if (widget.event.description != null &&
                    widget.event.description!.isNotEmpty) ...[
                  Text(
                    widget.event.description!,
                    textAlign: TextAlign.center,
                    style: AppText.bodySmall(context).copyWith(
                      fontSize: 13,
                      height: 1.65,
                      color: isDark
                          ? AppColor.darkOnSurfaceMuted
                          : AppColor.lightOnSurfaceMuted,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                _buildInfoCard(context, isDark),
                const SizedBox(height: 12),
                _buildPresenceRow(context, isDark),
                const SizedBox(height: 14),
                buildConfirmPresenceButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHero(BuildContext context, bool isDark) {
    return SizedBox(
      height: 240,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            widget.event.imageUrl!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              decoration: const BoxDecoration(gradient: AppColor.wineDark),
              child: const Center(
                  child: Text('🙌', style: TextStyle(fontSize: 64))),
            ),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x66000000),
                  Colors.transparent,
                  Color(0xCC000000),
                ],
                stops: [0.0, 0.4, 1.0],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 14,
            child: _backButton(overlay: true),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Text(
              widget.event.title,
              style: const TextStyle(
                fontFamily: 'Syne',
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                height: 1.2,
                shadows: [
                  Shadow(
                      color: Colors.black54,
                      blurRadius: 8,
                      offset: Offset(0, 2))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, bool isDark) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 8,
        right: 16,
        bottom: 10,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkBackground : AppColor.lightBackground,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
          ),
        ),
      ),
      child: Row(
        children: [
          _backButton(overlay: false),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              widget.event.title,
              style: AppText.headlineMedium(context),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _backButton({required bool overlay}) {
    return IconButton(
      style: IconButton.styleFrom(
        backgroundColor:
            overlay ? Colors.black.withOpacity(0.35) : Colors.transparent,
        shape: const CircleBorder(),
      ),
      onPressed: () => Navigator.pop(context),
      icon: Icon(
        Icons.arrow_back_ios_new_rounded,
        size: 18,
        color: overlay ? Colors.white : AppColor.amber400,
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final isToday = widget.event.eventDate != null &&
        widget.event.eventDate!.day == DateTime.now().day &&
        widget.event.eventDate!.month == DateTime.now().month &&
        widget.event.eventDate!.year == DateTime.now().year;

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        decoration: BoxDecoration(
          color: AppColor.success.withOpacity(0.12),
          borderRadius: AppDecoration.radiusFull,
          border: Border.all(color: AppColor.success.withOpacity(0.25)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: AppColor.success),
            ),
            const SizedBox(width: 6),
            Text(
              isToday
                  ? 'Hoje · ${widget.event.status.text}'
                  : widget.event.status.text,
              style: AppText.labelSmall(context).copyWith(
                color: AppColor.success,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, bool isDark) {
    final rows = <_InfoItem>[
      _InfoItem('📍', 'Local', widget.event.eventLocation),
      _InfoItem(
        '📅',
        'Data e horário',
        widget.event.eventDate != null
            ? '${DateFormat('dd/MM/yyyy').format(widget.event.eventDate!)} às ${DateFormat('HH:mm').format(widget.event.eventTime)}h'
            : widget.event.status.text,
      ),
      _InfoItem('🏷️', 'Promovido por', widget.event.promotedBy.text),
      if (widget.event.theme != null && widget.event.theme!.isNotEmpty)
        _InfoItem('📖', 'Tema', widget.event.theme!),
      if (widget.event.minister != null && widget.event.minister!.isNotEmpty)
        _InfoItem('🎤', 'Ministração', widget.event.minister!),
      if (widget.event.singer != null && widget.event.singer!.isNotEmpty)
        _InfoItem('🎶', 'Louvor', widget.event.singer!),
    ];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
        borderRadius: AppDecoration.radiusLg,
        border: Border.all(
          color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
        ),
      ),
      child: Column(
        children: rows.asMap().entries.map((entry) {
          final i = entry.key;
          final row = entry.value;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              border: i > 0
                  ? Border(
                      top: BorderSide(
                        color:
                            isDark ? AppColor.darkBorder : AppColor.lightBorder,
                      ),
                    )
                  : null,
            ),
            child: Row(
              children: [
                Text(row.icon, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(row.label, style: AppText.labelSmall(context)),
                    Text(
                      row.value,
                      style: AppText.bodySmall(context).copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        color: isDark
                            ? AppColor.darkOnBackground
                            : AppColor.lightOnBackground,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPresenceRow(BuildContext context, bool isDark) {
    final count = widget.event.confirmedPresences.length;
    final visible = widget.event.confirmedPresences.take(3).toList();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
        borderRadius: AppDecoration.radiusMd,
        border: Border.all(
          color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 26,
            width: visible.length * 16.0 + 10,
            child: Stack(
              children: visible.asMap().entries.map((e) {
                return Positioned(
                  left: e.key * 16.0,
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [AppColor.wine700, AppColor.orange600],
                      ),
                      border: Border.all(
                        color: isDark
                            ? AppColor.darkBackground
                            : AppColor.lightBackground,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        e.value.isNotEmpty ? e.value[0].toUpperCase() : '?',
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: AppColor.light50,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$count confirmação${count != 1 ? 's' : ''}',
            style: AppText.labelSmall(context),
          ),
          const Spacer(),
          Text(
            'Ver todos',
            style:
                AppText.labelSmall(context).copyWith(color: AppColor.orange400),
          ),
        ],
      ),
    );
  }
}

class _InfoItem {
  final String icon;
  final String label;
  final String value;
  const _InfoItem(this.icon, this.label, this.value);
}
