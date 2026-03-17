import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_umadim_app/app/data/enums/funciton_type_enum.dart';
import 'package:connect_umadim_app/app/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ── Enum de roles ─────────────────────────────────────────────

enum UserRole {
  member,
  leader,
  areaLeader,
  umadimLeader;

  static UserRole fromUser(UserModel user) {
    final umadim = user.umadimFunction.title;
    final local = user.localFunction.title;

    if (umadim == FunctionType.umadimLeader ||
        local == FunctionType.umadimLeader) {
      return UserRole.umadimLeader;
    }
    if (umadim == FunctionType.areaLeader || local == FunctionType.areaLeader) {
      return UserRole.areaLeader;
    }
    if (umadim != FunctionType.member || local != FunctionType.member) {
      return UserRole.leader;
    }
    return UserRole.member;
  }

  bool get isLeader =>
      this == leader || this == areaLeader || this == umadimLeader;

  bool get isAreaLeader => this == areaLeader || this == umadimLeader;

  bool get isUmadimLeader => this == umadimLeader;

  String get label => switch (this) {
        UserRole.member => 'Membro',
        UserRole.leader => 'Líder',
        UserRole.areaLeader => 'Líder de Área',
        UserRole.umadimLeader => 'Líder UMADIM',
      };
}

// ── Serviço de permissões ─────────────────────────────────────
// Sem Cloud Functions — lê o documento do usuário no Firestore
// e expõe helpers de permissão para uso nos widgets e providers.

class AuthPermissionService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthPermissionService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  String? get currentUid => _auth.currentUser?.uid;

  // ── Busca dados do usuário atual ──────────────────────────────
  Future<UserModel?> getCurrentUser() async {
    final uid = currentUid;
    if (uid == null) return null;

    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return null;

    return UserModel.fromSnapShot(doc);
  }

  // ── Aprovar jovem — escrita direta no Firestore ───────────────
  // (sem Cloud Function — o líder atualiza isApproved diretamente)
  Future<void> approveUser(String targetUid) async {
    await _firestore.collection('users').doc(targetUid).update({
      'isApproved': true,
      'approvedBy': currentUid,
      'approvedAt': FieldValue.serverTimestamp(),
    });
  }

  // ── Revogar acesso ────────────────────────────────────────────
  Future<void> revokeUser(String targetUid) async {
    await _firestore.collection('users').doc(targetUid).update({
      'isApproved': false,
      'revokedBy': currentUid,
      'revokedAt': FieldValue.serverTimestamp(),
    });
  }

  // ── Promover usuário a líder ──────────────────────────────────
  // Só atualiza o documento — as Rules do Firestore validam
  // se o chamador tem permissão para fazer isso
  Future<void> promoteToLeader({
    required String targetUid,
    required FunctionType umadimFunction,
    required FunctionType localFunction,
    required String congregation,
    required String areaId,
  }) async {
    await _firestore.collection('users').doc(targetUid).update({
      'umadimFunction': {
        'title': umadimFunction.text,
        'department': 'umadim',
      },
      'localFunction': {
        'title': localFunction.text,
        'department': congregation,
      },
      'congregation': congregation,
      'areaId': areaId,
    });
  }
}

// ── Auth state (evita permission-denied antes do auth carregar) ─
final authStateChangesProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// ── Providers ─────────────────────────────────────────────────

final authPermissionServiceProvider = Provider<AuthPermissionService>(
  (_) => AuthPermissionService(),
);

// Stream do documento do usuário atual (atualização em tempo real)
final currentUserStreamProvider = StreamProvider<UserModel?>((ref) {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return Stream.value(null);

  return FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .snapshots()
      .map((snap) => snap.exists ? UserModel.fromSnapShot(snap) : null);
});

// Role derivado do stream — atualiza automaticamente
final currentRoleProvider = Provider<UserRole>((ref) {
  final userAsync = ref.watch(currentUserStreamProvider);
  return userAsync.maybeWhen(
    data: (user) => user != null ? UserRole.fromUser(user) : UserRole.member,
    orElse: () => UserRole.member,
  );
});

// Helpers booleanos para usar diretamente nos widgets
final isLeaderProvider = Provider<bool>(
  (ref) => ref.watch(currentRoleProvider).isLeader,
);

final isAreaLeaderProvider = Provider<bool>(
  (ref) => ref.watch(currentRoleProvider).isAreaLeader,
);

final isUmadimLeaderProvider = Provider<bool>(
  (ref) => ref.watch(currentRoleProvider).isUmadimLeader,
);

// isApproved — verifica se o jovem foi aprovado por um líder
final isApprovedProvider = Provider<bool>((ref) {
  final userAsync = ref.watch(currentUserStreamProvider);
  return userAsync.maybeWhen(
    data: (user) => user != null && (user.isApproved ?? false),
    orElse: () => false,
  );
});
