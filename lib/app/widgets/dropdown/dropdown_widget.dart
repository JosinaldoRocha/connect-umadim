import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import '../../core/style/app_colors.dart';
import '../../core/style/app_text.dart';

class DropDownWidget extends StatefulWidget {
  const DropDownWidget({
    super.key,
    required this.controller,
    required this.list,
    required this.hintText,
    this.onChanged,
    this.validator,
    this.listPadding,
  });
  final SingleValueDropDownController controller;
  final List<DropDownValueModel> list;
  final String hintText;
  final Function(dynamic)? onChanged;
  final String? Function(String?)? validator;
  final ListPadding? listPadding;

  @override
  State<DropDownWidget> createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  FocusNode searchFocusNode = FocusNode();
  FocusNode textFieldFocusNode = FocusNode();
  late SingleValueDropDownController controller;

  @override
  Widget build(BuildContext context) {
    return DropDownTextField(
      validator: widget.validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, selecione uma opção';
            }
            return null;
          },
      textStyle: AppText.bodyMedium(context).copyWith(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColor.darkOnSurfaceMuted
                : AppColor.lightOnSurfaceMuted,
          ),
      textFieldDecoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 17,
        ),
        filled: true,
        fillColor: Theme.of(context).brightness == Brightness.dark
            ? AppColor.darkOnSurfaceMuted
            : AppColor.lightOnSurfaceMuted,
        hintText: widget.hintText,
        hintStyle: AppText.bodyMedium(context).copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColor.darkOnSurfaceMuted
                  : AppColor.lightOnSurfaceMuted,
              fontWeight: FontWeight.w500,
            ),
        enabledBorder: _buildOutlineInputBorder(context),
        focusedBorder: _buildOutlineInputBorder(context),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(color: AppColor.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        errorStyle: const TextStyle(color: AppColor.error),
      ),
      dropDownIconProperty: IconProperty(
        icon: Icons.arrow_drop_down_rounded,
        size: 35,
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColor.darkOnSurfaceMuted
            : AppColor.lightOnSurfaceMuted,
      ),
      clearIconProperty: IconProperty(
        icon: Icons.close,
        size: 20,
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColor.darkOnSurfaceMuted
            : AppColor.lightOnSurfaceMuted,
      ),
      readOnly: true,
      controller: widget.controller,
      clearOption: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      dropDownItemCount: widget.list.length,
      dropDownList: widget.list,
      listPadding: ListPadding(top: 12, bottom: 4),
      onChanged: widget.onChanged,
    );
  }

  OutlineInputBorder _buildOutlineInputBorder(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: BorderSide(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColor.darkOnSurfaceMuted
              : AppColor.lightOnSurfaceMuted),
    );
  }
}
