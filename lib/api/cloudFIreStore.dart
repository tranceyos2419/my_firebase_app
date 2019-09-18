import 'package:cloud_firestore/cloud_firestore.dart';

class CloudFireStore {
  final Firestore _db = Firestore.instance;
  final String path;
  CollectionReference ref;

//* Add a function to a constructor
  CloudFireStore(this.path) {
    ref = _db.collection(path);
  }

  Future<QuerySnapshot> getDataCollection() {
    return ref.getDocuments();
  }

  Stream<QuerySnapshot> stramDataCollection() {
    return ref.snapshots();
  }

  Future<DocumentSnapshot> getDocumentById(String id) {
    return ref.document(id).get();
  }

  Future<void> removeDocument(String id) {
    return ref.document(id).delete();
  }

  Future<DocumentReference> addDocument(Map map) {
    return ref.add(map);
  }

  Future<void> updateDocument(Map map, String id) {
    return ref.document(id).updateData(map);
  }
}
