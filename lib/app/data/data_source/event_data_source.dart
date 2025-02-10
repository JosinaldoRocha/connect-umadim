import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_umadim_app/app/data/models/event_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/helpers/helpers.dart';

class EventDataSource {
  final firestore = FirebaseFirestore.instance;
  final supabase = Supabase.instance.client;

  Future<Either<CommonError, List<EventModel>>> getAllEvents() async {
    try {
      final getDocuments = await firestore
          .collection('events')
          .orderBy('eventDate', descending: true)
          .get();

      final documents = getDocuments.docs;
      List<EventModel> events = [];

      for (var docs in documents) {
        final item = EventModel.fromSnapShot(docs);
        events.add(item);
      }

      return Right(events);
    } on Exception catch (e) {
      return Left(GenerateError.fromException(e));
    }
  }

  Future<Either<CommonError, List<EventModel>>> getNextEvent() async {
    try {
      final now = DateTime.now();

      final querySnapshot = await firestore
          .collection('events')
          .where('eventDate', isGreaterThanOrEqualTo: Timestamp.fromDate(now))
          .orderBy('eventDate', descending: false)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return Right([]);
      }

      List<EventModel> events = querySnapshot.docs
          .map((doc) => EventModel.fromSnapShot(doc))
          .toList();

      DateTime closestDate = events.first.eventDate!.toLocal();
      closestDate =
          DateTime(closestDate.year, closestDate.month, closestDate.day);

      List<EventModel> filteredEvents = events.where((event) {
        final eventDate = event.eventDate!.toLocal();
        final eventDay =
            DateTime(eventDate.year, eventDate.month, eventDate.day);
        return eventDay == closestDate;
      }).toList();

      return Right(filteredEvents);
    } on Exception catch (e) {
      return Left(GenerateError.fromException(e));
    }
  }

  Future<Either<CommonError, bool>> addEvent(
    EventModel event,
    Uint8List? imageBytes,
  ) async {
    try {
      event.imageUrl = await eventImage(event, imageBytes);

      await firestore.collection('events').doc(event.id).set(event.toMap());
      return const Right(true);
    } on Exception catch (e) {
      return Left(GenerateError.fromException(e));
    }
  }

  Future<Either<CommonError, bool>> updateEvent(EventModel event) async {
    try {
      await firestore.collection('events').doc(event.id).update(event.toMap());
      return const Right(true);
    } on Exception catch (e) {
      return Left(GenerateError.fromException(e));
    }
  }

  Future<String?> eventImage(
    EventModel event,
    Uint8List? imageBytes,
  ) async {
    if ((event.imageUrl?.isEmpty ?? true) && imageBytes == null) return null;

    final fileName =
        'event_images/connect-umadim${event.id}${event.userId}.jpg';
    final storage = supabase.storage.from('event_images');

    if (kIsWeb) {
      await storage.uploadBinary(
        fileName,
        imageBytes!,
        fileOptions: const FileOptions(contentType: 'image/jpeg'),
      );
    } else {
      await storage.upload(fileName, File(event.imageUrl!));
    }

    return storage.getPublicUrl(fileName);
  }
}
