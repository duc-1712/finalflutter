// lib/event/event_notes_model.dart

class EventNotesModel {
  final String id;
  final String eventId;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;

  EventNotesModel({
    required this.id,
    required this.eventId,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'eventId': eventId,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory EventNotesModel.fromMap(Map<String, dynamic> map) {
    return EventNotesModel(
      id: map['id'],
      eventId: map['eventId'],
      content: map['content'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  EventNotesModel copyWith({
    String? id,
    String? eventId,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EventNotesModel(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
