import 'package:connect_umadim_app/app/core/style/app_colors.dart';
import 'package:connect_umadim_app/app/core/style/app_text.dart';
import 'package:connect_umadim_app/app/data/models/user_model.dart';
import 'package:connect_umadim_app/app/presentation/home/views/mixin/birthday_item_mixin.dart';
import 'package:connect_umadim_app/app/widgets/spacing/vertical_space_widget.dart';
import 'package:flutter/material.dart';

class BirthdayItemWidget extends StatelessWidget with BirthdayItemMixin {
  const BirthdayItemWidget({
    super.key,
    required this.user,
  });
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 208,
          width: 150,
          margin: EdgeInsets.only(),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: user.gender == "Masculino"
                ? AppColor.primary
                : AppColor.secondary,
            borderRadius: BorderRadius.circular(16).copyWith(
              topRight: Radius.circular(4),
            ),
            boxShadow: [
              BoxShadow(
                spreadRadius: 1,
                offset: Offset(0, 2),
                blurRadius: 3,
                color: AppColor.lightGrey,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildImage(user),
              SpaceVertical.x2(),
              Text(
                getUserFunction(user),
                style: AppText.text().bodySmall!.copyWith(
                      fontSize: 10,
                      color: AppColor.white,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(
                user.name,
                overflow: TextOverflow.ellipsis,
                style:
                    AppText.text().bodyMedium!.copyWith(color: AppColor.white),
              ),
              Text(
                user.congregation,
                overflow: TextOverflow.ellipsis,
                style:
                    AppText.text().bodySmall!.copyWith(color: AppColor.white),
              ),
            ],
          ),
        ),
        Positioned(
          right: 0,
          child: buildWeekDayText(user),
        ),
      ],
    );
  }
}
