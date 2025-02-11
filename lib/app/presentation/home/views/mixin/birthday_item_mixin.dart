import 'package:connect_umadim_app/app/data/enums/funciton_type_enum.dart';
import 'package:flutter/material.dart';
import 'package:connect_umadim_app/app/data/models/user_model.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../../core/style/app_colors.dart';
import '../../../../core/style/app_text.dart';

mixin BirthdayItemMixin {
  String formatBirthdayDate(DateTime birthDate) {
    final now = DateTime.now();
    final yesterday = now.subtract(Duration(days: 1));
    final tomorrow = now.add(Duration(days: 1));

    if (birthDate.day == now.day && birthDate.month == now.month) return "Hoje";
    if (birthDate.day == yesterday.day && birthDate.month == yesterday.month) {
      return "Ontem";
    }
    if (birthDate.day == tomorrow.day && birthDate.month == tomorrow.month) {
      return "Amanhã";
    }
    switch (birthDate.weekday) {
      case 1:
        return "Segunda";
      case 2:
        return "Terça";
      case 3:
        return "Quarta";
      case 4:
        return "Quinta";
      case 5:
        return "Sexta";
      case 6:
        return "Sábado";
      default:
        return "Domingo";
    }
  }

  String getUserFunction(UserModel user) {
    if (user.umadimFunction.title != FunctionType.member) {
      return user.umadimFunction.title.text;
    } else if (user.localFunction.title != FunctionType.member) {
      return user.localFunction.title.text;
    }
    return '';
  }

  Container buildWeekDayText(UserModel user) {
    return Container(
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: formatBirthdayDate(user.birthDate!) == "Hoje"
            ? AppColor.primaryGreen
            : AppColor.mediumGrey,
        borderRadius: BorderRadius.circular(4).copyWith(
          topLeft: Radius.circular(0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: formatBirthdayDate(user.birthDate!)
            .split("")
            .map(
              (char) => Text(
                char,
                textAlign: TextAlign.center,
                style:
                    AppText.text().bodySmall!.copyWith(color: AppColor.white),
              ),
            )
            .toList(),
      ),
    );
  }

  Expanded buildImage(UserModel user) {
    //TODO: handle image loading in the web version
    return Expanded(
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: user.photoUrl != null && user.photoUrl!.isNotEmpty
              ? Image.network(
                  user.photoUrl!,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return SizedBox(
                      height: 6,
                      width: 40,
                      child: LoadingIndicator(
                        indicatorType: Indicator.ballPulse,
                        colors: [AppColor.white],
                      ),
                    );
                  },
                )
              : Image.asset('assets/images/profile.png'),
        ),
      ),
    );
  }
}
