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
  CloudFireStore _store = CloudFireStore('users');
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();
  final FacebookLogin _facebookLogin = FacebookLogin();

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

  Future<void> googleSignIn() async {
    // Step 1
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();

    // Step 2
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    //* Making credential
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    //* sign in user with credential and update firebase credential
    await oauthSignIn(credential);
  }

  Future<void> facebookLogin() async {
    var facebookLoginResult = await _facebookLogin.logIn(['email']);
    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        print("Error");
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("CancelledByUser");
        break;
      case FacebookLoginStatus.loggedIn:
        AuthCredential credential = FacebookAuthProvider.getCredential(
            accessToken: facebookLoginResult.accessToken.token);
        oauthSignIn(credential);
        break;
    }
  }

  Future<void> oauthSignIn(AuthCredential credential) async {
    FirebaseUser _firebaseUser = await _firebaseAuth
        .signInWithCredential(credential)
        .then((result) => result.user);

    _user = new User(
        uid: _firebaseUser.uid,
        email: _firebaseUser.email,
        photoUrl: _firebaseUser.photoUrl,
        displayName: _firebaseUser.displayName,
        lastSeen: new DateTime.now());

    await _store.setDocument(_user.toJson(), _user.uid);

    _auth = true;
    notifyListeners();
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    _user = null;
    _auth = false;
    notifyListeners();
  }
}
