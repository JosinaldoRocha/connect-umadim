import 'package:connect_umadim_app/app/core/style/app_colors.dart';
import 'package:connect_umadim_app/app/presentation/home/views/widgets/umadim_board_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../user/providers/user_provider.dart';

class UmadimBoardWidget extends ConsumerWidget {
  const UmadimBoardWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userListState = ref.watch(listUsersProvider);

    return userListState.maybeWhen(
      loadSuccess: (data) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 94,
              color: AppColor.bgColor,
              margin: EdgeInsets.only(top: 16),
              child: UmadimBoardListWidget(data: data),
            ),
          ],
        );
      },
      orElse: () => Container(),
    );
  }
}
