import 'package:connect_umadim_app/app/core/style/app_colors.dart';
import 'package:connect_umadim_app/app/core/supabase/supabase_init.dart';
import 'package:connect_umadim_app/app/core/style/app_text.dart';
import 'package:connect_umadim_app/app/data/models/event_model.dart';
import 'package:connect_umadim_app/app/presentation/event/views/mixin/event_details_mixin.dart';
import 'package:connect_umadim_app/app/widgets/spacing/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class EventDetailsPage extends ConsumerStatefulWidget {
  const EventDetailsPage({
    super.key,
    required this.event,
  });

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
    final bool validImage =
        widget.event.imageUrl != null &&
        widget.event.imageUrl!.isNotEmpty &&
        isSupabaseImageUrlValid(widget.event.imageUrl);

    return Scaffold(
      body: validImage
          ? Stack(
              children: [
                _buildContent(validImage),
                Positioned(
                  top: 40,
                  left: 10,
                  child: buildBackButton(validImage),
                ),
              ],
            )
          : _buildContent(validImage),
    );
  }

  Column _buildContent(bool validImage) {
    return Column(
      children: [
        validImage
            ? SizedBox(
                height: 300,
                width: double.infinity,
                child: Image.network(
                  widget.event.imageUrl!,
                  fit: BoxFit.fill,
                ),
              )
            : buildAppBar(validImage),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16).copyWith(
              top: validImage ? 16 : 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                if (validImage)
                  Text(
                    widget.event.title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium!,
                  ),
                SpaceVertical.x2(),
                if (widget.event.description != null)
                  Text(
                    widget.event.description!,
                    textAlign: TextAlign.center,
                    style: AppText.bodySmall(context).copyWith(
                          fontSize: 14,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColor.darkOnSurfaceMuted
                              : AppColor.lightOnSurfaceMuted,
                        ),
                  ),
                Spacer(),
                if (widget.event.theme != null &&
                    widget.event.theme!.isNotEmpty)
                  buildEventInfo('📖 Tema: ', widget.event.theme ?? ''),
                if (widget.event.minister != null &&
                    widget.event.minister!.isNotEmpty)
                  buildEventInfo(
                      '🎤 Ministração: ', widget.event.minister ?? ''),
                if (widget.event.singer != null &&
                    widget.event.singer!.isNotEmpty)
                  buildEventInfo('🎶 Louvor: ', widget.event.singer ?? ''),
                buildEventInfo('📍 Local: ', widget.event.eventLocation),
                buildEventInfo(
                  '🕖 Data e Horário: ',
                  widget.event.eventDate != null
                      ? '${DateFormat('dd/MM/yyyy').format(widget.event.eventDate!)}'
                          ' às ${DateFormat('hh:mm').format(widget.event.eventTime)}h'
                      : widget.event.status.text,
                ),
                SpaceVertical.x4(),
                buildConfirmPresenceButton(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
