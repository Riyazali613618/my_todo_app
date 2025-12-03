import 'package:cloud_firestore/cloud_firestore.dart';

class TodoTaskModel {
  final String id;
  final String title;
  final String? description;
  final bool isCompleted;
  final String ownerId;
  final List<String> sharedWith; // user emails or IDs
  final DateTime createdAt;
  final DateTime updatedAt;

  TodoTaskModel({
    required this.id,
    required this.title,
    this.description,
    required this.isCompleted,
    required this.ownerId,
    required this.sharedWith,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TodoTaskModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return TodoTaskModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'],
      isCompleted: data['isCompleted'] ?? false,
      ownerId: data['ownerId'] ?? '',
      sharedWith: List<String>.from(data['sharedWith'] ?? []),
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'ownerId': ownerId,
      'sharedWith': sharedWith,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  TodoTaskModel copyWith({
    String? title,
    String? description,
    bool? isCompleted,
    List<String>? sharedWith,
    DateTime? updatedAt,
  }) {
    return TodoTaskModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      ownerId: ownerId,
      sharedWith: sharedWith ?? this.sharedWith,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
