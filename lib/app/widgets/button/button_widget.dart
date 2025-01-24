import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../core/style/app_colors.dart';
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

  ///  Button
  /// button that will be execute show a circular progress indicator
  ///
  /// [text] is the text inside button
  ///
  /// [onTap] is a function will be execute when button is clicked
  ///
  /// [isLoading] is a bool that check if  circular progress
  /// indicator is active.
  /// IMPORTANT -  You need change manually [isLoading]
  /// to activated the circular progress indicator
  ///
  /// [color] is a background color of button

  const ButtonWidget({
    super.key,
    required this.title,
    this.isLoading = false,
    this.onTap,
    this.height = 56,
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
    this.height = 56,
    this.leading,
    this.prefixIcon,
    this.color,
    this.width,
    this.textColor,
    this.trailing,
  }) : type = ButtonType.secundary;
  Color get buttonColor {
    return type == ButtonType.primary ? AppColor.primary : AppColor.lightBlue;
  }

  Color get buttonTitleColor {
    return type == ButtonType.primary ? Colors.white : AppColor.primary;
  }

  Color get buttonDisabledColor => buttonColor.withOpacity(0.48);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      height: height,
      minWidth: width ?? double.maxFinite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      color: color ?? buttonColor,
      disabledColor: !isLoading ? buttonDisabledColor : color ?? buttonColor,
      onPressed: !isLoading ? onTap : null,
      child: !isLoading
          ? _buildContent()
          : Center(
              child: SizedBox(
                height: 8,
                width: 48,
                child: LoadingIndicator(
                  indicatorType: Indicator.ballPulse,
                  colors: [
                    (color == Colors.white) ? AppColor.primary : Colors.white,
                  ],
                  strokeWidth: 1,
                ),
              ),
            ),
    );
  }

  // Widget _buildContent() {
  //   return leading != null ? _buildWithIcon() : _buildText();
  // }

  Widget _buildContent() {
    return trailing == null
        ? _buildText()
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: AppText.text().bodyMedium!.copyWith(fontSize: 16),
              ),
              const SpaceHorizontal.x2(),
              trailing!
            ],
          );
  }

  Widget _buildText() {
    return Text(
      title,
      style: AppText.text().bodyMedium!.copyWith(fontSize: 16),
    );
  }

  // Widget _buildWithIcon() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       const Spacer(),
  //       if (prefixIcon != null)
  //         Align(
  //           alignment: Alignment.centerLeft,
  //           child: Padding(
  //             padding: const EdgeInsets.only(left: Spacing.x10),
  //             child: leading,
  //           ),
  //         ),
  //       const SizedBox(
  //         width: 16,
  //       ),
  //       Center(
  //         child: _buildText(),
  //       ),
  //       const SizedBox(
  //         width: 16,
  //       ),
  //       Align(
  //         alignment: Alignment.centerRight,
  //         child: Padding(
  //           padding: const EdgeInsets.only(right: Spacing.x10),
  //           child: leading,
  //         ),
  //       ),
  //       const Spacer(),
  //     ],
  //   );
  // }
}
