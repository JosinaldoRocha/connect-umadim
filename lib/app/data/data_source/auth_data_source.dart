import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_umadim_app/app/data/models/user_model.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/helpers/helpers.dart';

class AuthDataSource {
  final firebaseAuth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  Future<Either<CommonError, bool>> signUp({
    required UserModel user,
  }) async {
    try {
      UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );

      String userId = userCredential.user!.uid;

      user.id = userId;

      await firestore.collection('users').doc(userId).set(user.toMap());

      return Right(true);
    } on Exception catch (e) {
      return Left(GenerateError.fromException(e));
    }
  }

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
