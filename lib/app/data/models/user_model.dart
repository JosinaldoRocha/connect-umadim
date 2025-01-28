import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String name;
  String email;
  String password;
  String? umadimFunction;
  String localFunction;
  String? birthDate;
  String gender;
  String? photoUrl;
  String? phoneNumber;
  String congregation;
  DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    this.umadimFunction,
    required this.localFunction,
    this.birthDate,
    required this.gender,
    required this.congregation,
    this.photoUrl,
    this.phoneNumber,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      //'password': password,
      'umadimFunction': umadimFunction,
      'localFunction': localFunction,

      'birthDate': birthDate,
      'gender': gender,
      'congregation': congregation,
      'photoUrl': photoUrl,
      'phoneNumber': phoneNumber,
      'createdAt': createdAt,
    };
  }

  factory UserModel.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return UserModel(
      id: snapshot['id'] as String,
      name: snapshot['name'] as String,
      email: snapshot['email'] as String,
      password: snapshot['password'] as String,
      umadimFunction: snapshot['umadimFunction'] != null
          ? snapshot['umadimFunction'] as String
          : null,
      localFunction: snapshot['localFunction'] as String,
      birthDate: snapshot['birthDate'] != null
          ? snapshot['birthDate'] as String
          : null,
      gender: snapshot['gender'] as String,
      congregation: snapshot['congregation'] as String,
      photoUrl:
          snapshot['photoUrl'] != null ? snapshot['photoUrl'] as String : null,
      phoneNumber: snapshot['phoneNumber'] != null
          ? snapshot['phoneNumber'] as String
          : null,
      createdAt: (snapshot['createdAt'] as Timestamp).toDate(),
    );
  }
}
