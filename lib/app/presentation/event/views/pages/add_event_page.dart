import 'package:connect_umadim_app/app/core/constants/constants.dart';
import 'package:connect_umadim_app/app/data/models/user_model.dart';
import 'package:connect_umadim_app/app/presentation/event/provider/event_provider.dart';
import 'package:connect_umadim_app/app/presentation/event/views/widgets/event_image_picker_widget.dart';
import 'package:connect_umadim_app/app/widgets/select_date/select_date_widget.dart';
import 'package:connect_umadim_app/app/widgets/time_selector/time_selector_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/helpers/common_state/state.dart';
import '../../../../core/style/app_colors.dart';
import '../../../../core/style/app_text.dart';
import '../../../../widgets/button/button_widget.dart';
import '../../../../widgets/dropdown/dropdown_widget.dart';
import '../../../../widgets/input/input_widget.dart';
import '../../../../widgets/spacing/spacing.dart';
import '../mixin/add_event_mixin.dart';

class AddEventPage extends ConsumerStatefulWidget {
  const AddEventPage({
    super.key,
    required this.user,
  });
  final UserModel user;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddEventPageState();
}

class _AddEventPageState extends ConsumerState<AddEventPage>
    with AddEventMixin {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addEventProvider);

    listen();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Criar evento',
          style: AppText.text().titleLarge!.copyWith(
                color: AppColor.tertiary,
              ),
        ),
        iconTheme: IconThemeData(color: AppColor.tertiary),
      ),
      body: Column(
        children: [
          Form(
            key: formKey,
            child: Expanded(
              child: ListView(
                padding: EdgeInsets.all(16),
                children: [
                  EventImagePickerWidget(
                    image: image,
                    imageBytes: imageBytes,
                    onTap: getImage,
                  ),
                  const SpaceVertical.x5(),
                  InputWidget(
                    controller: titleController,
                    hintText: 'Nome',
                    validator: (p0) {
                      if (p0!.isEmpty) {
                        return 'Campo vazio.';
                      }
                      return null;
                    },
                  ),
                  const SpaceVertical.x5(),
                  DropDownWidget(
                    controller: eventTypeController,
                    list: eventTypeList,
                    hintText: 'Categoria',
                  ),
                  const SpaceVertical.x5(),
                  InputWidget(
                    controller: eventLocationController,
                    hintText: 'Local',
                    validator: (p0) {
                      if (p0!.isEmpty) {
                        return 'Campo vazio.';
                      }
                      return null;
                    },
                  ),
                  const SpaceVertical.x5(),
                  SelectDateWidget(
                    date: eventDate,
                    hintText: 'Seleciona a data',
                    onTap: selectEventDate,
                    onClean: () {
                      setState(() {
                        eventDate = null;
                      });
                    },
                  ),
                  const SpaceVertical.x5(),
                  TimeSelectorWidget(
                    date: eventTime,
                    onTap: selectEventTime,
                    hintText: 'Selecione o horário',
                    onClean: () {
                      setState(() {
                        eventTime = null;
                      });
                    },
                  ),
                  const SpaceVertical.x5(),
                  DropDownWidget(
                    controller: promotedByController,
                    list: departmentList,
                    hintText: 'Departamento responsável',
                  ),
                  const SpaceVertical.x5(),
                  InputWidget(
                    controller: descriptionController,
                    hintText: 'Descrição (opcional)',
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ButtonWidget(
              isLoading: state is CommonStateLoadInProgress,
              title: 'Finalizar',
              onTap: onTapButton,
            ),
          ),
        ],
      ),
    );
  }
}
