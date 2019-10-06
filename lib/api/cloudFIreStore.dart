import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_firebase_app/model/character.dart';
import 'package:my_firebase_app/model/user.dart';
import 'package:my_firebase_app/provider/auth.dart';

class CloudFireStore {
  final Firestore _db = Firestore.instance;
  final String path;
  CollectionReference ref;

//* Add a function to a constructor
  CloudFireStore(this.path) {
    ref = _db.collection(path);
  }

  Future<QuerySnapshot> getDataCollection() {
    // return ref.getDocuments();
  }

  Stream<QuerySnapshot> stramDataCollection(User user) {
    return ref
        .orderBy('rating', descending: true)
        .where('uid', isEqualTo: user.uid)
        .snapshots();
  }

  Future<DocumentSnapshot> getDocumentById(String id) {
    return ref.document(id).get();
  }

  Future<void> removeDocumentById(String id) {
    return ref.document(id).delete();
  }

  Future<DocumentReference> addDocument(Map map) {
    return ref.add(map);
  }

  Future<void> updateDocument(Map map, String id) {
    return ref.document(id).updateData(map);
  }

  Future<void> setDocument(Map map, String id) {
    return ref.document(id).setData(map);
  }

  //TODO generalize
  Future<void> upddateDocumentAsTransaction(
      Function callback, Character character) async {
    await _db.runTransaction((transaction) async {
      // await callback(transaction);
      // final freshSNapshot = await transaction.get(character.reference);
      // final fresh = Character.fromSnapshot(freshSNapshot);
      // final json = fresh.toJson();
      final json = character.toJson();
      await transaction.update(character.reference, json);
    });
    return;
  }
}
