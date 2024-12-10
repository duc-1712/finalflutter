// test/event_notes_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:event_manager/event/event_notes_model.dart';

void main() {
  group('EventNotesModel Tests', () {
    late EventNotesModel eventNotes;

    setUp(() {
      final fixedTime = DateTime(2024, 1, 1, 12, 0);
      eventNotes = EventNotesModel(
        id: '1',
        eventId: 'event123',
        content: 'Test note content',
        createdAt: fixedTime,
        updatedAt: fixedTime,
      );
    });

    test('should create EventNotesModel with correct values', () {
      expect(eventNotes.id, equals('1'));
      expect(eventNotes.eventId, equals('event123'));
      expect(eventNotes.content, equals('Test note content'));
      expect(eventNotes.createdAt, isNotNull);
      expect(eventNotes.updatedAt, isNotNull);
    });

    test('should convert EventNotesModel to Map', () {
      final map = eventNotes.toMap();

      expect(map['id'], equals('1'));
      expect(map['eventId'], equals('event123'));
      expect(map['content'], equals('Test note content'));
      expect(map['createdAt'], isA<String>());
      expect(map['updatedAt'], isA<String>());
    });

    test('should create EventNotesModel from Map', () {
      final map = {
        'id': '1',
        'eventId': 'event123',
        'content': 'Test note content',
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      };

      final newEventNotes = EventNotesModel.fromMap(map);

      expect(newEventNotes.id, equals('1'));
      expect(newEventNotes.eventId, equals('event123'));
      expect(newEventNotes.content, equals('Test note content'));
      expect(newEventNotes.createdAt, isNotNull);
      expect(newEventNotes.updatedAt, isNotNull);
    });

    test('should copy EventNotesModel with new values', () {
      Future.delayed(const Duration(milliseconds: 100));

      final copiedNotes = eventNotes.copyWith(
        content: 'Updated content',
      );

      expect(copiedNotes.id, equals(eventNotes.id));
      expect(copiedNotes.eventId, equals(eventNotes.eventId));
      expect(copiedNotes.content, equals('Updated content'));
      expect(copiedNotes.createdAt, equals(eventNotes.createdAt));
      expect(copiedNotes.updatedAt.isAfter(eventNotes.updatedAt), isTrue);
    });
  });
}
