import 'package:connect_umadim_app/app/core/firebase/firebase_init.dart';
import 'package:connect_umadim_app/app/core/supabase/supabase_init.dart';
import 'package:flutter/material.dart';

import 'app_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseInit.init();
  await SupabaseInit.init();
  runApp(const AppWidget());
}
