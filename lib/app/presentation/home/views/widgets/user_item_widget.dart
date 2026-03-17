import 'package:connect_umadim_app/app/core/supabase/supabase_init.dart';
import 'package:connect_umadim_app/app/core/style/app_colors.dart';
import 'package:connect_umadim_app/app/core/style/app_text.dart';
import 'package:connect_umadim_app/app/data/enums/funciton_type_enum.dart';
import 'package:connect_umadim_app/app/data/models/user_model.dart';
import 'package:connect_umadim_app/app/presentation/user/views/pages/user_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/style/app_decoration.dart';

class UserItemWidget extends ConsumerWidget {
  final UserModel user;
  const UserItemWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isLeader = user.localFunction.title != FunctionType.member ||
        user.umadimFunction.title != FunctionType.member;

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => UserDetailsPage(user: user),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                borderRadius: AppDecoration.radiusMd,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isLeader
                      ? [AppColor.wine700, AppColor.orange600]
                      : [AppColor.wine800, AppColor.wine600],
                ),
              ),
              child: user.photoUrl != null &&
                      user.photoUrl!.isNotEmpty &&
                      isSupabaseImageUrlValid(user.photoUrl)
                  ? ClipRRect(
                      borderRadius: AppDecoration.radiusMd,
                      child: Image.network(user.photoUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              _initialsWidget(context, user.name)),
                    )
                  : _initialsWidget(context, user.name),
            ),

            const SizedBox(width: 10),

            // Nome e função
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: AppText.bodySmall(context).copyWith(
                      color: isDark
                          ? AppColor.darkOnBackground
                          : AppColor.lightOnBackground,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (user.localFunction.title != FunctionType.member)
                    Text(
                      user.localFunction.title.text,
                      style: AppText.labelSmall(context).copyWith(
                        color: isLeader
                            ? AppColor.orange400
                            : (isDark
                                ? AppColor.darkOnSurfaceMuted
                                : AppColor.lightOnSurfaceMuted),
                      ),
                    ),
                ],
              ),
            ),

            // Ponto laranja = líder | Iniciais = membro (comportamento original)
            if (isLeader)
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.orange500,
                ),
              )
            else
              Text(
                _getInitials(user.name),
                style: AppText.labelSmall(context).copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColor.darkOnSurfaceMuted
                      : AppColor.lightOnSurfaceMuted,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _initialsWidget(BuildContext context, String name) => Center(
        child: Text(
          _getInitials(name),
          style: AppText.labelSmall(context)
              .copyWith(color: AppColor.light50, fontWeight: FontWeight.w700),
        ),
      );

  // Preservado do original
  String _getInitials(String name) {
    final parts = name.split(' ');
    String initials = parts.isNotEmpty ? parts.first[0] : '';
    if (parts.length > 1) initials += parts[1][0];
    return initials.toUpperCase();
  }
}
