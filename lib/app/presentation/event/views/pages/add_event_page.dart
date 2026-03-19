import 'package:connect_umadim_app/app/core/constants/constants.dart';
import 'package:connect_umadim_app/app/core/style/app_colors.dart';
import 'package:connect_umadim_app/app/core/style/app_text.dart';
import 'package:connect_umadim_app/app/data/models/user_model.dart';
import 'package:connect_umadim_app/app/presentation/event/provider/event_provider.dart';
import 'package:connect_umadim_app/app/presentation/event/views/mixin/add_event_mixin.dart';
import 'package:connect_umadim_app/app/presentation/event/views/widgets/event_image_picker_widget.dart';
import 'package:connect_umadim_app/app/widgets/button/button_widget.dart';
import 'package:connect_umadim_app/app/widgets/dropdown/dropdown_widget.dart';
import 'package:connect_umadim_app/app/widgets/input/input_widget.dart';
import 'package:connect_umadim_app/app/widgets/select_date/select_date_widget.dart';
import 'package:connect_umadim_app/app/widgets/time_selector/time_selector_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/helpers/common_state/state.dart';
import '../../../../core/style/app_decoration.dart';

class AddEventPage extends ConsumerStatefulWidget {
  const AddEventPage({super.key, required this.user});
  final UserModel user;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddEventPageState();
}

class _AddEventPageState extends ConsumerState<AddEventPage>
    with AddEventMixin, SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addEventProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    listen();

    return Scaffold(
      backgroundColor:
          isDark ? AppColor.darkBackground : AppColor.lightBackground,
      appBar: _buildAppBar(context, isDark),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SlideTransition(
          position: _slideAnim,
          child: Column(
            children: [
              Expanded(
                child: Form(
                  key: formKey,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Imagem
                      EventImagePickerWidget(
                        image: image,
                        imageBytes: imageBytes,
                        onTap: getImage,
                      ),
                      const SizedBox(height: 16),

                      // Seção: Informações
                      _sectionLabel(context, 'Informações do evento'),
                      const SizedBox(height: 10),

                      _fieldLabel(context, isDark, 'Nome do evento'),
                      InputWidget(
                        controller: titleController,
                        hintText: 'Ex: Culto de Jovens',
                        validator: (v) =>
                            v!.isEmpty ? 'Campo obrigatório' : null,
                      ),
                      const SizedBox(height: 12),

                      _fieldLabel(context, isDark, 'Categoria'),
                      DropDownWidget(
                        controller: eventTypeController,
                        list: eventTypeList,
                        hintText: 'Selecione a categoria',
                      ),
                      const SizedBox(height: 12),

                      _fieldLabel(context, isDark, 'Local'),
                      InputWidget(
                        controller: eventLocationController,
                        hintText: 'Ex: Sede UMADIM',
                        validator: (v) =>
                            v!.isEmpty ? 'Campo obrigatório' : null,
                      ),
                      const SizedBox(height: 12),

                      // Data e horário em linha
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _fieldLabel(context, isDark, 'Data'),
                                SelectDateWidget(
                                  date: eventDate,
                                  hintText: 'Selecionar',
                                  onTap: selectEventDate,
                                  onClean: () =>
                                      setState(() => eventDate = null),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _fieldLabel(context, isDark, 'Horário'),
                                TimeSelectorWidget(
                                  date: eventTime,
                                  hintText: 'Selecionar',
                                  onTap: selectEventTime,
                                  onClean: () =>
                                      setState(() => eventTime = null),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      _fieldLabel(context, isDark, 'Departamento responsável'),
                      DropDownWidget(
                        controller: promotedByController,
                        list: departmentList,
                        hintText: 'Selecione o departamento',
                      ),

                      // Seção: Opcional
                      const SizedBox(height: 20),
                      Divider(
                        height: 1,
                        color:
                            isDark ? AppColor.darkBorder : AppColor.lightBorder,
                      ),
                      const SizedBox(height: 14),
                      _sectionLabel(context, 'Campos opcionais',
                          optional: true),
                      const SizedBox(height: 10),

                      _fieldLabel(context, isDark, 'Descrição'),
                      InputWidget(
                        controller: descriptionController,
                        hintText: 'Descreva o evento...',
                      ),
                      const SizedBox(height: 12),

                      _fieldLabel(context, isDark, 'Tema'),
                      InputWidget(
                        controller: themeController,
                        hintText: 'Ex: Prosseguindo para o Alvo',
                      ),
                      const SizedBox(height: 12),

                      _fieldLabel(context, isDark, 'Ministração'),
                      InputWidget(
                        controller: ministerController,
                        hintText: 'Nome do ministro',
                      ),
                      const SizedBox(height: 12),

                      _fieldLabel(context, isDark, 'Louvor'),
                      InputWidget(
                        controller: singerController,
                        hintText: 'Ministério ou cantor',
                      ),
                    ],
                  ),
                ),
              ),

              // Botão fixo
              Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColor.darkBackground
                      : AppColor.lightBackground,
                  border: Border(
                    top: BorderSide(
                      color:
                          isDark ? AppColor.darkBorder : AppColor.lightBorder,
                    ),
                  ),
                ),
                child: ButtonWidget(
                  isLoading: state is CommonStateLoadInProgress,
                  title: 'Criar evento',
                  onTap: onTapButton,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isDark) {
    return AppBar(
      backgroundColor:
          isDark ? AppColor.darkBackground : AppColor.lightBackground,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isDark
                ? AppColor.darkSurfaceVariant
                : AppColor.lightSurfaceVariant,
            borderRadius: AppDecoration.radiusMd,
            border: Border.all(
              color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
            ),
          ),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 16,
            color:
                isDark ? AppColor.darkOnBackground : AppColor.lightOnBackground,
          ),
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text('Criar evento', style: AppText.headlineMedium(context)),
      centerTitle: false,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              AppColor.orange600,
              AppColor.orange400,
              AppColor.amber400,
            ]),
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(BuildContext context, String label,
      {bool optional = false}) {
    return Row(
      children: [
        Text(
          label.toUpperCase(),
          style: AppText.labelSmall(context)
              .copyWith(letterSpacing: 0.1, fontWeight: FontWeight.w600),
        ),
        if (optional) ...[
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColor.darkSurfaceVariant,
              borderRadius: AppDecoration.radiusFull,
            ),
            child: Text(
              'opcional',
              style: AppText.labelSmall(context).copyWith(fontSize: 9),
            ),
          ),
        ],
      ],
    );
  }

  Widget _fieldLabel(BuildContext context, bool isDark, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: AppText.labelMedium(context).copyWith(
          color: isDark ? AppColor.light200 : AppColor.lightOnSurface,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
