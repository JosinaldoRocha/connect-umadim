import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_umadim_app/app/core/helpers/errors/sign_up_errors.dart';
import 'package:connect_umadim_app/app/data/models/leader_model.dart';
import 'package:connect_umadim_app/app/data/models/user_model.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/helpers/helpers.dart';

class AuthDataSource {
  final firebaseAuth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  Future<Either<SignUpError, bool>> signUp({required UserModel user}) async {
    try {
      final isEmailRegistered =
          await _isEmailAlreadyRegistered(email: user.email);

      if (isEmailRegistered) return Left(SignUpError.emailAlreadyExists);

      if (user.umadimFunction != "Membro") {
        final leader = await _getLeaderIfExists(email: user.email);

        if (leader == null) return Left(SignUpError.noPermission);

        if (leader.isRegistered) return Left(SignUpError.emailAlreadyExists);

        final userCredential =
            await _createUserAuth(email: user.email, password: user.password!);
        user.id = userCredential.user!.uid;

        await _saveUser(user: user);
        await firestore
            .collection('leaders')
            .doc(leader.id)
            .update({'isRegistered': true});

        return Right(true);
      }

      final userCredential =
          await _createUserAuth(email: user.email, password: user.password!);
      user.id = userCredential.user!.uid;

      await _saveUser(user: user);
      return Right(true);
    } on Exception {
      return Left(SignUpError.unknown);
    }
  }

  Future<bool> _isEmailAlreadyRegistered({required String email}) async {
    final getUsers = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    return getUsers.docs.isNotEmpty;
  }

  Future<LeaderModel?> _getLeaderIfExists({required String email}) async {
    final getLeaders = await firestore
        .collection('leaders')
        .where('email', isEqualTo: email)
        .get();
    if (getLeaders.docs.isEmpty) return null;
    return LeaderModel.fromSnapShot(getLeaders.docs.first);
  }

  Future<UserCredential> _createUserAuth(
      {required String email, required String password}) {
    return firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> _saveUser({required UserModel user}) {
    return firestore.collection('users').doc(user.id).set(user.toMap());
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
