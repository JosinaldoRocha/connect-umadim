import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_umadim_app/app/data/enums/post_type_enum.dart';
import 'package:connect_umadim_app/app/data/models/poll_option_model.dart';

/// Modelo central do feed do Conecta UMADIM
///
/// Estrutura no Firestore:
/// /posts/{postId}
///   - id, authorId, authorName, authorPhotoUrl
///   - congregation, areaId
///   - type, content
///   - mediaUrl (foto ou vídeo — uma por post)
///   - mediaType: 'image' | 'video' | null
///   - likeIds: [uid, uid, ...]       — curtidas
///   - commentCount: int               — contador (subcoleção /comments)
///   - pollOptions: [...]              — só para type == poll
///   - pollEndsAt: Timestamp?          — expiração da enquete
///   - presenceIds: [uid, ...]         — confirmações para eventos
///   - isPinned: bool                  — post fixado pelo líder
///   - createdAt: Timestamp
class PostModel {
  final String id;
  final String authorId;
  final String authorName;
  final String? authorPhotoUrl;
  final String congregation;
  final String areaId;
  final PostType type;
  final String content;
  final String? mediaUrl;
  final String? mediaType; // 'image' | 'video'
  final List<String> likeIds;
  final int commentCount;
  final List<PollOptionModel> pollOptions;
  final DateTime? pollEndsAt;
  final List<String> presenceIds;
  final bool isPinned;
  final DateTime createdAt;

  const PostModel({
    required this.id,
    required this.authorId,
    required this.authorName,
    this.authorPhotoUrl,
    required this.congregation,
    required this.areaId,
    required this.type,
    required this.content,
    this.mediaUrl,
    this.mediaType,
    required this.likeIds,
    required this.commentCount,
    required this.pollOptions,
    this.pollEndsAt,
    required this.presenceIds,
    required this.isPinned,
    required this.createdAt,
  });

  // ── Helpers ──────────────────────────────────────────────────

  bool isLikedBy(String uid) => likeIds.contains(uid);
  bool hasConfirmedPresence(String uid) => presenceIds.contains(uid);
  bool get hasPollEnded =>
      pollEndsAt != null && DateTime.now().isAfter(pollEndsAt!);
  int get totalVotes => pollOptions.fold(0, (sum, o) => sum + o.voteCount);
  bool get hasMedia => mediaUrl != null && mediaUrl!.isNotEmpty;
  bool get isVideo => mediaType == 'video';
  bool get isImage => mediaType == 'image';

  // ── Serialização ─────────────────────────────────────────────

  Map<String, dynamic> toMap() => {
        'id': id,
        'authorId': authorId,
        'authorName': authorName,
        'authorPhotoUrl': authorPhotoUrl,
        'congregation': congregation,
        'areaId': areaId,
        'type': type.text,
        'content': content,
        'mediaUrl': mediaUrl,
        'mediaType': mediaType,
        'likeIds': likeIds,
        'commentCount': commentCount,
        'pollOptions': pollOptions.map((o) => o.toMap()).toList(),
        'pollEndsAt':
            pollEndsAt != null ? Timestamp.fromDate(pollEndsAt!) : null,
        'presenceIds': presenceIds,
        'isPinned': isPinned,
        'createdAt': Timestamp.fromDate(createdAt),
      };

  factory PostModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? {};
    return PostModel(
      id: data['id'] as String,
      authorId: data['authorId'] as String,
      authorName: data['authorName'] as String,
      authorPhotoUrl: data['authorPhotoUrl'] as String?,
      congregation: data['congregation'] as String,
      areaId: (data['areaId'] as String?) ?? '',
      type: PostType.fromString(data['type'] as String),
      content: data['content'] as String,
      mediaUrl: data['mediaUrl'] as String?,
      mediaType: data['mediaType'] as String?,
      likeIds: List<String>.from(data['likeIds'] ?? []),
      commentCount: (data['commentCount'] as int?) ?? 0,
      pollOptions: (data['pollOptions'] as List<dynamic>? ?? [])
          .map((o) => PollOptionModel.fromMap(o as Map<String, dynamic>))
          .toList(),
      pollEndsAt: data['pollEndsAt'] != null
          ? (data['pollEndsAt'] as Timestamp).toDate().toLocal()
          : null,
      presenceIds: List<String>.from(data['presenceIds'] ?? []),
      isPinned: (data['isPinned'] as bool?) ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate().toLocal(),
    );
  }

  factory PostModel.fromMap(Map<String, dynamic> data) => PostModel(
        id: data['id'] as String,
        authorId: data['authorId'] as String,
        authorName: data['authorName'] as String,
        authorPhotoUrl: data['authorPhotoUrl'] as String?,
        congregation: data['congregation'] as String,
        areaId: (data['areaId'] as String?) ?? '',
        type: PostType.fromString(data['type'] as String),
        content: data['content'] as String,
        mediaUrl: data['mediaUrl'] as String?,
        mediaType: data['mediaType'] as String?,
        likeIds: List<String>.from(data['likeIds'] ?? []),
        commentCount: (data['commentCount'] as int?) ?? 0,
        pollOptions: (data['pollOptions'] as List<dynamic>? ?? [])
            .map((o) => PollOptionModel.fromMap(o as Map<String, dynamic>))
            .toList(),
        pollEndsAt: data['pollEndsAt'] != null
            ? (data['pollEndsAt'] as Timestamp).toDate().toLocal()
            : null,
        presenceIds: List<String>.from(data['presenceIds'] ?? []),
        isPinned: (data['isPinned'] as bool?) ?? false,
        createdAt: (data['createdAt'] as Timestamp).toDate().toLocal(),
      );

  PostModel copyWith({
    String? id,
    String? authorId,
    String? authorName,
    String? authorPhotoUrl,
    String? congregation,
    String? areaId,
    PostType? type,
    String? content,
    String? mediaUrl,
    String? mediaType,
    List<String>? likeIds,
    int? commentCount,
    List<PollOptionModel>? pollOptions,
    DateTime? pollEndsAt,
    List<String>? presenceIds,
    bool? isPinned,
    DateTime? createdAt,
  }) =>
      PostModel(
        id: id ?? this.id,
        authorId: authorId ?? this.authorId,
        authorName: authorName ?? this.authorName,
        authorPhotoUrl: authorPhotoUrl ?? this.authorPhotoUrl,
        congregation: congregation ?? this.congregation,
        areaId: areaId ?? this.areaId,
        type: type ?? this.type,
        content: content ?? this.content,
        mediaUrl: mediaUrl ?? this.mediaUrl,
        mediaType: mediaType ?? this.mediaType,
        likeIds: likeIds ?? this.likeIds,
        commentCount: commentCount ?? this.commentCount,
        pollOptions: pollOptions ?? this.pollOptions,
        pollEndsAt: pollEndsAt ?? this.pollEndsAt,
        presenceIds: presenceIds ?? this.presenceIds,
        isPinned: isPinned ?? this.isPinned,
        createdAt: createdAt ?? this.createdAt,
      );
}
