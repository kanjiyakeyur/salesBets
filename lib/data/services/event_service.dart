import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event/event.dart';

class EventService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _eventsCollection = 'events';

  static Future<String> createEvent(Event event) async {
    try {
      event.createdAt = DateTime.now();
      event.updatedAt = DateTime.now();

      DocumentReference docRef = await _firestore
          .collection(_eventsCollection)
          .add(event.toJson());

      event.id = docRef.id;
      await docRef.update({'id': docRef.id});

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create event: $e');
    }
  }

  static Stream<List<Event>> getEventsStream() {
    return _firestore
        .collection(_eventsCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Event.fromJson(doc.data());
      }).toList();
    });
  }

  static Future<List<Event>> getEvents() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_eventsCollection)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        return Event.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch events: $e');
    }
  }

  static Future<Event?> getEventById(String eventId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(_eventsCollection)
          .doc(eventId)
          .get();

      if (doc.exists) {
        return Event.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch event: $e');
    }
  }

  static Future<void> updateEvent(Event event) async {
    try {
      event.updatedAt = DateTime.now();
      await _firestore
          .collection(_eventsCollection)
          .doc(event.id)
          .update(event.toJson());
    } catch (e) {
      throw Exception('Failed to update event: $e');
    }
  }

  static Future<void> deleteEvent(String eventId) async {
    try {
      await _firestore
          .collection(_eventsCollection)
          .doc(eventId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete event: $e');
    }
  }

  static Future<void> updateEventStatus(String eventId, BetStatus status) async {
    try {
      await _firestore
          .collection(_eventsCollection)
          .doc(eventId)
          .update({
        'status': status.toString().split('.').last,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      throw Exception('Failed to update event status: $e');
    }
  }

  static Future<void> addBetToEvent(String eventId, Bet bet) async {
    try {
      DocumentReference eventRef = _firestore
          .collection(_eventsCollection)
          .doc(eventId);

      bet.createdAt = DateTime.now();
      bet.updatedAt = DateTime.now();

      await eventRef.update({
        'betLists': FieldValue.arrayUnion([bet.toJson()]),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      throw Exception('Failed to add bet to event: $e');
    }
  }
}