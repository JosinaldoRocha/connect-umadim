import 'dart:io';

import 'package:connect_umadim_app/app/core/constants/constants.dart';
import 'package:connect_umadim_app/app/data/enums/congregation_enum.dart';
import 'package:connect_umadim_app/app/data/models/user_model.dart';
import 'package:connect_umadim_app/app/presentation/profile/views/pages/edit_profile_page.dart';
import 'package:connect_umadim_app/app/presentation/user/providers/user_provider.dart';
import 'package:connect_umadim_app/app/presentation/user/states/complete_profile/complete_profile_state_notifier.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/style/app_colors.dart';
import '../../../../data/enums/department_enum.dart';
import '../../../../data/models/function_model.dart';
import '../../../../widgets/snack_bar/app_snack_bar_widget.dart';

mixin EditProfileMixin<T extends EditProfilePage> on ConsumerState<T> {
  final congregationController = SingleValueDropDownController();
  final umadimFunctionController = SingleValueDropDownController();
  final localFunctionController = SingleValueDropDownController();
  final genderController = SingleValueDropDownController();
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  File? image;
  Uint8List? imageBytes;
  DateTime? birthDate;

  @override
  void initState() {
    super.initState();
    // Só usa File para caminhos locais; photoUrl de rede (http/https) não é arquivo
    final photoUrl = widget.user.photoUrl ?? '';
    if (photoUrl.isNotEmpty && !photoUrl.startsWith('http')) {
      image = File(photoUrl);
    }
    birthDate = widget.user.birthDate;
    congregationController.setDropDown(
      congregationsList.firstWhere(
        (e) => e.value == Congregation.fromString(widget.user.congregation),
      ),
    );
    localFunctionController.setDropDown(
      functionTypeList.firstWhere(
        (e) => e.value == widget.user.localFunction.title,
      ),
    );
    umadimFunctionController.setDropDown(
      functionTypeList.firstWhere(
        (e) => e.value == widget.user.umadimFunction.title,
      ),
    );
    genderController.setDropDown(
      genderList.firstWhere(
        (e) => e.name == widget.user.gender,
      ),
    );
    phoneController.text = widget.user.phoneNumber ?? '';
  }

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

  Future<void> selectBirthDate() async {
    final currentDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: currentDate,
    );

    if (picked != null && picked != birthDate) {
      setState(() {
        birthDate = picked;
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

  void onTapButton(UserModel data) {
    if (formKey.currentState!.validate()) {
      if (birthDate != null) {
        final congregation = congregationController.dropDownValue?.value;

        final user = UserModel(
          id: data.id,
          name: data.name,
          email: data.email,
          password: data.password,
          umadimFunction: data.umadimFunction,
          localFunction: FunctionModel(
            title: localFunctionController.dropDownValue?.value,
            department: Department.fromByCongregation(congregation),
          ),
          birthDate: birthDate,
          gender: genderController.dropDownValue!.name,
          congregation: congregationController.dropDownValue!.name,
          photoUrl: image?.path,
          phoneNumber: phoneController.text,
          createdAt: data.createdAt,
        );

        ref.read(completeProfileProvider.notifier).load(user, imageBytes);
      }
    }
  }
}
