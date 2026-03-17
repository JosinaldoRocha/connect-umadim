import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/auth/auth_permission_service.dart';
import '../../../core/helpers/helpers.dart';
import '../../../data/data_source/story_data_source.dart';
import '../../../data/models/story_model.dart';

// ── Provider de instância do datasource ────────────────────────

final storyDataSourceProvider = Provider<StoryDataSource>((ref) {
  return StoryDataSource(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    supabase: Supabase.instance.client,
  );
});

// ── Stream de stories ativos ────────────────────────────────────
// Só consulta o Firestore quando o usuário estiver autenticado
final storiesProvider = StreamProvider<List<StoryGroup>>((ref) {
  final authState = ref.watch(authStateChangesProvider);
  final ds = ref.read(storyDataSourceProvider);

  return authState.when(
    data: (user) {
      if (user == null) return Stream.value(<StoryGroup>[]);
      return ds.watchActiveStories().map(
            (result) => result.fold(
              (err) => throw Exception(err.message),
              (groups) => groups,
            ),
          );
    },
    loading: () => Stream.value(<StoryGroup>[]),
    error: (_, __) => Stream.value(<StoryGroup>[]),
  );
});

// ── Criar story ────────────────────────────────────────────────

typedef CreateStoryState = CommonState<CommonError, StoryModel>;

class CreateStoryNotifier extends StateNotifier<CreateStoryState> {
  final StoryDataSource _ds;
  CreateStoryNotifier(this._ds) : super(const CreateStoryState.initial());

  Future<void> create({
    required File mediaFile,
    required String mediaType,
    required String congregation,
    required String areaId,
    String? caption,
  }) async {
    state = const CreateStoryState.loadInProgress();
    final result = await _ds.createStory(
      mediaFile: mediaFile,
      mediaType: mediaType,
      congregation: congregation,
      areaId: areaId,
      caption: caption,
    );
    result.fold(
      (err) => state = CreateStoryState.loadFailure(err),
      (story) => state = CreateStoryState.loadSuccess(story),
    );
  }

  void reset() => state = const CreateStoryState.initial();
}

final createStoryProvider =
    StateNotifierProvider<CreateStoryNotifier, CreateStoryState>(
  (ref) => CreateStoryNotifier(ref.read(storyDataSourceProvider)),
);

// ── Marcar story como visto ──────────────────────────────────────

final markStoryViewedProvider =
    FutureProvider.family<void, String>((ref, storyId) async {
  final ds = ref.read(storyDataSourceProvider);
  await ds.markAsViewed(storyId);
});
