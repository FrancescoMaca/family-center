import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_center/models/family_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<FamilyUser?> getUserStream() {
    return FirebaseFirestore.instance
      .collection('users')
      .doc(_auth.currentUser?.uid)
      .snapshots()
      .map((snapshot) => 
        snapshot.exists ?
          FamilyUser.fromMap(snapshot.data()!) :
          null
      );
  }

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

  Future<String> getName() async {
    try {
      final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get();
    
      if (!snapshot.exists) {
        throw Exception('User does not exist');
      }
      
      final userData = snapshot.data()!;

      return userData['name'] as String;
    }
    catch (e) {
      rethrow;
    }
  }

    Future<String> getAge() async {
    try {
      final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get();
    
      if (!snapshot.exists) {
        throw Exception('User does not exist');
      }
      
      final userData = snapshot.data()!;

      return userData['age'] as String;
    }
    catch (e) {
      rethrow;
    }
  }
}