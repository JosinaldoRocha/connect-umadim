import 'package:connect_umadim_app/app/data/models/user_model.dart';
import 'package:flutter/material.dart';

import '../../../../core/style/app_text.dart';
import '../../../../widgets/spacing/spacing.dart';

class UmadimBoardItemWidget extends StatelessWidget {
  const UmadimBoardItemWidget({
    super.key,
    required this.user,
  });
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            user.umadimFunction.title.text,
            style: AppText.text().bodySmall!.copyWith(fontSize: 10),
          ),
          SpaceVertical.x1(),
          ClipOval(
            child: user.photoUrl != null && user.photoUrl!.isNotEmpty
                ? Image.network(
                    user.photoUrl!,
                    fit: BoxFit.cover,
                    height: 50,
                    width: 50,
                  )
                : Image.asset(
                    'assets/images/profile.png',
                    fit: BoxFit.cover,
                    height: 50,
                    width: 50,
                  ),
          ),
          SpaceVertical.x1(),
          Text(
            getFirstAndInitial(user.name),
            overflow: TextOverflow.ellipsis,
            style: AppText.text().bodySmall!.copyWith(),
          ),
        ],
      ),
    );
  }

  String getFirstAndInitial(String fullName) {
    final names = fullName.split(' ');
    if (names.length >= 2) {
      return '${names[0]} ${names[1][0]}';
    }
    return names[0];
  }
}
