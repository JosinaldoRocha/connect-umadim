import 'package:connect_umadim_app/app/core/style/app_colors.dart';
import 'package:connect_umadim_app/app/core/supabase/supabase_init.dart';
import 'package:connect_umadim_app/app/core/style/app_text.dart';
import 'package:connect_umadim_app/app/data/models/user_model.dart';
import 'package:connect_umadim_app/app/widgets/spacing/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../../../data/enums/funciton_type_enum.dart';
import '../../../user/providers/user_provider.dart';

class ProfileComponent extends ConsumerWidget {
  const ProfileComponent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserState = ref.watch(getUserProvider);

    return currentUserState.maybeWhen(
      loadSuccess: (data) => Container(
        color: AppColor.lightBackground,
        child: Column(
          children: [
            ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(16).copyWith(top: 64),
              children: [
                _buildImage(data),
                SpaceVertical.x4(),
                Center(
                  child: Text(
                    data.name,
                    style: AppText.bodyLarge(context)
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                SpaceVertical.x1(),
                Container(
                  padding: EdgeInsets.all(12).copyWith(top: 0),
                  decoration: BoxDecoration(
                    color: AppColor.light50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (data.umadimFunction.title != FunctionType.member)
                        _buildItem(context,
                            description:
                                '${data.umadimFunction.title.text} da UMADIM'),
                      _buildItem(context,
                        description:
                            '${data.localFunction.title.text} da ${data.localFunction.department.text}',
                      ),
                      Divider(
                        height: 8,
                        endIndent: 32,
                        indent: 32,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColor.darkOnSurfaceMuted
                            : AppColor.lightOnSurfaceMuted,
                      ),
                      _buildItem(context, title: 'E-mail: ', description: data.email),
                      _buildItem(context, title: 'Sexo: ', description: data.gender),
                      _buildItem(context,
                        title: 'Congregação: ',
                        description: data.congregation,
                      ),
                      if (data.phoneNumber != null &&
                          data.phoneNumber!.isNotEmpty)
                        _buildItem(context,
                          title: 'Telefone: ',
                          description: data.phoneNumber!,
                        ),
                      _buildItem(context,
                        title: 'Nascimento: ',
                        description:
                            DateFormat('dd/MM/yyyy').format(data.birthDate!),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                padding: EdgeInsets.all(24),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pushNamed(
                    '/profile/edit',
                    arguments: data,
                  );
                },
                icon: SvgPicture.asset(
                  'assets/icons/edit.svg',
                  colorFilter: ColorFilter.mode(
                    AppColor.wine600,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      orElse: () => Container(),
    );
  }

  Padding _buildItem(
    BuildContext context, {
    String? title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: title == null
            ? MainAxisAlignment.center
            : MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title ?? '',
            style: AppText.bodyMedium(context)
                .copyWith(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColor.darkOnSurfaceMuted
                        : AppColor.lightOnSurfaceMuted),
          ),
          Text(
            description,
            style: AppText.bodyMedium(context).copyWith(),
          ),
        ],
      ),
    );
  }

  Center _buildImage(UserModel user) {
    return Center(
      child: ClipOval(
        child: user.photoUrl != null &&
                user.photoUrl!.isNotEmpty &&
                isSupabaseImageUrlValid(user.photoUrl)
            ? Image.network(
                user.photoUrl!,
                fit: BoxFit.cover,
                height: 120,
                width: 120,
              )
            : Image.asset(
                'assets/images/profile.png',
                fit: BoxFit.cover,
                height: 120,
                width: 120,
              ),
      ),
    );
  }
}
