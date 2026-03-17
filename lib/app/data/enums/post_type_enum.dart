enum PostType {
  message,
  photo,
  video,
  poll,
  event,
  notice;

  String get text => switch (this) {
        PostType.message => 'message',
        PostType.photo => 'photo',
        PostType.video => 'video',
        PostType.poll => 'poll',
        PostType.event => 'event',
        PostType.notice => 'notice',
      };

  String get label => switch (this) {
        PostType.message => 'Mensagem',
        PostType.photo => 'Foto',
        PostType.video => 'Vídeo',
        PostType.poll => 'Enquete',
        PostType.event => 'Evento',
        PostType.notice => 'Aviso',
      };

  static PostType fromString(String value) => PostType.values.firstWhere(
        (e) => e.text == value,
        orElse: () => PostType.message,
      );

  /// Tipos que só líderes podem criar
  bool get leaderOnly =>
      this == PostType.notice ||
      this == PostType.event ||
      this == PostType.poll;
}
