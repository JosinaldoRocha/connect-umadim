import 'dart:io';

import 'package:connect_umadim_app/app/data/enums/department_enum.dart';
import 'package:connect_umadim_app/app/data/enums/event_status_enum.dart';
import 'package:connect_umadim_app/app/data/models/event_model.dart';
import 'package:connect_umadim_app/app/presentation/event/states/add/add_event_state_notifier.dart';
import 'package:connect_umadim_app/app/presentation/event/views/pages/add_event_page.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/style/app_colors.dart';
import '../../../../widgets/snack_bar/app_snack_bar_widget.dart';
import '../../provider/event_provider.dart';

mixin AddEventMixin<T extends AddEventPage> on ConsumerState<T> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final eventLocationController = TextEditingController();
  final promotedByController = SingleValueDropDownController();
  final eventTypeController = SingleValueDropDownController();
  File? image;
  Uint8List? imageBytes;
  DateTime? eventDate;
  DateTime? eventTime;
  final formKey = GlobalKey<FormState>();

  void listen() {
    ref.listen<AddEventState>(
      addEventProvider,
      (previous, next) {
        next.maybeWhen(
          loadSuccess: (data) =>
              Navigator.of(context).pushReplacementNamed('/home'),
          loadFailure: (message) {
            AppSnackBar.show(
              context,
              'Não foi possível adicionar o evento',
              AppColor.error,
            );
          },
          orElse: () {},
        );
      },
    );
  }

  Future<void> selectEventTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: eventTime != null
          ? TimeOfDay(hour: eventTime!.hour, minute: eventTime!.minute)
          : TimeOfDay.now(),
    );

    if (picked != null) {
      DateTime now = DateTime.now();
      DateTime selectedDateTime =
          DateTime(now.year, now.month, now.day, picked.hour, picked.minute);

      setState(() {
        eventTime = selectedDateTime;
      });
    }
  }

  Future<void> selectEventDate() async {
    final currentDate = DateTime.now();
    final lastDate = DateTime(currentDate.year, 12, 31);

    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: currentDate,
      lastDate: lastDate,
    );

    if (picked != null && picked != eventDate) {
      setState(() {
        eventDate = picked;
      });
    }
  }

  Future<void> getImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 30,
    );

    if (pickedFile != null) {
      if (kIsWeb) {
        Uint8List bytes = await pickedFile.readAsBytes();

        setState(() {
          imageBytes = bytes;
          image = null;
        });
      } else {
        setState(() {
          image = File(pickedFile.path);
          imageBytes = null;
        });
      }
    }
  }

  void onTapButton() {
    if (formKey.currentState!.validate()) {
      if (eventTime != null) {
        final event = EventModel(
          id: const Uuid().v4(),
          userId: widget.user.id,
          title: titleController.text,
          type: eventTypeController.dropDownValue?.value,
          status: eventDate != null
              ? EventStatus.scheduled
              : EventStatus.notScheduled,
          imageUrl: image?.path,
          eventLocation: eventLocationController.text,
          promotedBy: promotedByController.dropDownValue?.value,
          eventDate: eventDate,
          eventTime: eventTime!,
          description: descriptionController.text,
          confirmedPresences: [],
          createdAt: DateTime.now(),
        );

        final isUserLeader = widget.user.umadimFunction == "Líder";
        final isPromotedByUmadim = event.promotedBy == Department.umadim;
        final isPromotedByCongregation = event.promotedBy.text
            .toLowerCase()
            .contains(widget.user.congregation.toLowerCase());

        if (isUserLeader && isPromotedByUmadim || isPromotedByCongregation) {
          ref.read(addEventProvider.notifier).add(event, imageBytes);
        } else {
          AppSnackBar.show(
            context,
            'Você não tem permissão para criar um evento por esse departamento',
            AppColor.error,
          );
        }
      }
    }
  }
}
