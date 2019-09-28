import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_firebase_app/api/cloudFIreStore.dart';
import 'package:my_firebase_app/model/user.dart';

class Auth with ChangeNotifier {
  var _auth = false;
  User _user;

  //* Initialization
  CloudFireStore _api = CloudFireStore('users');
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();

  bool get isAuth {
    return _auth;
  }

  User get user {
    if (_user != null) {
      return _user;
    } else {
      throw Error();
    }
  }

  Future<FirebaseUser> googleSignIn() async {
    // Step 1
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();

    // Step 2
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    //* Making credential
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    //* sign in user with credential and update firebase credential
    FirebaseUser _firebaseUser = await _firebaseAuth
        .signInWithCredential(credential)
        .then((result) => result.user);

    _user = new User(
        uid: _firebaseUser.uid,
        email: _firebaseUser.email,
        photoUrl: _firebaseUser.photoUrl,
        displayName: _firebaseUser.displayName,
        lastSeen: new DateTime.now());

    await updateUser(
      _user,
    );

    _auth = true;
    notifyListeners();
    return _firebaseUser;
  }

  Future<void> initiateFacebookLogin() async {
    var facebookLogin = FacebookLogin();
    var facebookLoginResult = await facebookLogin.logIn(['email']);
    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        print("Error");
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("CancelledByUser");
        break;
      case FacebookLoginStatus.loggedIn:
        print("LoggedIn");
        break;
    }
  }

  Future updateUser(User user) async {
    await _api.setDocument(user.toJson(), user.uid);
  }

  void signOut() {
    _firebaseAuth.signOut();
    _user = null;
    _auth = false;
    notifyListeners();
  }
}
