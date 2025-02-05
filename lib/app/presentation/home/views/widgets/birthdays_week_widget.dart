import 'package:connect_umadim_app/app/core/style/app_text.dart';
import 'package:connect_umadim_app/app/presentation/home/views/widgets/birthday_item_widget.dart';
import 'package:connect_umadim_app/app/presentation/user/providers/user_provider.dart';
import 'package:connect_umadim_app/app/widgets/spacing/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/models/user_model.dart';
import 'birthdays_list_widget.dart';

class BirthdaysWeekWidget extends ConsumerWidget {
  const BirthdaysWeekWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userListState = ref.watch(listUsersProvider);

    return userListState.maybeWhen(
      loadSuccess: (data) {
        final birthdayUsers = filterUsersByBirthdayWeek(data);

        return birthdayUsers.isEmpty
            ? Container()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SpaceVertical.x5(),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      birthdayUsers.length > 1
                          ? 'Aniversariantes da semana 🎈'
                          : 'Aniversariante da semana 🎈',
                      style: AppText.text().titleSmall,
                    ),
                  ),
                  Container(
                    height: 244,
                    margin: EdgeInsets.symmetric(vertical: 4),
                    child: birthdayUsers.length == 1
                        ? Center(
                            child: BirthdayItemWidget(user: birthdayUsers[0]),
                          )
                        : BirthdaysListWidget(birthdayUsers: birthdayUsers),
                  ),
                ],
              );
      },
      orElse: () => Container(),
    );
  }

  List<UserModel> filterUsersByBirthdayWeek(List<UserModel> users) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday % 7));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    List<UserModel> filteredUsers = [];

    for (var item in users) {
      final birthDate = item.birthDate!;
      final birthThisYear = DateTime(now.year, birthDate.month, birthDate.day);

      if (birthThisYear
              .isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
          birthThisYear.isBefore(endOfWeek.add(const Duration(days: 1)))) {
        final user = item.copyWith(birthDate: birthThisYear);

        filteredUsers.add(user);
      }
    }

    filteredUsers.sort((a, b) {
      int getWeekday(DateTime date) {
        return date.weekday == 7 ? 0 : date.weekday;
      }

      final aDayOfWeek =
          getWeekday(DateTime(now.year, a.birthDate!.month, a.birthDate!.day));
      final bDayOfWeek =
          getWeekday(DateTime(now.year, b.birthDate!.month, b.birthDate!.day));

      return aDayOfWeek.compareTo(bDayOfWeek);
    });

    return filteredUsers;
  }
}
