import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/data_provider.dart';
import '../states/complete_profile/complete_profile_state_notifier.dart';
import '../states/get_local_user/get_user_state_notifier.dart';
import '../states/list_users/agents_list_state_notifier.dart';

final completeProfileProvider =
    StateNotifierProvider<CompleteProfileStateNotifier, CompleteProfileState>(
  (ref) => CompleteProfileStateNotifier(
    dataSource: ref.read(userDataSourceProvider),
  ),
);

final getUserProvider =
    StateNotifierProvider<GetUserStateNotifier, GetUserState>(
  (ref) => GetUserStateNotifier(
    dataSource: ref.read(userDataSourceProvider),
  ),
);

final listUsersProvider =
    StateNotifierProvider<ListUsersStateNotifier, ListUsersState>(
  (ref) => ListUsersStateNotifier(
    dataSource: ref.read(userDataSourceProvider),
  ),
);
