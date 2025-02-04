import 'dart:typed_data';

import 'package:connect_umadim_app/app/data/data_source/user_data_source.dart';
import 'package:connect_umadim_app/app/data/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/helpers/helpers.dart';

typedef CompleteProfileState = CommonState<CommonError, bool>;

class CompleteProfileStateNotifier extends StateNotifier<CompleteProfileState> {
  CompleteProfileStateNotifier({required this.dataSource})
      : super(const CompleteProfileState.initial());

  final UserDataSource dataSource;

  Future<void> load(
    UserModel user,
    Uint8List? imageBytes,
  ) async {
    state = const CompleteProfileState.loadInProgress();

    final result = await dataSource.completeProfile(user, imageBytes);
    result.fold(
      (l) => state = CompleteProfileState.loadFailure(l),
      (r) => state = CompleteProfileState.loadSuccess(r),
    );
  }
}
