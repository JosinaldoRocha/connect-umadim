import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';

import '../../core/style/app_colors.dart';
import '../../core/style/app_decoration.dart';
import '../../core/style/app_text.dart';

class DropDownWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final fillColor =
        isDark ? AppColor.darkSurfaceVariant : AppColor.lightSurfaceVariant;
    final borderColor = isDark ? AppColor.darkBorder : AppColor.lightBorder;
    final textColor =
        isDark ? AppColor.darkOnBackground : AppColor.lightOnBackground;
    final hintColor =
        isDark ? AppColor.darkOnSurfaceMuted : AppColor.lightOnSurfaceMuted;
    final iconColor =
        isDark ? AppColor.darkOnSurfaceMuted : AppColor.lightOnSurfaceMuted;

    final border = OutlineInputBorder(
      borderRadius: AppDecoration.radiusMd,
      borderSide: BorderSide(color: borderColor, width: 1.5),
    );

    final errorBorder = OutlineInputBorder(
      borderRadius: AppDecoration.radiusMd,
      borderSide: const BorderSide(color: AppColor.error, width: 1.5),
    );

    return DropDownTextField(
      validator: validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, selecione uma opção';
            }
            return null;
          },
      textStyle: AppText.bodyMedium(context).copyWith(color: textColor),
      textFieldDecoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        filled: true,
        fillColor: fillColor,
        hintText: hintText,
        hintStyle: AppText.bodyMedium(context).copyWith(color: hintColor),
        enabledBorder: border,
        focusedBorder: OutlineInputBorder(
          borderRadius: AppDecoration.radiusMd,
          borderSide: const BorderSide(color: AppColor.orange500, width: 1.5),
        ),
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
        errorStyle: const TextStyle(color: AppColor.error, fontSize: 11),
        border: border,
      ),
      dropDownIconProperty: IconProperty(
        icon: Icons.keyboard_arrow_down_rounded,
        size: 24,
        color: iconColor,
      ),
      clearIconProperty: IconProperty(
        icon: Icons.close_rounded,
        size: 18,
        color: iconColor,
      ),
      readOnly: true,
      controller: controller,
      clearOption: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      dropDownItemCount: list.length,
      dropDownList: list,
      listPadding: listPadding ?? ListPadding(top: 12, bottom: 4),
      onChanged: onChanged,
    );
  }
}
