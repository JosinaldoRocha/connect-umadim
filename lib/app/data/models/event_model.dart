// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:connect_umadim_app/app/data/enums/department_enum.dart';
import 'package:connect_umadim_app/app/data/enums/event_status_enum.dart';
import 'package:connect_umadim_app/app/data/enums/event_type_enum.dart';

class EventModel {
  String id;
  String userId;
  String title;
  EventType type;
  EventStatus status;
  String? imageUrl;
  String eventLocation;
  DateTime? eventDate;
  DateTime eventTime;
  Department promotedBy;
  String? description;
  String? theme;
  String? singer;
  String? minister;
  List<String> confirmedPresences;
  DateTime createdAt;

  EventModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.type,
    required this.status,
    this.imageUrl,
    required this.eventLocation,
    this.eventDate,
    required this.eventTime,
    required this.promotedBy,
    this.description,
    this.theme,
    this.singer,
    this.minister,
    required this.confirmedPresences,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'title': title,
      'type': type.text,
      'status': status.text,
      'imageUrl': imageUrl,
      'eventLocation': eventLocation,
      'eventDate': eventDate != null ? Timestamp.fromDate(eventDate!) : null,
      'eventTime': Timestamp.fromDate(eventTime),
      'promotedBy': promotedBy.text,
      'description': description,
      'theme': theme,
      'singer': singer,
      'minister': minister,
      'confirmedPresences': confirmedPresences,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory EventModel.fromSnapShot(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    return EventModel(
      id: snapshot['id'] as String,
      userId: snapshot['userId'] as String,
      title: snapshot['title'] as String,
      type: EventType.fromString(snapshot['type'] as String),
      status: EventStatus.fromString(snapshot['status'] as String),
      imageUrl:
          snapshot['imageUrl'] != null ? snapshot['imageUrl'] as String : null,
      eventLocation: snapshot['eventLocation'] as String,
      eventDate: snapshot['eventDate'] != null
          ? (snapshot['eventDate'] as Timestamp).toDate().toLocal()
          : null,
      eventTime: (snapshot['eventTime'] as Timestamp).toDate().toLocal(),
      promotedBy: Department.fromString(
        snapshot['promotedBy'] as String,
      ),
      description: snapshot['description'] != null
          ? snapshot['description'] as String
          : null,
      theme: snapshot['theme'] != null ? snapshot['theme'] as String : null,
      singer: snapshot['singer'] != null ? snapshot['singer'] as String : null,
      minister:
          snapshot['minister'] != null ? snapshot['minister'] as String : null,
      confirmedPresences: (snapshot['confirmedPresences'] as List)
          .map((e) => e.toString())
          .toList(),
      createdAt: (snapshot['createdAt'] as Timestamp).toDate().toLocal(),
    );
  }

  EventModel copyWith({
    String? id,
    String? userId,
    String? title,
    EventType? type,
    EventStatus? status,
    String? imageUrl,
    String? eventLocation,
    DateTime? eventDate,
    DateTime? eventTime,
    Department? promotedBy,
    String? description,
    String? theme,
    String? singer,
    String? minister,
    List<String>? confirmedPresences,
    DateTime? createdAt,
  }) {
    return EventModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      type: type ?? this.type,
      status: status ?? this.status,
      imageUrl: imageUrl ?? this.imageUrl,
      eventLocation: eventLocation ?? this.eventLocation,
      eventDate: eventDate ?? this.eventDate,
      eventTime: eventTime ?? this.eventTime,
      promotedBy: promotedBy ?? this.promotedBy,
      description: description ?? this.description,
      theme: theme ?? this.theme,
      singer: singer ?? this.singer,
      minister: minister ?? this.minister,
      confirmedPresences: confirmedPresences ?? this.confirmedPresences,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
