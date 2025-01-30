import 'package:connect_umadim_app/app/data/models/user_model.dart';
import 'package:connect_umadim_app/app/presentation/authentication/views/mixin/complete_profile_mixin.dart';
import 'package:connect_umadim_app/app/presentation/authentication/views/widgets/select_user_image_widget.dart';
import 'package:connect_umadim_app/app/widgets/input/input_formatters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../../../core/constants/constants.dart';
import '../../../../../core/helpers/helpers.dart';
import '../../../../../core/style/app_colors.dart';
import '../../../../../core/style/app_text.dart';
import '../../../../../widgets/button/button_widget.dart';
import '../../../../../widgets/dropdown/dropdown_widget.dart';
import '../../../../../widgets/input/input_validators.dart';
import '../../../../../widgets/input/input_widget.dart';
import '../../../../../widgets/spacing/spacing.dart';
import '../../../../user/providers/user_provider.dart';

class CompleteProfileFormPage extends ConsumerStatefulWidget {
  const CompleteProfileFormPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CompleteProfileFormPageState();
}

class _CompleteProfileFormPageState
    extends ConsumerState<CompleteProfileFormPage>
    with CompleteProfileFormMixin {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(getUserProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    listen();

    final userState = ref.watch(getUserProvider);

    final state = ref.watch(completeProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Completar cadastro',
          style: AppText.text().titleLarge!.copyWith(
                color: AppColor.tertiary,
              ),
        ),
      ),
      body: userState.maybeWhen(
        loadInProgress: () => Center(
          child: SizedBox(
            height: 10,
            width: 80,
            child: LoadingIndicator(
              indicatorType: Indicator.ballPulse,
              colors: [AppColor.primary],
            ),
          ),
        ),
        loadSuccess: (data) => Column(
          children: [
            Form(
              key: formKey,
              child: Expanded(
                child: ListView(
                  padding: EdgeInsets.all(16).copyWith(top: 40),
                  children: [
                    SelectUserImageWidget(
                      image: image,
                      onTap: getImage,
                    ),
                    const SpaceVertical.x10(),
                    _buildFullName(data),
                    const SpaceVertical.x5(),
                    DropDownWidget(
                      controller: congregationController,
                      list: congregationsList,
                      hintText: 'Seleciona a congregação',
                    ),
                    const SpaceVertical.x5(),
                    DropDownWidget(
                      controller: localFunctionController,
                      list: functionTypeList,
                      hintText: 'Sua função na congregação',
                    ),
                    const SpaceVertical.x5(),
                    InputWidget(
                      controller: birthDateController,
                      hintText: 'Data de nascimento ex.: 01//01/0101',
                      keyboardType: TextInputType.datetime,
                      validator: InputValidators.date,
                      inputFormatters: [InputFormatters.date()],
                    ),
                    const SpaceVertical.x5(),
                    DropDownWidget(
                      controller: genderController,
                      list: genderList,
                      hintText: 'Selecione seu gênero',
                    ),
                    const SpaceVertical.x5(),
                    InputWidget(
                      controller: phoneController,
                      hintText: 'Telefone',
                      keyboardType: TextInputType.phone,
                      inputFormatters: [InputFormatters.phone()],
                    ),
                    const SpaceVertical.x5(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ButtonWidget(
                isLoading: state is CommonStateLoadInProgress,
                title: 'Finalizar',
                onTap: () => onTapButton(data),
              ),
            ),
          ],
        ),
        loadFailure: (failure) => Center(
          child: Text(
            'Não foi possível carregar a página. Tente novamente!',
            style: AppText.text().bodyMedium!,
          ),
        ),
        orElse: () => Container(),
      ),
    );
  }

  Container _buildFullName(UserModel data) {
    return Container(
      height: 56,
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: AppColor.lightGrey,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Text(
        data.name,
        overflow: TextOverflow.ellipsis,
        style: AppText.text().bodyMedium!.copyWith(
              color: AppColor.tertiary,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
