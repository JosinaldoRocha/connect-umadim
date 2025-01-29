import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/helpers/errors/errors.dart';
import '../models/user_model.dart';

class UserDataSource {
  final _firestore = FirebaseFirestore.instance;
  final authUser = FirebaseAuth.instance.currentUser;

  Future<Either<CommonError, bool>> completeProfile({
    required UserModel user,
  }) async {
    try {
      // user.photoUrl = await updateUserImage(user);

      await _firestore.collection('users').doc(authUser!.uid).set(user.toMap());

      //await authUser!.updatePhotoURL(user.photoUrl);

      await authUser!.updateDisplayName(user.name);
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

  // Future<String?> updateUserImage(UserModel user) async {
  //   String? image;
  //   if (user.photoUrl != null && user.photoUrl!.isNotEmpty) {
  //     if (!user.photoUrl!.contains(user.id)) {
  //       final storageRef = FirebaseStorage.instance
  //           .ref()
  //           .child('users')
  //           .child(user.id)
  //           .child('uploads')
  //           .child('${user.id}.png');
  //       final uploadTask = storageRef.putFile(File(user.photoUrl!));
  //       final TaskSnapshot downloadUrl = (await uploadTask);
  //       final String imageUrl = await downloadUrl.ref.getDownloadURL();

  //       image = imageUrl;
  //     } else {
  //       image = user.photoUrl;
  //     }
  //   }
  //   return image;
  // }
}
