class User {
  final String uid;
  final String email;
  final String photoUrl;
  final String displayName;
  final DateTime lastSeen;

  User({this.uid, this.email, this.photoUrl, this.displayName, this.lastSeen});

  toJson() {
    return {
      'uid': uid,
      'email': email,
      'photourl': photoUrl,
      'displayName': displayName,
      'lastSeen': lastSeen
    };
  }
}
