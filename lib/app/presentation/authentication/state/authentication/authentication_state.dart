part of 'check_authentication_state_notifier.dart';

abstract class Autenticationstate {}

class Initial implements Autenticationstate {}

class Loading implements Autenticationstate {}

class IsLogged implements Autenticationstate {
  final User? user;
  IsLogged(this.user);
}

class IsNotLogged implements Autenticationstate {}
