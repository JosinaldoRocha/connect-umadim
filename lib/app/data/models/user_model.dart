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
  String areaId; // ← novo: identifica a área (area1, area2, etc.)
  bool? isApproved; // ← novo: aprovado por um líder?
  String? approvedBy; // ← novo: uid do líder que aprovou
  DateTime? approvedAt; // ← novo: quando foi aprovado
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
    this.areaId = '',
    this.isApproved,
    this.approvedBy,
    this.approvedAt,
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
      'areaId': areaId,
      'isApproved': isApproved ?? false,
      'approvedBy': approvedBy,
      'approvedAt': approvedAt != null ? Timestamp.fromDate(approvedAt!) : null,
      'photoUrl': photoUrl,
      'phoneNumber': phoneNumber,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory UserModel.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data() ?? {};
    return UserModel(
      id: data['id'] as String,
      name: data['name'] as String,
      email: data['email'] as String,
      password: data['password'] as String?,
      umadimFunction: FunctionModel.fromMap(
        data['umadimFunction'] as Map<String, dynamic>,
      ),
      localFunction: FunctionModel.fromMap(
        data['localFunction'] as Map<String, dynamic>,
      ),
      birthDate: data['birthDate'] != null
          ? (data['birthDate'] as Timestamp).toDate().toLocal()
          : null,
      gender: data['gender'] as String? ?? '',
      congregation: data['congregation'] as String? ?? '',
      areaId: (data['areaId'] as String?) ?? '',
      isApproved: data['isApproved'] as bool?,
      approvedBy: data['approvedBy'] as String?,
      approvedAt: data['approvedAt'] != null
          ? (data['approvedAt'] as Timestamp).toDate().toLocal()
          : null,
      photoUrl: data['photoUrl'] as String?,
      phoneNumber: data['phoneNumber'] as String?,
      createdAt: (data['createdAt'] as Timestamp).toDate().toLocal(),
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
    String? areaId,
    bool? isApproved,
    String? approvedBy,
    DateTime? approvedAt,
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
      areaId: areaId ?? this.areaId,
      isApproved: isApproved ?? this.isApproved,
      approvedBy: approvedBy ?? this.approvedBy,
      approvedAt: approvedAt ?? this.approvedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
