import 'package:connect_umadim_app/app/widgets/spacing/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/style/app_colors.dart';
import '../../../../core/style/app_text.dart';
import '../../../../data/models/user_model.dart';
import '../../../../widgets/image/profile_image_widget.dart';
import '../../../user/providers/user_provider.dart';
import 'loading_home_app_bar_widget.dart';

class HomeAppBarWidget extends ConsumerStatefulWidget {
  const HomeAppBarWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _HomeAppBarWidgetState();
}

class _HomeAppBarWidgetState extends ConsumerState<HomeAppBarWidget> {
  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(getUserProvider);

    return Container(
      color: AppColor.bgColor,
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 48,
        bottom: 8,
      ),
      child: userState.maybeWhen(
        loadInProgress: () => LoadingHomeAppBarWidget(),
        loadSuccess: (data) => Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SpaceHorizontal.x1(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'A paz do Senhor ✋',
                  style: AppText.text().titleSmall,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      _getUserFunction(data),
                      style: AppText.text().titleSmall!.copyWith(),
                    ),
                    Text(
                      getFirstAndSecondName(data.name),
                      style: AppText.text().titleMedium!.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ],
            ),
            Spacer(),
            ProfileImageWidget(
              image: data.photoUrl,
              size: 52,
            ),
          ],
        ),
        orElse: () => Container(),
      ),
    );
  }

  String _getUserFunction(UserModel data) {
    if (data.umadimFunction != null &&
        (data.umadimFunction == "Líder" || data.umadimFunction == "Regente")) {
      return '${data.umadimFunction} ';
    }

    return (data.localFunction == "Líder" || data.localFunction == "Regente")
        ? data.localFunction
        : '';
  }

  String getGreetingMessage() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return 'Bom dia';
    } else if (hour >= 12 && hour < 18) {
      return 'Boa tarde';
    } else {
      return 'Boa noite';
    }
  }

  String getFirstAndSecondName(String fullName) {
    final names = fullName.split(' ');
    if (names.length >= 2) {
      return '${names[0]} ${names[1]}';
    }
    return names[0];
  }
}
