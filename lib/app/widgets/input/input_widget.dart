import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/style/app_colors.dart';
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

  /// FormInput
  ///
  /// [controller] form controller
  ///
  /// [prefix] is a prefix of input will be rendered on left side of input
  ///
  /// [type] type of text input
  ///
  /// [isEnable] is a bool that will be check if formInput is active
  ///
  /// [validator] function that validate input
  ///
  /// [onChanged] onChanged of formInput
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
    return Focus(
      child: Builder(
        builder: (context) {
          final FocusNode focusNode = Focus.of(context);
          final bool hasFocus = focusNode.hasFocus;
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
            cursorColor: AppColor.primary,
            cursorHeight: 22,
            inputFormatters: inputFormatters,
            keyboardType: keyboardType,
            obscureText: obscureText ?? false,
            maxLines: lines,
            style: AppText.text().bodyMedium!.copyWith(
                  color: !isEnabled ? AppColor.black : AppColor.primaryGrey,
                  fontSize: 18,
                ),
            textAlign: TextAlign.left,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 17.0,
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: const BorderSide(color: AppColor.error),
              ),
              errorStyle: const TextStyle(color: AppColor.error),
              filled: true,
              fillColor: hasFocus ? AppColor.lightBlue : AppColor.lightGrey,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: const BorderSide(color: AppColor.mediumBlue),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: const BorderSide(color: AppColor.error),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide.none,
              ),
              prefixIcon: prefix,
              hintStyle: AppText.text().bodyMedium?.copyWith(
                    color: AppColor.primaryGrey,
                    fontWeight: FontWeight.w500,
                  ),
              hintText: hintText,
              suffixIcon: sufix,
            ),
          );
        },
      ),
    );
  }
}
