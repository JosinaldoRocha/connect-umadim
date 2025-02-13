import 'package:connect_umadim_app/app/core/style/app_text.dart';
import 'package:connect_umadim_app/app/data/models/user_model.dart';
import 'package:connect_umadim_app/app/presentation/home/views/widgets/user_item_widget.dart';
import 'package:flutter/material.dart';

import '../../../../core/style/app_colors.dart';
import '../../../../data/enums/funciton_type_enum.dart';

class UsersListWidget extends StatefulWidget {
  const UsersListWidget({
    super.key,
    required this.users,
  });
  final List<UserModel> users;

  @override
  State<UsersListWidget> createState() => _UsersListWidgetState();
}

class _UsersListWidgetState extends State<UsersListWidget> {
  final Map<String, bool> expandedSections = {};
  final List<FunctionType> functionOrder = [
    FunctionType.leader,
    FunctionType.viceLeader,
    FunctionType.regent,
    FunctionType.secretary,
    FunctionType.doorman,
    FunctionType.receptionist,
    FunctionType.media,
    FunctionType.evangelist,
    FunctionType.events,
  ];

  @override
  Widget build(BuildContext context) {
    final Map<String, List<UserModel>> groupedUsers = {};

    for (var user in widget.users) {
      groupedUsers.putIfAbsent(user.congregation, () => []).add(user);
    }

    return Expanded(
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 8),
        children: groupedUsers.keys.map(
          (congregation) {
            final usersInGroup = groupedUsers[congregation]!;

            usersInGroup.sort((a, b) {
              int indexA = functionOrder.indexOf(a.localFunction.title);
              int indexB = functionOrder.indexOf(b.localFunction.title);

              if (indexA == -1) indexA = functionOrder.length;
              if (indexB == -1) indexB = functionOrder.length;

              if (indexA != indexB) {
                return indexA.compareTo(indexB);
              }
              return a.name.compareTo(b.name);
            });

            final isExpanded = expandedSections[congregation] ?? false;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.lightGrey,
                      borderRadius: isExpanded
                          ? BorderRadius.circular(12).copyWith(
                              bottomLeft: Radius.circular(0),
                              bottomRight: Radius.circular(0),
                            )
                          : BorderRadius.circular(12).copyWith(
                              topLeft: Radius.circular(0),
                              topRight: Radius.circular(0),
                            ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          congregation != "Templo central"
                              ? 'Cong. $congregation'
                              : congregation,
                          style: AppText.text().bodyMedium!.copyWith(
                                color: AppColor.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Icon(
                          isExpanded ? Icons.expand_less : Icons.expand_more,
                          size: 28,
                          color: AppColor.primary,
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      expandedSections[congregation] = !isExpanded;
                    });
                  },
                ),
                if (isExpanded)
                  ...usersInGroup.map(
                    (user) => ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      visualDensity: VisualDensity.compact,
                      title: UserItemWidget(user: user),
                    ),
                  ),
              ],
            );
          },
        ).toList(),
      ),
    );
  }
}
