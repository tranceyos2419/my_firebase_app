import 'package:cloud_firestore/cloud_firestore.dart';

class Character {
  final String name;
  final String img;
  final int rating;
  final String uid;
  final DocumentReference reference;

  Character({this.name, this.img, this.rating, this.uid, this.reference});

  Character.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['img'] != null),
        assert(map['uid'] != null),
        assert(map['rating'] != null),
        name = map['name'],
        img = map['img'],
        uid = map['uid'],
        rating = map['rating'];

  Character.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  toJson() {
    return {"name": name, "img": img, "rating": rating, 'uid': uid};
  }
}
