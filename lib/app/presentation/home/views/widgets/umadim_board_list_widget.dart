import 'package:connect_umadim_app/app/core/style/app_colors.dart';
import 'package:connect_umadim_app/app/data/enums/funciton_type_enum.dart';
import 'package:connect_umadim_app/app/data/models/user_model.dart';
import 'package:connect_umadim_app/app/presentation/home/views/widgets/umadim_board_item_widget.dart';
import 'package:flutter/material.dart';

class UmadimBoardListWidget extends StatelessWidget {
  const UmadimBoardListWidget({super.key, required this.data});
  final List<UserModel> data;

  // Preservado do original — mesma ordem e filtro
  static const Map<FunctionType, int> _orderMap = {
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

  List<UserModel> _getFilteredLeaders(List<UserModel> users) {
    return users
        .where((u) => u.umadimFunction.title != FunctionType.member)
        .toList()
      ..sort((a, b) {
        final iA = _orderMap[a.umadimFunction.title] ?? 99;
        final iB = _orderMap[b.umadimFunction.title] ?? 99;
        return iA.compareTo(iB);
      });
  }

  @override
  Widget build(BuildContext context) {
    final leaders = _getFilteredLeaders(data);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (leaders.isEmpty) return const SizedBox.shrink();

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: leaders.length,
      separatorBuilder: (_, i) => _buildSeparator(
        context,
        isDark,
        // Divisor vertical apenas após o primeiro item (presidente)
        showDivider: i == 0,
      ),
      itemBuilder: (_, i) => UmadimBoardItemWidget(
        user: leaders[i],
        isPresident: i == 0,
      ),
    );
  }

  Widget _buildSeparator(BuildContext context, bool isDark,
      {required bool showDivider}) {
    if (!showDivider) return const SizedBox(width: 4);

    return Row(
      children: [
        const SizedBox(width: 4),
        Container(
          width: 1,
          height: 60,
          color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}
