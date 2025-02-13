import 'package:cloud_firestore/cloud_firestore.dart';

class VerseModel {
  String text;
  String reference;

  VerseModel({
    required this.text,
    required this.reference,
  });

  factory VerseModel.fromSnapShot(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    return VerseModel(
      text: snapshot['text'] as String,
      reference: snapshot['reference'] as String,
    );
  }
}
