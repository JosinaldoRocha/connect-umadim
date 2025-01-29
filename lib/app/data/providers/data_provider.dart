import 'package:connect_umadim_app/app/data/data_source/user_data_source.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data_source/auth_data_source.dart';

final authDataSourceProvider = Provider(
  (ref) => AuthDataSource(),
);

final userDataSourceProvider = Provider(
  (ref) => UserDataSource(),
);
