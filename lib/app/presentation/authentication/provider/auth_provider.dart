import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/data_provider.dart';
import '../state/authentication/check_authentication_state_notifier.dart';

final authenticationState =
    StateNotifierProvider<CheckAutenticationStatenotifier, Autenticationstate>(
  (ref) => CheckAutenticationStatenotifier(
    dataSource: ref.read(authDataSourceProvider),
  ),
);
