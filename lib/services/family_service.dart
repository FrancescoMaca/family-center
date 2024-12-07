import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

import 'package:family_center/models/family.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FamilyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String generateJoinCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return List.generate(6, (index) => chars[random.nextInt(chars.length)]).join();
  }

  Future<void> createFamily(String name, String userId) async {
    final joinCode = generateJoinCode();
    final familyRef = _firestore.collection('families').doc();
    
    final family = Family(
      id: familyRef.id,
      name: name,
      joinCode: joinCode,
      memberIds: [userId],
      ownerId: FirebaseAuth.instance.currentUser!.uid,
      moderatorsIds: []
    );

    await familyRef.set(family.toMap());
    await _firestore.collection('users').doc(userId).update({
      'familyIds': FieldValue.arrayUnion([familyRef.id])
    });
  }

  Future<void> joinFamily(String joinCode, String userId) async {
    final querySnapshot = await _firestore
        .collection('families')
        .where('joinCode', isEqualTo: joinCode)
        .get();

    if (querySnapshot.docs.isEmpty) {
      throw Exception('Family not found');
    }

    final familyDoc = querySnapshot.docs.first;
    await familyDoc.reference.update({
      'memberIds': FieldValue.arrayUnion([userId])
    });

    await _firestore.collection('users').doc(userId).update({
      'familyIds': FieldValue.arrayUnion([familyDoc.id])
    });
  }

  Stream<List<Family>> getUserFamilies(String userId) {
    return _firestore
      .collection('families')
      .where('memberIds', arrayContains: userId)
      .snapshots()
      .map((QuerySnapshot snapshot) {
        return snapshot.docs.map((QueryDocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          return Family.fromMap(data);
        }).toList();
      });
  }

  Future<void> leaveFamily(String familyCode) async {
    try {
      final querySnapshot = await _firestore
        .collection('families')
        .where('joinCode', isEqualTo: familyCode)
        .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception('Family not found');
      }

      final familyDoc = querySnapshot.docs.first;
      final familyId = familyDoc.id;

      final familyData = familyDoc.data();
      final List<String> memberIds = List<String>.from(familyData['memberIds']);
      
      final currentUserId = FirebaseAuth.instance.currentUser!.uid;

      memberIds.remove(currentUserId);

      if (memberIds.isEmpty) {
        await _firestore.collection('families').doc(familyId).delete();
      }
      else {
        await _firestore.collection('families').doc(familyId).update({
          'memberIds': FieldValue.arrayRemove([currentUserId])
        });
      }

      await _firestore.collection('users').doc(currentUserId).update({
        'familyIds': FieldValue.arrayRemove([familyId])
      });
    } catch (e) {
      throw Exception('Failed to leave family: ${e.toString()}');
    }
  }
}
