import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/auth/auth_permission_service.dart';
import '../../../core/helpers/helpers.dart';
import '../../../data/data_source/post_data_source.dart';
import '../../../data/enums/post_type_enum.dart';
import '../../../data/models/post_model.dart';

// ── Provider de instância do datasource ─────────────────────────

final postDataSourceProvider = Provider<PostDataSource>((ref) {
  return PostDataSource(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    supabase: Supabase.instance.client,
  );
});

// ── Stream do feed ────────────────────────────────────────────
// Só consulta o Firestore quando o usuário estiver autenticado
// (evita permission-denied por race condition no carregamento do auth)
final feedProvider = StreamProvider<List<PostModel>>((ref) {
  final authState = ref.watch(authStateChangesProvider);
  final ds = ref.read(postDataSourceProvider);

  return authState.when(
    data: (user) {
      if (user == null) return Stream.value(<PostModel>[]);
      return ds.watchFeed().map(
            (result) => result.fold(
              (err) => throw Exception(err.message),
              (posts) => posts,
            ),
          );
    },
    loading: () => Stream.value(<PostModel>[]),
    error: (_, __) => Stream.value(<PostModel>[]),
  );
});

// ── Criar post ────────────────────────────────────────────────
typedef CreatePostState = CommonState<CommonError, PostModel>;

class CreatePostNotifier extends StateNotifier<CreatePostState> {
  final PostDataSource _ds;
  CreatePostNotifier(this._ds) : super(const CreatePostState.initial());

  Future<void> create({
    required PostType type,
    required String content,
    required String congregation,
    required String areaId,
    File? mediaFile,
    List<String>? pollOptionTexts,
    DateTime? pollEndsAt,
  }) async {
    state = const CreatePostState.loadInProgress();
    final result = await _ds.createPost(
      type: type,
      content: content,
      congregation: congregation,
      areaId: areaId,
      mediaFile: mediaFile,
      pollOptionTexts: pollOptionTexts,
      pollEndsAt: pollEndsAt,
    );
    result.fold(
      (err) => state = CreatePostState.loadFailure(err),
      (post) => state = CreatePostState.loadSuccess(post),
    );
  }

  void reset() => state = const CreatePostState.initial();
}

final createPostProvider =
    StateNotifierProvider<CreatePostNotifier, CreatePostState>(
  (ref) => CreatePostNotifier(ref.read(postDataSourceProvider)),
);

// ── Curtir post ───────────────────────────────────────────────
final toggleLikeProvider =
    FutureProvider.family<void, String>((ref, postId) async {
  final ds = ref.read(postDataSourceProvider);
  await ds.toggleLike(postId);
});

// ── Confirmar presença ────────────────────────────────────────
final togglePresenceProvider =
    FutureProvider.family<void, String>((ref, postId) async {
  final ds = ref.read(postDataSourceProvider);
  await ds.togglePresence(postId);
});

// ── Votar em enquete ──────────────────────────────────────────
class VotePollArgs {
  final String postId;
  final String optionId;
  const VotePollArgs({required this.postId, required this.optionId});
}

final votePollProvider =
    FutureProvider.family<void, VotePollArgs>((ref, args) async {
  final ds = ref.read(postDataSourceProvider);
  await ds.votePoll(postId: args.postId, optionId: args.optionId);
});

// ── Deletar post ──────────────────────────────────────────────
final deletePostProvider =
    FutureProvider.family<void, String>((ref, postId) async {
  final ds = ref.read(postDataSourceProvider);
  await ds.deletePost(postId);
});

// ── Fixar post ────────────────────────────────────────────────
final togglePinProvider =
    FutureProvider.family<void, String>((ref, postId) async {
  final ds = ref.read(postDataSourceProvider);
  await ds.togglePin(postId);
});
