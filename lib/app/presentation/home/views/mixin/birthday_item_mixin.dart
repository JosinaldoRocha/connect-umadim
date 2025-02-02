import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:connect_umadim_app/app/data/models/user_model.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../../core/style/app_colors.dart';
import '../../../../core/style/app_text.dart';

mixin BirthdayItemMixin {
  String formatBirthdayDate(DateTime birthday) {
    final now = DateTime.now();
    final yesterday = now.subtract(Duration(days: 1));
    final tomorrow = now.add(Duration(days: 1));

    if (birthday.day == now.day && birthday.month == now.month) return "Hoje";
    if (birthday.day == yesterday.day && birthday.month == yesterday.month) {
      return "Ontem";
    }
    if (birthday.day == tomorrow.day && birthday.month == tomorrow.month) {
      return "Amanhã";
    }

    final startWeek = now.subtract(Duration(days: now.weekday % 7));
    final birthdayCurrentWeek =
        DateTime(now.year, birthday.month, birthday.day);
    final differenceDays = birthdayCurrentWeek.difference(startWeek).inDays;

    final correctDate = startWeek.add(Duration(days: differenceDays + 1));
    final newWeekDay = DateFormat.EEEE('pt_BR').format(correctDate);

    return newWeekDay[0].toUpperCase() + newWeekDay.substring(1);
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
    return Expanded(
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: user.photoUrl != null && user.photoUrl!.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: user.photoUrl!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) {
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
