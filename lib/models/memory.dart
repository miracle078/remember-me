import 'dart:typed_data';

enum MemoryType {
  photo,
  voice,
  text,
}

class Memory {
  final String id;
  final MemoryType type;
  final String content; // File path for photo/voice, or text content
  final String? title;
  final String? description;
  final DateTime date;
  final Uint8List? embedding; // Vector embedding for semantic search
  final List<String> relatedPeopleIds;

  Memory({
    required this.id,
    required this.type,
    required this.content,
    this.title,
    this.description,
    DateTime? date,
    this.embedding,
    this.relatedPeopleIds = const [],
  }) : date = date ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.toString().split('.').last,
      'content': content,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'embedding': embedding,
      'related_people_ids': relatedPeopleIds.join(','),
    };
  }

  factory Memory.fromMap(Map<String, dynamic> map) {
    return Memory(
      id: map['id'],
      type: MemoryType.values.firstWhere(
        (e) => e.toString().split('.').last == map['type'],
      ),
      content: map['content'],
      title: map['title'],
      description: map['description'],
      date: DateTime.parse(map['date']),
      embedding: map['embedding'],
      relatedPeopleIds: map['related_people_ids'] != null && map['related_people_ids'] != ''
          ? (map['related_people_ids'] as String).split(',')
          : [],
    );
  }

  Memory copyWith({
    String? id,
    MemoryType? type,
    String? content,
    String? title,
    String? description,
    DateTime? date,
    Uint8List? embedding,
    List<String>? relatedPeopleIds,
  }) {
    return Memory(
      id: id ?? this.id,
      type: type ?? this.type,
      content: content ?? this.content,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      embedding: embedding ?? this.embedding,
      relatedPeopleIds: relatedPeopleIds ?? this.relatedPeopleIds,
    );
  }
}
