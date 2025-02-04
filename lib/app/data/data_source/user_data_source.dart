import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/helpers/errors/errors.dart';
import '../models/user_model.dart';

class UserDataSource {
  final firestore = FirebaseFirestore.instance;
  final supabase = Supabase.instance.client;

  Future<Either<CommonError, List<UserModel>>> getAllUsers() async {
    try {
      final getDocuments = await firestore.collection('users').get();
      final documents = getDocuments.docs;
      List<UserModel> users = [];

      for (var docs in documents) {
        final user = UserModel.fromSnapShot(docs);
        users.add(user);
      }

      return Right(users);
    } on Exception catch (e) {
      return Left(GenerateError.fromException(e));
    }
  }

  Future<Either<CommonError, bool>> completeProfile(
    UserModel user,
    Uint8List? imageBytes,
  ) async {
    final authUser = FirebaseAuth.instance.currentUser;

    try {
      user.photoUrl = await completeProfileImage(user, imageBytes);

      await authUser!.updatePhotoURL(user.photoUrl);

      await authUser.updateDisplayName(user.name);

      await firestore.collection('users').doc(authUser.uid).set(user.toMap());

      return Right(true);
    } on Exception catch (e) {
      return Left(GenerateError.fromException(e));
    }
  }

  Future<Either<CommonError, UserModel>> getLocalUser() async {
    final authUser = FirebaseAuth.instance.currentUser;
    try {
      final getDocument =
          await firestore.collection('users').doc(authUser!.uid).get();

      final user = UserModel.fromSnapShot(getDocument);

      return Right(user);
    } on Exception catch (e) {
      return Left(GenerateError.fromException(e));
    }
  }

  Future<String?> completeProfileImage(
    UserModel user,
    Uint8List? imageBytes,
  ) async {
    if ((user.photoUrl?.isEmpty ?? true) && imageBytes == null) return null;

    final fileName = 'user_profile_images/connect-umadim${user.id}.jpg';
    final storage = supabase.storage.from('user_profile_images');

    if (kIsWeb) {
      await storage.uploadBinary(
        fileName,
        imageBytes!,
        fileOptions: const FileOptions(contentType: 'image/jpeg'),
      );
    } else {
      await storage.upload(fileName, File(user.photoUrl!));
    }

    return storage.getPublicUrl(fileName);
  }
}
