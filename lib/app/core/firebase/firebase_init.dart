import 'package:connect_umadim_app/app/core/firebase/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseInit {
  static Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
