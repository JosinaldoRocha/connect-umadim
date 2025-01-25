import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/helpers/helpers.dart';

class AuthDataSource {
  final firebaseAuth = FirebaseAuth.instance;

  Future<Either<CommonError, bool>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(true);
    } on Exception catch (e) {
      return Left(GenerateError.fromException(e));
    }
  }

  Future<Either<CommonError, User?>> getAuthUser() async {
    try {
      final user = firebaseAuth.currentUser;
      return Right(user);
    } on Exception catch (e) {
      return Left(GenerateError.fromException(e));
    }
  }
}
