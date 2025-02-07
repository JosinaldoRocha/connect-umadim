import 'package:flutter/material.dart';

import '../../../../data/models/user_model.dart';
import '../../../../widgets/spacing/spacing.dart';
import 'birthday_item_widget.dart';

class BirthdaysListWidget extends StatelessWidget {
  const BirthdaysListWidget({
    super.key,
    required this.birthdayUsers,
  });

  final List<UserModel> birthdayUsers;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => Container(
          margin: EdgeInsets.only(
            left: index == 0 ? 8 : 0,
            right: index == birthdayUsers.length - 1 ? 8 : 0,
          ),
          child: BirthdayItemWidget(user: birthdayUsers[index]),
        ),
        separatorBuilder: (context, index) => SpaceHorizontal.x2(),
        itemCount: birthdayUsers.length,
      ),
    );
  }
}
