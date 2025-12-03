import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_todo_app/data/models/todo_task_model.dart';
import 'task_repository.dart';

class FirestoreTaskRepository implements TaskRepository {
  final FirebaseFirestore _firestore;

  FirestoreTaskRepository(this._firestore);

  CollectionReference get _col => _firestore.collection('tasks');

  @override
  Stream<List<TodoTaskModel>> watchTasksForUser(String userEmail) {
    // real-time stream: owner OR sharedWith contains userEmail
    return _col
        .where(
          'visibleTo',
          arrayContains: userEmail,
        ) // maintain a combined array
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => TodoTaskModel.fromFirestore(doc))
              .toList();
        });
  }

  @override
  Future<void> addTask(TodoTaskModel task) async {
    final data = task.toMap()
      ..['visibleTo'] = [task.ownerId, ...task.sharedWith];
    await _col.add(data);
  }

  @override
  Future<void> updateTask(TodoTaskModel task) async {
    final data = task.toMap()
      ..['visibleTo'] = [task.ownerId, ...task.sharedWith];
    await _col.doc(task.id).update(data);
  }

  @override
  Future<void> toggleComplete(String taskId, bool value) async {
    await _col.doc(taskId).update({
      'isCompleted': value,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> shareTask(String taskId, String emailToShare) async {
    final ref = _col.doc(taskId);
    await _firestore.runTransaction((tx) async {
      final snap = await tx.get(ref);
      final data = snap.data() as Map<String, dynamic>;
      final sharedWith = List<String>.from(data['sharedWith'] ?? []);
      if (!sharedWith.contains(emailToShare)) {
        sharedWith.add(emailToShare);
      }

      final visibleTo = List<String>.from(data['visibleTo'] ?? []);
      if (!visibleTo.contains(emailToShare)) {
        visibleTo.add(emailToShare);
      }

      tx.update(ref, {
        'sharedWith': sharedWith,
        'visibleTo': visibleTo,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }
}
