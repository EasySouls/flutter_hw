import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_hw/models/profile.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference? _usersCollection;

  FirestoreService();

  void _setupCollectionReferences() {
    _usersCollection = _firestore.collection("users").withConverter<Profile>(
          fromFirestore: (snapshots, _) => Profile.fromJson(snapshots.data()!),
          toFirestore: (userProfile, _) => userProfile.toJson(),
        );
  }

  Future<void> createUserProfile({required Profile userProfile}) async {
    await _usersCollection?.doc(userProfile.uid).set(userProfile);
  }
}
