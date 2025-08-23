import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String userEmail;
  DatabaseService(this.userEmail);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addCategory(String categoryName) async {
    await _firestore
        .collection('users')
        .doc(userEmail)
        .collection('categories')
        .doc(categoryName)
        .set({});
  }

  Future<List<String>> getCategories() async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userEmail)
        .collection('categories')
        .get();
    return snapshot.docs.map((doc) => doc.id).toList();
  }

  Future<void> addTask(String category, Map<String, dynamic> task) async {
    await _firestore
        .collection('users')
        .doc(userEmail)
        .collection('categories')
        .doc(category)
        .collection('tasks')
        .add(task);
  }

  Stream<QuerySnapshot> getTasks(String category) {
    return _firestore
        .collection('users')
        .doc(userEmail)
        .collection('categories')
        .doc(category)
        .collection('tasks')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> tickTask(String category, String taskId) async {
    await _firestore
        .collection('users')
        .doc(userEmail)
        .collection('categories')
        .doc(category)
        .collection('tasks')
        .doc(taskId)
        .update({'Yes': true});
  }

  Future<void> removeTask(String category, String taskId) async {
    await _firestore
        .collection('users')
        .doc(userEmail)
        .collection('categories')
        .doc(category)
        .collection('tasks')
        .doc(taskId)
        .delete();
  }

  Future<void> deleteCategory(String category) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userEmail)
        .collection('categories')
        .doc(category)
        .delete();
  }
}
