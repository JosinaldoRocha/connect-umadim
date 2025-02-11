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
    final bool validImage =
        widget.event.imageUrl != null && widget.event.imageUrl!.isNotEmpty;

    return Column(
      children: [
        if (validImage)
          SizedBox(
            height: 300,
            width: double.infinity,
            child: Image.network(
              widget.event.imageUrl!,
              fit: BoxFit.fill,
            ),
          ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16).copyWith(
              top: validImage ? 16 : 68,
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
