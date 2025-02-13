import 'package:connect_umadim_app/app/core/style/app_colors.dart';
import 'package:connect_umadim_app/app/core/style/app_text.dart';
import 'package:connect_umadim_app/app/data/models/user_model.dart';
import 'package:connect_umadim_app/app/widgets/spacing/space_horizontal_widget.dart';
import 'package:flutter/material.dart';

class UserItemWidget extends StatelessWidget {
  const UserItemWidget({
    super.key,
    required this.user,
  });
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 6,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: AppColor.lightGrey,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                user.name,
                overflow: TextOverflow.ellipsis,
                style: AppText.text()
                    .bodyMedium!
                    .copyWith(color: AppColor.primaryGrey),
              ),
            ),
            SpaceHorizontal.x2(),
            CircleAvatar(
              radius: 14,
              backgroundColor: AppColor.lightGrey2,
              child: Text(
                getInitials(user.name),
                style: AppText.text().bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColor.primaryGrey,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getInitials(String name) {
    List<String> names = name.split(' ');
    String initials = names.isNotEmpty ? names.first[0] : '';

    if (names.length > 1) {
      initials += names[1][0];
    }

    return initials.toUpperCase();
  }
}
