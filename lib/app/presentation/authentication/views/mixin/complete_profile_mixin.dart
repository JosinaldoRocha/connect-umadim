import 'dart:io';

import 'package:connect_umadim_app/app/data/models/user_model.dart';
import 'package:connect_umadim_app/app/presentation/user/providers/user_provider.dart';
import 'package:connect_umadim_app/app/presentation/user/states/complete_profile/complete_profile_state_notifier.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/style/app_colors.dart';
import '../../../../widgets/snack_bar/app_snack_bar_widget.dart';
import '../pages/complete_profile_form/complete_profile_form_page.dart';

mixin CompleteProfileFormMixin<T extends CompleteProfileFormPage>
    on ConsumerState<T> {
  final congregationController = SingleValueDropDownController();
  final localFunctionController = SingleValueDropDownController();
  final birthDateController = TextEditingController();
  final genderController = SingleValueDropDownController();
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  File? image;

  void listen() {
    ref.listen<CompleteProfileState>(
      completeProfileProvider,
      (previous, next) {
        next.maybeWhen(
          loadSuccess: (data) =>
              Navigator.of(context).pushReplacementNamed('/auth'),
          loadFailure: (message) {
            AppSnackBar.show(
              context,
              'Houve um erro ao completar seu perfil. Tente novamente!',
              AppColor.error,
            );
          },
          orElse: () {},
        );
      },
    );
  }

  Future<void> getImage() async {
    final pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 30);

    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  void onTapButton(UserModel data) {
    if (formKey.currentState!.validate()) {
      final user = UserModel(
        id: data.id,
        name: data.name,
        email: data.email,
        password: data.password,
        umadimFunction: data.umadimFunction,
        localFunction: localFunctionController.dropDownValue!.name,
        birthDate: birthDateController.text,
        gender: genderController.dropDownValue!.name,
        congregation: congregationController.dropDownValue!.name,
        photoUrl: image?.path,
        phoneNumber: phoneController.text,
        createdAt: data.createdAt,
      );

      ref.read(completeProfileProvider.notifier).load(user: user);
    }
  }
}
