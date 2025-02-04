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
        return "Segunda-feira";
      case 2:
        return "Terça-feira";
      case 3:
        return "Quarta-feira";
      case 4:
        return "Quinta-feira";
      case 5:
        return "Sexta-feira";
      case 6:
        return "Sábado";
      default:
        return "Domingo";
    }
  }

  String getUserFunction(UserModel user) {
    if (user.umadimFunction != "Membro" && user.umadimFunction != null) {
      return user.umadimFunction!;
    } else if (user.localFunction != "Membro") {
      return user.localFunction;
    }
    return '';
  }

  Container buildWeekDayText(UserModel user) {
    return Container(
      width: 150,
      padding: EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: formatBirthdayDate(user.birthDate!) == "Hoje"
            ? AppColor.primaryGreen
            : AppColor.primaryGrey,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: Text(
        formatBirthdayDate(user.birthDate!),
        textAlign: TextAlign.center,
        style: AppText.text().bodySmall!.copyWith(color: AppColor.white),
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
              : Image.asset(
                  'assets/images/profile.png',
                ),
        ),
      ),
    );
  }
}
