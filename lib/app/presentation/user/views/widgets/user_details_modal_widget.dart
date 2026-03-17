import 'package:connect_umadim_app/app/core/style/app_colors.dart';
import 'package:connect_umadim_app/app/core/supabase/supabase_init.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/style/app_text.dart';
import '../../../../data/enums/funciton_type_enum.dart';
import '../../../../data/models/user_model.dart';
import '../../../../widgets/spacing/spacing.dart';
import '../../providers/user_provider.dart';

class UserDetailsModalWidget extends ConsumerWidget {
  const UserDetailsModalWidget({
    super.key,
    required this.user,
  });
  final UserModel user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserState = ref.watch(getUserProvider);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        children: [
          SpaceVertical.x6(),
          _buildImage(),
          SpaceVertical.x8(),
          _buildItem(context, description: user.name),
          if (user.umadimFunction.title != FunctionType.member)
            _buildItem(context,
                description: '${user.umadimFunction.title.text} da UMADIM'),
          _buildItem(context,
            description:
                '${user.localFunction.title.text} da ${user.localFunction.department.text}',
          ),
          currentUserState.maybeWhen(
            loadSuccess: (data) {
              bool umadimAdm =
                  data.umadimFunction.title == FunctionType.leader ||
                      data.umadimFunction.title == FunctionType.viceLeader;

              bool localAdm = ((data.localFunction.title ==
                          FunctionType.leader ||
                      data.localFunction.title == FunctionType.viceLeader) &&
                  data.localFunction.department ==
                      user.localFunction.department);

              return umadimAdm || localAdm
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildItem(context, title: 'E-mail: ', description: user.email),
                        _buildItem(context, title: 'Sexo: ', description: user.gender),
                        _buildItem(context,
                          title: 'Congregação: ',
                          description: user.congregation,
                        ),
                        if (user.phoneNumber != null &&
                            user.phoneNumber!.isNotEmpty)
                          _buildItem(context,
                            title: 'Telefone: ',
                            description: user.phoneNumber!,
                          ),
                        _buildItem(context,
                          title: 'Nascimento: ',
                          description:
                              DateFormat('dd/MM/yyyy').format(user.birthDate!),
                        ),
                      ],
                    )
                  : Container();
            },
            orElse: () => Container(),
          ),
          SpaceVertical.x4(),
        ],
      ),
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
        children: [
          Text(
            title ?? '',
            style: AppText.bodyLarge(context).copyWith(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColor.darkOnSurfaceMuted
                    : AppColor.lightOnSurfaceMuted),
          ),
          Text(
            description,
            style: AppText.bodyLarge(context).copyWith(),
          ),
        ],
      ),
    );
  }

  Center _buildImage() {
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
