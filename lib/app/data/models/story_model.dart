import 'package:cloud_firestore/cloud_firestore.dart';

/// Story de 24 horas de qualquer jovem
///
/// Estrutura no Firestore:
/// /stories/{storyId}
///   - id, authorId, authorName, authorPhotoUrl
///   - congregation, areaId
///   - mediaUrl (obrigatório — imagem ou vídeo curto)
///   - mediaType: 'image' | 'video'
///   - caption: texto opcional sobre a mídia
///   - viewerIds: [uid, ...]   — quem já visualizou
///   - expiresAt: Timestamp    — createdAt + 24h
///   - createdAt: Timestamp
class StoryModel {
  final String id;
  final String authorId;
  final String authorName;
  final String? authorPhotoUrl;
  final String congregation;
  final String areaId;
  final String mediaUrl;
  final String mediaType; // 'image' | 'video'
  final String? caption;
  final List<String> viewerIds;
  final DateTime expiresAt;
  final DateTime createdAt;

  const StoryModel({
    required this.id,
    required this.authorId,
    required this.authorName,
    this.authorPhotoUrl,
    required this.congregation,
    required this.areaId,
    required this.mediaUrl,
    required this.mediaType,
    this.caption,
    required this.viewerIds,
    required this.expiresAt,
    required this.createdAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  bool isViewedBy(String uid) => viewerIds.contains(uid);
  bool get isVideo => mediaType == 'video';

  Map<String, dynamic> toMap() => {
        'id': id,
        'authorId': authorId,
        'authorName': authorName,
        'authorPhotoUrl': authorPhotoUrl,
        'congregation': congregation,
        'areaId': areaId,
        'mediaUrl': mediaUrl,
        'mediaType': mediaType,
        'caption': caption,
        'viewerIds': viewerIds,
        'expiresAt': Timestamp.fromDate(expiresAt),
        'createdAt': Timestamp.fromDate(createdAt),
      };

  factory StoryModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? {};
    return StoryModel(
      id: data['id'] as String,
      authorId: data['authorId'] as String,
      authorName: data['authorName'] as String,
      authorPhotoUrl: data['authorPhotoUrl'] as String?,
      congregation: data['congregation'] as String,
      areaId: (data['areaId'] as String?) ?? '',
      mediaUrl: data['mediaUrl'] as String,
      mediaType: data['mediaType'] as String,
      caption: data['caption'] as String?,
      viewerIds: List<String>.from(data['viewerIds'] ?? []),
      expiresAt: (data['expiresAt'] as Timestamp).toDate().toLocal(),
      createdAt: (data['createdAt'] as Timestamp).toDate().toLocal(),
    );
  }

  factory StoryModel.fromQuerySnapshot(
    QueryDocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    return StoryModel(
      id: data['id'] as String,
      authorId: data['authorId'] as String,
      authorName: data['authorName'] as String,
      authorPhotoUrl: data['authorPhotoUrl'] as String?,
      congregation: data['congregation'] as String,
      areaId: (data['areaId'] as String?) ?? '',
      mediaUrl: data['mediaUrl'] as String,
      mediaType: data['mediaType'] as String,
      caption: data['caption'] as String?,
      viewerIds: List<String>.from(data['viewerIds'] ?? []),
      expiresAt: (data['expiresAt'] as Timestamp).toDate().toLocal(),
      createdAt: (data['createdAt'] as Timestamp).toDate().toLocal(),
    );
  }
}

/// Agrupamento de stories por autor (para o row horizontal)
class StoryGroup {
  final String authorId;
  final String authorName;
  final String? authorPhotoUrl;
  final String congregation;
  final List<StoryModel> stories;

  const StoryGroup({
    required this.authorId,
    required this.authorName,
    this.authorPhotoUrl,
    required this.congregation,
    required this.stories,
  });

  /// Retorna true se o uid já viu TODOS os stories do grupo
  bool isAllSeenBy(String uid) => stories.every((s) => s.isViewedBy(uid));

  StoryModel get latest => stories.reduce(
        (a, b) => a.createdAt.isAfter(b.createdAt) ? a : b,
      );
}
