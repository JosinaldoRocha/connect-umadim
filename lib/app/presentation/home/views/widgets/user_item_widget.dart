import 'package:connect_umadim_app/app/core/style/app_colors.dart';
import 'package:connect_umadim_app/app/core/style/app_text.dart';
import 'package:connect_umadim_app/app/data/models/user_model.dart';
import 'package:connect_umadim_app/app/presentation/user/views/widgets/user_details_modal_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../widgets/spacing/spacing.dart';

class UserItemWidget extends ConsumerWidget {
  const UserItemWidget({
    super.key,
    required this.user,
  });
  final UserModel user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        builder: (context) => UserDetailsModalWidget(user: user),
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
          Text(
            getInitials(user.name),
            style: AppText.text().bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColor.primaryGrey,
                ),
          ),
        ],
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
