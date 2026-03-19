import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../core/style/app_colors.dart';
import '../../core/style/app_decoration.dart';
import '../../core/style/app_text.dart';
import '../spacing/spacing.dart';

enum ButtonType { primary, secundary }

class ButtonWidget extends StatelessWidget {
  final ButtonType type;
  final String title;
  final bool isLoading;
  final void Function()? onTap;
  final double height;
  final double? width;
  final Widget? leading;
  final Widget? prefixIcon;
  final Color? color;
  final Color? textColor;
  final Widget? trailing;

  const ButtonWidget({
    super.key,
    required this.title,
    this.isLoading = false,
    this.onTap,
    this.height = 52,
    this.leading,
    this.prefixIcon,
    this.color,
    this.width,
    this.textColor,
    this.trailing,
  }) : type = ButtonType.primary;

  const ButtonWidget.secoundary({
    super.key,
    required this.title,
    this.isLoading = false,
    this.onTap,
    this.height = 52,
    this.leading,
    this.prefixIcon,
    this.color,
    this.width,
    this.textColor,
    this.trailing,
  }) : type = ButtonType.secundary;

  Color get _bgColor =>
      type == ButtonType.primary ? AppColor.orange500 : AppColor.info;

  Color get _titleColor =>
      type == ButtonType.primary ? AppColor.light50 : AppColor.orange500;

  Color get _disabledColor => _bgColor.withOpacity(0.38);

  bool get _isDisabled => onTap == null && !isLoading;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      height: height,
      minWidth: width ?? double.maxFinite,
      shape: RoundedRectangleBorder(
        borderRadius: AppDecoration.radiusMd,
      ),
      color: color ?? _bgColor,
      disabledColor: !isLoading ? _disabledColor : color ?? _bgColor,
      onPressed: !isLoading ? onTap : null,
      child: isLoading
          ? SizedBox(
              height: 8,
              width: 48,
              child: LoadingIndicator(
                indicatorType: Indicator.ballPulse,
                colors: [
                  (color == Colors.white) ? AppColor.orange500 : Colors.white,
                ],
                strokeWidth: 1,
              ),
            )
          : _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return trailing == null
        ? _buildText(context)
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildText(context),
              const SpaceHorizontal.x2(),
              trailing!,
            ],
          );
  }

  Widget _buildText(BuildContext context) {
    return Text(
      title,
      style: AppText.labelLarge(context).copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: textColor ?? _titleColor,
      ),
    );
  }
}
