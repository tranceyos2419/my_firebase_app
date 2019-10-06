import 'package:cloud_firestore/cloud_firestore.dart';

class Character {
  final String name;
  final String img;
  final int rating;
  final String uid;
  final Timestamp createdAt;
  final DocumentReference reference;

  Character(
      {this.name,
      this.img,
      this.rating,
      this.uid,
      this.createdAt,
      this.reference});

  Character.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['img'] != null),
        assert(map['uid'] != null),
        // assert(map['createdAt'] != null),
        assert(map['rating'] != null),
        name = map['name'],
        img = map['img'],
        uid = map['uid'],
        createdAt = map['createdAt'],
        rating = map['rating'];

  Character.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  toJson() {
    return {
      "name": name,
      "img": img,
      "rating": rating,
      'uid': uid,
      'createdAt': createdAt
    };
  }
}
