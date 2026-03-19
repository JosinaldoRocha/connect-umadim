import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/style/app_colors.dart';
import '../../core/style/app_decoration.dart';
import '../../core/style/app_text.dart';

class InputWidget extends StatelessWidget {
  final TextEditingController controller;
  final Widget? prefix;
  final Widget? sufix;
  final TextInputType keyboardType;
  final bool isEnabled;
  final String? hintText;
  final bool? obscureText;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final Iterable<String>? autofillHints;
  final bool readOnly;
  final TextInputAction? action;
  final Function(String)? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final int? lines;
  final int? minLines;
  final AutovalidateMode? autoValidate;
  final FocusNode? focus;
  final bool autoFocus;
  final TextCapitalization? textCapitalization;

  InputWidget({
    required this.controller,
    this.isEnabled = true,
    this.prefix,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.hintText,
    this.sufix,
    this.autofillHints,
    this.obscureText,
    this.readOnly = false,
    this.inputFormatters,
    this.action,
    this.onSubmitted,
    this.lines,
    this.autoValidate,
    this.focus,
    this.autoFocus = false,
    this.minLines,
    this.textCapitalization = TextCapitalization.sentences,
    super.key,
  });

  final _focus = FocusNode();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Focus(
      child: Builder(
        builder: (context) {
          final hasFocus = Focus.of(context).hasFocus;

          final fillColor = isDark
              ? AppColor.darkSurfaceVariant
              : AppColor.lightSurfaceVariant;

          final borderColor = hasFocus
              ? AppColor.orange500
              : (isDark ? AppColor.darkBorder : AppColor.lightBorder);

          final border = OutlineInputBorder(
            borderRadius: AppDecoration.radiusMd,
            borderSide: BorderSide(color: borderColor, width: 1.5),
          );

          final errorBorder = OutlineInputBorder(
            borderRadius: AppDecoration.radiusMd,
            borderSide: const BorderSide(color: AppColor.error, width: 1.5),
          );

          return TextFormField(
            textCapitalization: textCapitalization!,
            focusNode: focus ?? _focus,
            validator: validator,
            minLines: minLines,
            autofocus: autoFocus,
            autovalidateMode: autoValidate,
            onChanged: onChanged,
            enabled: isEnabled,
            autofillHints: autofillHints,
            controller: controller,
            textInputAction: action,
            textAlignVertical: TextAlignVertical.center,
            onFieldSubmitted: onSubmitted,
            readOnly: readOnly,
            cursorColor: AppColor.orange500,
            cursorHeight: 20,
            inputFormatters: inputFormatters,
            keyboardType: keyboardType,
            obscureText: obscureText ?? false,
            maxLines: lines,
            style: AppText.bodyMedium(context).copyWith(
              color: isDark
                  ? AppColor.darkOnBackground
                  : AppColor.lightOnBackground,
            ),
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              filled: true,
              fillColor: fillColor,
              border: border,
              enabledBorder: border,
              focusedBorder: OutlineInputBorder(
                borderRadius: AppDecoration.radiusMd,
                borderSide:
                    const BorderSide(color: AppColor.orange500, width: 1.5),
              ),
              errorBorder: errorBorder,
              focusedErrorBorder: errorBorder,
              errorStyle: const TextStyle(color: AppColor.error, fontSize: 11),
              prefixIcon: prefix,
              suffixIcon: sufix,
              hintText: hintText,
              hintStyle: AppText.bodyMedium(context).copyWith(
                color: isDark
                    ? AppColor.darkOnSurfaceMuted
                    : AppColor.lightOnSurfaceMuted,
              ),
            ),
          );
        },
      ),
    );
  }
}
