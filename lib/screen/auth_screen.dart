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
                buildSignIn(
                    context: context,
                    title: 'Sign In with Google',
                    icon: Icon(
                      FontAwesomeIcons.google,
                      color: Colors.orange,
                    ),
                    onPressed: () async {
                      await Provider.of<Auth>(context).googleSignIn();
                    }),
                buildSignIn(
                    context: context,
                    title: 'Sign In with Facebook',
                    icon: Icon(
                      FontAwesomeIcons.facebook,
                      color: Colors.blue,
                    ),
                    onPressed: () async {
                      await Provider.of<Auth>(context).facebookLogin();
                    }),
              ],
            )
          ],
        ),
      ),
    );
  }
}

Widget buildSignIn(
    {BuildContext context, String title, Icon icon, Function onPressed}) {
  return Container(
    alignment: Alignment.center,
    width: 250.0,
    child: RaisedButton(
      color: Colors.white,
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          icon,
          SizedBox(
            width: 10.0,
          ),
          Text(title)
        ],
      ),
    ),
  );
}
