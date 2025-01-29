import 'package:connect_umadim_app/app/presentation/authentication/views/pages/complete_profile_form/complete_profile_form_page.dart';
import 'package:connect_umadim_app/app/presentation/authentication/views/pages/email_sent/email_sent_page.dart';
import 'package:connect_umadim_app/app/presentation/authentication/views/pages/recover_password/recover_password_page.dart';
import 'package:connect_umadim_app/app/presentation/authentication/views/pages/sign_up/sign_up_page.dart';
import 'package:flutter/material.dart';
import '../../../core/navigator/navigator.dart';
import '../../splash/views/pages/splash_page.dart';
import '../views/pages/complete_profile/complete_profile_page.dart';
import '../views/pages/sign_in/sign_in_page.dart';

class AuthRoutes extends IModuleRoutes {
  @override
  String get routeName => '/auth';

  @override
  Map<String, Widget Function(BuildContext context)> get routes => {
        initialRoute: (_) => const SplashPage(),
        '/login': (context) => SignInPage(),
        '/register': (context) => SignUpPage(),
        '/recover-password': (context) => RecoverPasswordPage(),
        '/email-sent': (context) => EmailSentPage(),
        '/complete-profile': (context) => CompleteProfilePage(),
        '/complete-profile-form': (context) => CompleteProfileFormPage(),
      };
}
