// ignore_for_file: use_build_context_synchronously, deprecated_member_use
import 'dart:ui';

import 'package:connect_umadim_app/app/presentation/event/provider/event_provider.dart';
import 'package:connect_umadim_app/app/presentation/event/states/update/update_event_state_notifier.dart';
import 'package:connect_umadim_app/app/presentation/event/views/pages/event_details_page.dart';
import 'package:connect_umadim_app/app/widgets/dialog/confirmation_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/helpers/helpers.dart';
import '../../../../core/style/app_colors.dart';
import '../../../../core/style/app_text.dart';
import '../../../../widgets/button/button_widget.dart';
import '../../../../widgets/snack_bar/app_snack_bar_widget.dart';
import '../../../../widgets/spacing/spacing.dart';
import '../widgets/confirm_presence_dialog_widget.dart';

mixin EventDetailsMixin<T extends EventDetailsPage> on ConsumerState<T> {
  bool confirmPresence = false;

  @override
  void initState() {
    super.initState();
    confirmPresence = widget.event.confirmedPresences
        .any((element) => element == widget.event.userId);
  }

  void listen() {
    ref.listen<UpdateEventState>(updateEventProvider, (previous, next) {
      next.maybeWhen(
        loadSuccess: (data) {
          confirmPresence = data;

          showDialog(
            context: context,
            barrierColor: Colors.transparent,
            builder: (context) {
              Future.delayed(
                Duration(seconds: 4),
                () => Navigator.pop(context),
              );
              return Stack(
                children: [
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      color: Colors.black.withOpacity(0.2),
                    ),
                  ),
                  AlertDialog(
                    contentPadding: EdgeInsets.all(0),
                    content: ConfirmPresenceDialogWidget(),
                  ),
                ],
              );
            },
          );

          ref.read(getNextEventProvider.notifier).load();
        },
        loadFailure: (message) {
          AppSnackBar.show(
            context,
            'Não foi possível atualizar o evento. Tente novamente',
            AppColor.error,
          );
        },
        orElse: () {},
      );
    });
  }

  void onConfirmPresence() {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialogWidget(
        onTap: () {
          List<String> confirmedPresences = [];
          confirmedPresences.add(widget.event.userId);
          final event = widget.event.copyWith(
            confirmedPresences: confirmedPresences,
          );

          ref.read(updateEventProvider.notifier).load(event);

          Navigator.pop(context);
        },
      ),
    );
  }

  Row buildEventInfo(
    String title,
    String value,
  ) {
    return Row(
      children: [
        Text(
          title,
          style: AppText.text().bodySmall!.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          value,
          style: AppText.text().bodySmall!.copyWith(fontSize: 14),
        ),
      ],
    );
  }

  Align buildConfirmPresenceButton() {
    final state = ref.watch(updateEventProvider);

    return Align(
      alignment: AlignmentDirectional.bottomEnd,
      child: ButtonWidget(
        height: 44,
        width: 200,
        isLoading: state is CommonStateLoadInProgress,
        title: confirmPresence ? 'Presença confirmada' : 'Confirmar presença',
        trailing: confirmPresence
            ? Icon(
                Icons.check_circle,
                color: confirmPresence ? AppColor.error : AppColor.white,
                size: 32,
              )
            : null,
        textColor: confirmPresence ? AppColor.error : AppColor.white,
        onTap: !confirmPresence ? onConfirmPresence : null,
      ),
    );
  }

  Container buildAppBar(bool validImage) {
    return Container(
      padding: EdgeInsets.only(
        top: 36,
        left: 8,
        right: 16,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildBackButton(validImage),
          SpaceHorizontal.x4(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                'widget.event.title df a daf ad daf adfa df',
                style: AppText.text().titleMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconButton buildBackButton(bool validImage) {
    return IconButton(
      style: IconButton.styleFrom(
        elevation: 0,
        backgroundColor: validImage ? const Color(0x291A1A1A) : null,
      ),
      onPressed: () => Navigator.pop(context),
      icon: Icon(
        Icons.arrow_back,
        color: validImage ? AppColor.white : AppColor.tertiary,
      ),
    );
  }
}
