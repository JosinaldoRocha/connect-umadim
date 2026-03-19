import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo de comentário — subcoleção /posts/{postId}/comments/{commentId}
class CommentModel {
  final String id;
  final String postId;
  final String authorId;
  final String authorName;
  final String? authorPhotoUrl;
  final String content;
  final List<String> likeIds;
  final String? replyToId; // ID do comentário pai (se for reply)
  final String? replyToName; // Nome do autor do comentário pai
  final DateTime createdAt;

  const CommentModel({
    required this.id,
    required this.postId,
    required this.authorId,
    required this.authorName,
    this.authorPhotoUrl,
    required this.content,
    required this.likeIds,
    this.replyToId,
    this.replyToName,
    required this.createdAt,
  });

  bool isLikedBy(String uid) => likeIds.contains(uid);
  bool get isReply => replyToId != null;

  Map<String, dynamic> toMap() => {
        'id': id,
        'postId': postId,
        'authorId': authorId,
        'authorName': authorName,
        'authorPhotoUrl': authorPhotoUrl,
        'content': content,
        'likeIds': likeIds,
        'replyToId': replyToId,
        'replyToName': replyToName,
        'createdAt': Timestamp.fromDate(createdAt),
      };

  factory CommentModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snap,
  ) {
    final d = snap.data()!;
    return CommentModel(
      id: d['id'] as String,
      postId: d['postId'] as String,
      authorId: d['authorId'] as String,
      authorName: d['authorName'] as String,
      authorPhotoUrl: d['authorPhotoUrl'] as String?,
      content: d['content'] as String,
      likeIds: List<String>.from(d['likeIds'] ?? []),
      replyToId: d['replyToId'] as String?,
      replyToName: d['replyToName'] as String?,
      createdAt: (d['createdAt'] as Timestamp).toDate().toLocal(),
    );
  }

  factory CommentModel.fromQuerySnapshot(
    QueryDocumentSnapshot<Map<String, dynamic>> snap,
  ) {
    final d = snap.data();
    return CommentModel(
      id: d['id'] as String,
      postId: d['postId'] as String,
      authorId: d['authorId'] as String,
      authorName: d['authorName'] as String,
      authorPhotoUrl: d['authorPhotoUrl'] as String?,
      content: d['content'] as String,
      likeIds: List<String>.from(d['likeIds'] ?? []),
      replyToId: d['replyToId'] as String?,
      replyToName: d['replyToName'] as String?,
      createdAt: (d['createdAt'] as Timestamp).toDate().toLocal(),
    );
  }
}
