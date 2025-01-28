import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderModel {
  String id;
  String name;
  String email;
  bool isRegistered;
  LeaderModel({
    required this.id,
    required this.name,
    required this.email,
    required this.isRegistered,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'isRegistered': isRegistered,
    };
  }

  factory LeaderModel.fromSnapShot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapShot) {
    return LeaderModel(
      id: snapShot['id'] as String,
      name: snapShot['name'] as String,
      email: snapShot['email'] as String,
      isRegistered: snapShot['isRegistered'] as bool,
    );
  }
}
