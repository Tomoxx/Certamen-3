import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  Stream<QuerySnapshot> games() {
    return FirebaseFirestore.instance.collection('games').snapshots();
  }
}
