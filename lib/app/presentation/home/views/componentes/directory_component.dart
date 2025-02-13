import 'package:connect_umadim_app/app/presentation/home/views/widgets/users_list_widget.dart';
import 'package:connect_umadim_app/app/presentation/user/providers/user_provider.dart';
import 'package:connect_umadim_app/app/widgets/spacing/vertical_space_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../../core/style/app_colors.dart';
import '../../../../core/style/app_text.dart';

class DirectoryComponent extends ConsumerWidget {
  const DirectoryComponent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(listUsersProvider);

    return state.maybeWhen(
      //TODO: create component for loading
      loadInProgress: () => _buildLoadingIndicator(),
      loadSuccess: (data) {
        return Container(
          color: AppColor.lightBgColor,
          padding: EdgeInsets.only(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                color: AppColor.cardBackground,
                padding: EdgeInsets.only(
                  top: 48,
                  left: 16,
                  right: 16,
                  bottom: 12,
                ),
                child: Center(
                  child: Text(
                    'Umadim campo 01',
                    style: AppText.text().bodyLarge!.copyWith(
                          fontSize: 26,
                          color: AppColor.white,
                        ),
                  ),
                ),
              ),
              SpaceVertical.x2(),
              UsersListWidget(users: data),
            ],
          ),
        );
      },

      loadFailure: (failure) => Center(
        child: Text(
          'Houve um erro ao carregar os dados,\ntente novamente!',
          textAlign: TextAlign.center,
        ),
      ),
      orElse: () => Container(),
    );
  }

  Center _buildLoadingIndicator() {
    return Center(
      child: SizedBox(
        height: 8,
        width: 40,
        child: LoadingIndicator(
          indicatorType: Indicator.ballPulse,
          colors: [AppColor.primary],
        ),
      ),
    );
  }
}
