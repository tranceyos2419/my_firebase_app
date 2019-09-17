import 'package:cloud_firestore/cloud_firestore.dart';

class Character {
  final String name;
  final String img;
  final int rating;
  final DocumentReference reference;

  Character(this.name, this.img, this.rating, this.reference);

  Character.fromMap(Map<String, dynamic> snapshot, {this.reference})
      : assert(snapshot['name'] != null),
        assert(snapshot['img'] != null),
        assert(snapshot['rating'] != null),
        name = snapshot['name'],
        img = snapshot['img'],
        rating = snapshot['rating'];

  toJson() {
    return {"name": name, "img": img, "rating": rating};
  }
}
