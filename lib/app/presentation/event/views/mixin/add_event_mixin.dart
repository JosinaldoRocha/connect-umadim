import 'dart:io';

import 'package:connect_umadim_app/app/data/enums/event_status_enum.dart';
import 'package:connect_umadim_app/app/data/enums/funciton_type_enum.dart';
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
  // ── Controllers obrigatórios ──────────────────────────────
  final titleController = TextEditingController();
  final eventLocationController = TextEditingController();
  final promotedByController = SingleValueDropDownController();
  final eventTypeController = SingleValueDropDownController();

  // ── Controllers opcionais ─────────────────────────────────
  final descriptionController = TextEditingController();
  final themeController = TextEditingController();
  final ministerController = TextEditingController();
  final singerController = TextEditingController();

  // ── Estado ────────────────────────────────────────────────
  File? image;
  Uint8List? imageBytes;
  DateTime? eventDate;
  DateTime? eventTime;
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    titleController.dispose();
    eventLocationController.dispose();
    descriptionController.dispose();
    themeController.dispose();
    ministerController.dispose();
    singerController.dispose();
    super.dispose();
  }

  // ── Escuta o estado ───────────────────────────────────────

  void listen() {
    ref.listen<AddEventState>(
      addEventProvider,
      (previous, next) {
        next.maybeWhen(
          loadSuccess: (_) =>
              Navigator.of(context).pushReplacementNamed('/home'),
          loadFailure: (_) => AppSnackBar.show(
            context,
            'Não foi possível adicionar o evento',
            AppColor.error,
          ),
          orElse: () {},
        );
      },
    );
  }

  // ── Seleção de data ───────────────────────────────────────

  Future<void> selectEventDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: eventDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 2, 12, 31),
    );
    if (picked != null) setState(() => eventDate = picked);
  }

  // ── Seleção de hora ───────────────────────────────────────

  Future<void> selectEventTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: eventTime != null
          ? TimeOfDay(
              hour: eventTime!.hour,
              minute: eventTime!.minute,
            )
          : TimeOfDay.now(),
    );
    if (picked != null) {
      final now = DateTime.now();
      setState(() {
        eventTime =
            DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
      });
    }
  }

  // ── Seleção de imagem ─────────────────────────────────────

  Future<void> getImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 30,
    );
    if (picked == null) return;

    if (kIsWeb) {
      final bytes = await picked.readAsBytes();
      setState(() {
        imageBytes = bytes;
        image = null;
      });
    } else {
      setState(() {
        image = File(picked.path);
        imageBytes = null;
      });
    }
  }

  // ── Publicar evento ───────────────────────────────────────

  void onTapButton() {
    if (!formKey.currentState!.validate()) return;

    if (eventTime == null) {
      AppSnackBar.show(
        context,
        'Selecione o horário do evento',
        AppColor.error,
      );
      return;
    }

    // Verifica permissão do usuário
    final authorizedUser =
        widget.user.umadimFunction.title == FunctionType.leader ||
            widget.user.umadimFunction.title == FunctionType.viceLeader ||
            widget.user.umadimFunction.title == FunctionType.regent ||
            widget.user.localFunction.title == FunctionType.leader ||
            widget.user.localFunction.title == FunctionType.viceLeader;

    final event = EventModel(
      id: const Uuid().v4(),
      userId: widget.user.id,
      title: titleController.text.trim(),
      type: eventTypeController.dropDownValue?.value,
      status:
          eventDate != null ? EventStatus.scheduled : EventStatus.notScheduled,
      imageUrl: image?.path,
      eventLocation: eventLocationController.text.trim(),
      promotedBy: promotedByController.dropDownValue?.value,
      eventDate: eventDate,
      eventTime: eventTime!,
      description: descriptionController.text.trim().isEmpty
          ? null
          : descriptionController.text.trim(),
      theme: themeController.text.trim().isEmpty
          ? null
          : themeController.text.trim(),
      minister: ministerController.text.trim().isEmpty
          ? null
          : ministerController.text.trim(),
      singer: singerController.text.trim().isEmpty
          ? null
          : singerController.text.trim(),
      confirmedPresences: [],
      createdAt: DateTime.now(),
    );

    final isDepartmentAllowed =
        widget.user.umadimFunction.department == event.promotedBy ||
            widget.user.localFunction.department == event.promotedBy;

    if (authorizedUser && isDepartmentAllowed) {
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
