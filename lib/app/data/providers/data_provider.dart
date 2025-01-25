import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data_source/auth_data_source.dart';

final authDataSourceProvider = Provider(
  (ref) => AuthDataSource(),
);
