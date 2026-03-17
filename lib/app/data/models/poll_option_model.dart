/// Opção individual de uma enquete
class PollOptionModel {
  final String id;
  final String text;
  final List<String> voterIds; // UIDs dos votantes

  const PollOptionModel({
    required this.id,
    required this.text,
    required this.voterIds,
  });

  int get voteCount => voterIds.length;

  double votePercentage(int totalVotes) =>
      totalVotes == 0 ? 0 : (voteCount / totalVotes) * 100;

  Map<String, dynamic> toMap() => {
        'id': id,
        'text': text,
        'voterIds': voterIds,
      };

  factory PollOptionModel.fromMap(Map<String, dynamic> map) => PollOptionModel(
        id: map['id'] as String,
        text: map['text'] as String,
        voterIds: List<String>.from(map['voterIds'] ?? []),
      );

  PollOptionModel copyWith({
    String? id,
    String? text,
    List<String>? voterIds,
  }) =>
      PollOptionModel(
        id: id ?? this.id,
        text: text ?? this.text,
        voterIds: voterIds ?? this.voterIds,
      );
}
