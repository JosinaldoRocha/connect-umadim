import 'package:connect_umadim_app/app/data/models/user_model.dart';
import 'package:connect_umadim_app/app/presentation/home/views/widgets/umadim_board_item_widget.dart';
import 'package:flutter/material.dart';

import '../../../../data/enums/funciton_type_enum.dart';
import '../../../../widgets/spacing/spacing.dart';

class UmadimBoardListWidget extends StatelessWidget {
  const UmadimBoardListWidget({
    super.key,
    required this.data,
  });
  final List<UserModel> data;

  @override
  Widget build(BuildContext context) {
    final users = getFilteredLeaders(data);

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        final leader = users[index];
        return Container(
          margin: EdgeInsets.only(
            left: index == 0 ? 16 : 0,
            right: index == users.length - 1 ? 16 : 0,
          ),
          child: UmadimBoardItemWidget(user: leader),
        );
      },
      separatorBuilder: (context, index) => SpaceHorizontal.x2(),
      itemCount: users.length,
    );
  }

  List<UserModel> getFilteredLeaders(List<UserModel> users) {
    final orderMap = {
      FunctionType.leader: 0,
      FunctionType.viceLeader: 1,
      FunctionType.regent: 2,
      FunctionType.secretary: 3,
      FunctionType.doorman: 4,
      FunctionType.receptionist: 5,
      FunctionType.media: 6,
      FunctionType.evangelist: 7,
      FunctionType.events: 8,
    };

    return users
        .where((user) => user.umadimFunction.title != FunctionType.member)
        .toList()
      ..sort(
        (a, b) => orderMap[a.umadimFunction.title]!
            .compareTo(orderMap[b.umadimFunction.title]!),
      );
  }
}
