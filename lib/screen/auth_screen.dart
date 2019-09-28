import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_firebase_app/provider/auth.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Auth'),
      ),
      body: Builder(
        builder: (context) => Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              child: Image.network(
                'https://cdnb.artstation.com/p/assets/images/images/006/909/673/large/tu-tu-ngoaicanh2.jpg?1502191943',
                fit: BoxFit.cover,
                color: Color.fromRGBO(255, 255, 255, 0.5),
                colorBlendMode: BlendMode.modulate,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  width: 250.0,
                  child: RaisedButton(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    onPressed: () async {
                      // await Provider.of<Auth>(context).googleSignIn();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.google,
                          color: Colors.orange,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text('Sign In with Google')
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

// return Scaffold(
//   body: Builder(
//     builder: (context) => Stack(
//       fit: StackFit.expand,
//       children: <Widget>[
//         Container(
//           width: MediaQuery.of(context).size.width,
//           height: MediaQuery.of(context).size.height,
//           child: Image.network(
//               'https://images.unsplash.com/photo-1518050947974-4be8c7469f0c?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60',
//               fit: BoxFit.fill,
//               color: Color.fromRGBO(255, 255, 255, 0.6),
//               colorBlendMode: BlendMode.modulate),
//         ),
//         Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             SizedBox(height: 10.0),
//             Container(
//                 width: 250.0,
//                 child: Align(
//                   alignment: Alignment.center,
//                   child: RaisedButton(
//                     shape: RoundedRectangleBorder(
//                         borderRadius: new BorderRadius.circular(30.0)),
//                     color: Color(0xffffffff),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: <Widget>[
//                         Icon(
//                           FontAwesomeIcons.google,
//                           color: Color(0xffCE107C),
//                         ),
//                         SizedBox(width: 10.0),
//                         Text(
//                           'Sign in with Google',
//                           style: TextStyle(
//                               color: Colors.black, fontSize: 18.0),
//                         ),
//                       ],
//                     ),
