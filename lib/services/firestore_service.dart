import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  Stream<QuerySnapshot> games() {
    return FirebaseFirestore.instance.collection('games').snapshots();
  }

  Stream<QuerySnapshot> developers() {
    return FirebaseFirestore.instance.collection('developers').snapshots();
  }

  Stream<QuerySnapshot> publishers() {
    return FirebaseFirestore.instance.collection('publishers').snapshots();
  }
}
