import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_umadim_app/app/data/models/function_model.dart';

class UserModel {
  String id;
  String name;
  String email;
  String? password;
  FunctionModel umadimFunction;
  FunctionModel localFunction;
  DateTime? birthDate;
  String gender;
  String? photoUrl;
  String? phoneNumber;
  String congregation;
  DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.password,
    required this.umadimFunction,
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
      'password': '',
      'umadimFunction': umadimFunction.toMap(),
      'localFunction': localFunction.toMap(),
      'birthDate': birthDate != null ? Timestamp.fromDate(birthDate!) : null,
      'gender': gender,
      'congregation': congregation,
      'photoUrl': photoUrl,
      'phoneNumber': phoneNumber,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory UserModel.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return UserModel(
      id: snapshot['id'] as String,
      name: snapshot['name'] as String,
      email: snapshot['email'] as String,
      password:
          snapshot['password'] != null ? snapshot['password'] as String : null,
      umadimFunction: FunctionModel.fromMap(
        snapshot['umadimFunction'] as Map<String, dynamic>,
      ),
      localFunction: FunctionModel.fromMap(
        snapshot['localFunction'] as Map<String, dynamic>,
      ),
      birthDate: snapshot['birthDate'] != null
          ? (snapshot['birthDate'] as Timestamp).toDate().toLocal()
          : null,
      gender: snapshot['gender'] as String,
      congregation: snapshot['congregation'] as String,
      photoUrl:
          snapshot['photoUrl'] != null ? snapshot['photoUrl'] as String : null,
      phoneNumber: snapshot['phoneNumber'] != null
          ? snapshot['phoneNumber'] as String
          : null,
      createdAt: (snapshot['createdAt'] as Timestamp).toDate().toLocal(),
    );
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    FunctionModel? umadimFunction,
    FunctionModel? localFunction,
    DateTime? birthDate,
    String? gender,
    String? photoUrl,
    String? phoneNumber,
    String? congregation,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      umadimFunction: umadimFunction ?? this.umadimFunction,
      localFunction: localFunction ?? this.localFunction,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      photoUrl: photoUrl ?? this.photoUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      congregation: congregation ?? this.congregation,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
