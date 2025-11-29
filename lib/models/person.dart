import 'dart:typed_data';

class Person {
  final String id;
  final String name;
  final String relationship;
  final String? details;
  final String? photoPath;
  final Uint8List? faceEmbedding;
  final DateTime createdAt;

  Person({
    required this.id,
    required this.name,
    required this.relationship,
    this.details,
    this.photoPath,
    this.faceEmbedding,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'relationship': relationship,
      'details': details,
      'photo_path': photoPath,
      'face_embedding': faceEmbedding,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(
      id: map['id'],
      name: map['name'],
      relationship: map['relationship'],
      details: map['details'],
      photoPath: map['photo_path'],
      faceEmbedding: map['face_embedding'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Person copyWith({
    String? id,
    String? name,
    String? relationship,
    String? details,
    String? photoPath,
    Uint8List? faceEmbedding,
    DateTime? createdAt,
  }) {
    return Person(
      id: id ?? this.id,
      name: name ?? this.name,
      relationship: relationship ?? this.relationship,
      details: details ?? this.details,
      photoPath: photoPath ?? this.photoPath,
      faceEmbedding: faceEmbedding ?? this.faceEmbedding,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
