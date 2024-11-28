import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> changeNameAndAge(String name, String age) async {
    if (_auth.currentUser == null) {
      throw Exception('Operation not permitted');
    }

    try {
      await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .update({ 'name': name, 'age': age });
    } catch (e) {
      throw Exception('Failed to change name and age: $e');
    }
  }
}