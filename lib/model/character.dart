import 'package:cloud_firestore/cloud_firestore.dart';

class Character {
  final String name;
  final String img;
  final int rating;
  final DocumentReference reference;

  Character({this.name, this.img, this.rating, this.reference});

  Character.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['img'] != null),
        assert(map['rating'] != null),
        name = map['name'],
        img = map['img'],
        rating = map['rating'];

  Character.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  toJson() {
    return {"name": name, "img": img, "rating": rating};
  }
}
