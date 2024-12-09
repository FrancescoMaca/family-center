import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

import 'package:family_center/models/family.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum FamilyRole {
  member,
  moderator,
  owner,
}

class FamilyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _generateJoinCode() {
    const chars = '0123456789';
    final random = Random();
    return List.generate(6, (index) => chars[random.nextInt(chars.length)]).join();
  }

  Future<void> createFamily(String name, String userId) async {
    final joinCode = _generateJoinCode();
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

    // Fetches a family with the given code
    final querySnapshot = await _firestore
        .collection('families')
        .where('joinCode', isEqualTo: joinCode)
        .get();

    if (querySnapshot.docs.isEmpty) {
      throw Exception('Family not found');
    }

    final familyDoc = querySnapshot.docs.first;

    // Check if the family is full, if so, throws exception
    final familyData = familyDoc.data();
    if (List<String>.from(familyData['memberIds']).length == Family.memberLimit) {
      throw Exception("Family is full");
    }

    // Adds the current user's id to the list and adds the family id to the user's family list
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

  Future<FamilyRole> getCurrentUserRole(String familyId) async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    
    final doc = await _firestore
      .collection('families')
      .doc(familyId)
      .get();
      
    if (!doc.exists) return FamilyRole.member;
    
    final data = doc.data()!;
    
    if (data['ownerId'] == currentUserId) {
      return FamilyRole.owner;
    }
    
    final List<String> modIds = List<String>.from(data['moderatorsIds'] ?? []);
    if (modIds.contains(currentUserId)) {
      return FamilyRole.moderator;
    }
    
    return FamilyRole.member;
  }

  Future<void> requestToJoinFamily(String joinCode, String userId, String requesterName) async {
    final querySnapshot = await _firestore
      .collection('families')
      .where('joinCode', isEqualTo: joinCode)
      .get();

    if (querySnapshot.docs.isEmpty) {
      throw Exception('Family not found');
    }

    final familyDoc = querySnapshot.docs.first;
    
    // Check existing request
    final existingRequest = await _firestore
      .collection('joinRequests')
      .where('familyId', isEqualTo: familyDoc.id)
      .where('userId', isEqualTo: userId)
      .where('status', isEqualTo: 'pending')
      .get();

    if (existingRequest.docs.isNotEmpty) {
      throw Exception('Already requested to join this family');
    }

    // Create request
    final requestRef = await _firestore.collection('joinRequests').add({
      'familyId': familyDoc.id,
      'userId': userId,
      'status': 'pending',
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Create in-app notification document
    await _firestore.collection('inAppNotifications').add({
      'recipientId': familyDoc.data()['ownerId'],
      'type': 'join_request',
      'title': 'New Join Request',
      'message': '$requesterName wants to join your family',
      'read': false,
      'timestamp': FieldValue.serverTimestamp(),
      'familyId': familyDoc.id,
      'requesterId': userId
    });

    // Show local notification
    // TODO: SHOW THE LOCAL NOTIFICATION
  }
}
