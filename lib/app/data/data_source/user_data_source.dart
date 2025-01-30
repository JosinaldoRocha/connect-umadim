import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/helpers/errors/errors.dart';
import '../models/user_model.dart';

class UserDataSource {
  final _firestore = FirebaseFirestore.instance;
  final authUser = FirebaseAuth.instance.currentUser;
  final supabase = Supabase.instance.client;

  Future<Either<CommonError, bool>> completeProfile({
    required UserModel user,
  }) async {
    try {
      user.photoUrl = await completeProfileImage(user);

      await authUser!.updatePhotoURL(user.photoUrl);

      await authUser!.updateDisplayName(user.name);

      await _firestore.collection('users').doc(authUser!.uid).set(user.toMap());

      return Right(true);
    } on Exception catch (e) {
      return Left(GenerateError.fromException(e));
    }
  }

  Future<Either<CommonError, UserModel>> getLocalUser() async {
    try {
      final getDocument =
          await _firestore.collection('users').doc(authUser!.uid).get();

      final user = UserModel.fromSnapShot(getDocument);

      return Right(user);
    } on Exception catch (e) {
      return Left(GenerateError.fromException(e));
    }
  }

  Future<String?> completeProfileImage(UserModel user) async {
    if (user.photoUrl != null && user.photoUrl!.isNotEmpty) {
      final fileName = 'user_profile_images/${user.id}.jpg';

      await supabase.storage.from('user_profile_images').upload(
            fileName,
            File(user.photoUrl!),
          );

      return supabase.storage
          .from('user_profile_images')
          .getPublicUrl(fileName);
    }
    return null;
  }
}
