import 'package:connect_umadim_app/app/data/models/user_model.dart';
import 'package:connect_umadim_app/app/presentation/profile/views/mixin/edit_profile_mixin.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/style/app_colors.dart';
import '../../../../core/style/app_text.dart';
import '../../../../widgets/button/button_widget.dart';
import '../../../../widgets/dropdown/dropdown_widget.dart';
import '../../../../widgets/input/input_formatters.dart';
import '../../../../widgets/input/input_widget.dart';
import '../../../../widgets/select_date/select_date_widget.dart';
import '../../../../widgets/spacing/spacing.dart';
import '../../../authentication/views/widgets/select_user_image_widget.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({
    super.key,
    required this.user,
  });
  final UserModel user;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage>
    with EditProfileMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Editar perfil',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: AppColor.amber500,
              ),
        ),
      ),
      body: Column(
        children: [
          Form(
            key: formKey,
            child: Expanded(
              child: ListView(
                padding: EdgeInsets.all(16).copyWith(top: 40),
                children: [
                  SelectUserImageWidget(
                    image: image,
                    imageBytes: imageBytes,
                    networkPhotoUrl: widget.user.photoUrl,
                    onTap: getImage,
                  ),
                  const SpaceVertical.x10(),
                  _buildNotEditableField(context, widget.user.name),
                  const SpaceVertical.x5(),
                  _buildNotEditableField(context, widget.user.email),
                  const SpaceVertical.x3(),
                  _buildDropDown(
                    context: context,
                    controller: congregationController,
                    labelText: 'Congregação:',
                    hintText: 'Seleciona a congregação',
                    list: congregationsList,
                  ),
                  const SpaceVertical.x3(),
                  _buildDropDown(
                    context: context,
                    controller: umadimFunctionController,
                    labelText: 'Função na umadim:',
                    hintText: 'Função na umadim',
                    list: functionTypeList,
                  ),
                  const SpaceVertical.x3(),
                  _buildDropDown(
                    context: context,
                    controller: localFunctionController,
                    labelText: 'Função na congregação:',
                    hintText: 'Função na congregação',
                    list: functionTypeList,
                  ),
                  const SpaceVertical.x3(),
                  SelectDateWidget(
                    date: birthDate,
                    hintText: 'Data de nascimento',
                    onTap: selectBirthDate,
                    onClean: () {
                      setState(() {
                        birthDate = null;
                      });
                    },
                  ),
                  const SpaceVertical.x3(),
                  _buildDropDown(
                    context: context,
                    controller: genderController,
                    labelText: 'Sexo:',
                    hintText: 'Selecione seu gênero',
                    list: genderList,
                  ),
                  const SpaceVertical.x2(),
                  _buildInputWidget(
                    context: context,
                    controller: phoneController,
                    labelText: 'Telefone:',
                    hintText: 'Ex.: (99) 99999-9999',
                    keyboardType: TextInputType.phone,
                    inputFormatters: [InputFormatters.phone()],
                  ),
                  const SpaceVertical.x3(),
                  // FunctionModel umadimFunction;
                  // FunctionModel localFunction;
                  // DateTime? birthDate;
                  // String gender;
                  // String? photoUrl;
                  // String? phoneNumber;
                  // String congregation;
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ButtonWidget(
              //isLoading: state is CommonStateLoadInProgress,
              title: 'Finalizar',
              onTap: () => onTapButton(widget.user),
            ),
          ),
        ],
      ),
    );
  }

  Column _buildDropDown({
    required BuildContext context,
    required SingleValueDropDownController controller,
    required String labelText,
    String? hintText,
    required List<DropDownValueModel> list,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Text(
            labelText,
            style: AppText.bodyMedium(context).copyWith(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColor.darkOnSurfaceMuted
                      : AppColor.lightOnSurfaceMuted,
                  fontSize: 14,
                ),
          ),
        ),
        DropDownWidget(
          controller: controller,
          list: list,
          hintText: hintText ?? '',
        ),
      ],
    );
  }

  Column _buildInputWidget({
    required BuildContext context,
    required TextEditingController controller,
    required String labelText,
    String? hintText,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Text(
            labelText,
            style: AppText.bodyMedium(context).copyWith(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColor.darkOnSurfaceMuted
                    : AppColor.lightOnSurfaceMuted),
          ),
        ),
        SpaceVertical.x1(),
        InputWidget(
          controller: phoneController,
          hintText: hintText,
          keyboardType: keyboardType ?? TextInputType.name,
          inputFormatters: inputFormatters,
        ),
      ],
    );
  }

  Container _buildNotEditableField(BuildContext context, String title) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 56,
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurfaceVariant : AppColor.lightSurfaceVariant,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Text(
        title,
        overflow: TextOverflow.ellipsis,
        style: AppText.bodyMedium(context).copyWith(
              color: isDark ? AppColor.darkOnSurfaceMuted : AppColor.lightOnSurfaceMuted,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
