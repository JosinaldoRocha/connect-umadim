import 'package:connect_umadim_app/app/core/style/app_colors.dart';
import 'package:connect_umadim_app/app/core/style/app_text.dart';
import 'package:connect_umadim_app/app/data/models/event_model.dart';
import 'package:connect_umadim_app/app/presentation/event/views/mixin/event_details_mixin.dart';
import 'package:connect_umadim_app/app/widgets/spacing/spacing.dart';
import 'package:connect_umadim_app/app/widgets/spacing/vertical_space_widget.dart';
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

    return Scaffold(
      body: Stack(
        children: [
          _buildContent(),
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              style: IconButton.styleFrom(
                shadowColor: Colors.amber,
                elevation: 0,
                backgroundColor: const Color.fromARGB(41, 26, 26, 26),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: AppColor.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column _buildContent() {
    return Column(
      children: [
        if (widget.event.imageUrl?.isNotEmpty ?? true)
          SizedBox(
            height: 300,
            width: double.infinity,
            child: Image.network(
              widget.event.imageUrl!,
              fit: BoxFit.fill,
            ),
          ),
        widget.event.imageUrl?.isNotEmpty ?? true
            ? SpaceVertical.x2()
            : SpaceVertical.x10(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16).copyWith(
              top: widget.event.imageUrl?.isNotEmpty ?? true ? 8 : 52,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  widget.event.title,
                  textAlign: TextAlign.center,
                  style: AppText.text().titleMedium,
                ),
                SpaceVertical.x2(),
                if (widget.event.description != null)
                  Text(
                    widget.event.description!,
                    textAlign: TextAlign.center,
                    style: AppText.text().bodySmall!.copyWith(fontSize: 14),
                  ),
                Spacer(),
                if (widget.event.theme?.isNotEmpty ?? true)
                  buildEventInfo('📖 Tema: ', widget.event.theme!),
                if (widget.event.minister?.isNotEmpty ?? true)
                  buildEventInfo('🎤 Ministração: ', widget.event.minister!),
                if (widget.event.singer?.isNotEmpty ?? true)
                  buildEventInfo('🎶 Louvor: ', widget.event.singer!),
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
