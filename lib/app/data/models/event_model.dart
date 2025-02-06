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
      createdAt: (snapshot['createdAt'] as Timestamp).toDate().toLocal(),
    );
  }
}
