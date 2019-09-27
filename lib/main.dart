import 'package:flutter/material.dart';
import 'package:my_firebase_app/provider/auth.dart';
import 'package:my_firebase_app/provider/characters.dart';
import 'package:my_firebase_app/screen/auth_screen.dart';
import 'package:my_firebase_app/screen/character_form_screen.dart';
import 'package:my_firebase_app/screen/character_list_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Characters(),
          ),
          ChangeNotifierProvider.value(
            value: Auth(),
          )
        ],
        child: Consumer<Auth>(
          builder: (context, auth, _) {
            return MaterialApp(
              title: 'My Wife App',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                  primaryColor: Colors.purple, accentColor: Colors.amber),
              // initialRoute: '/',
              // initialRoute: CharacterFormScreen.routeName,
              // onGenerateRoute: Router.generateRoute,
              home: auth.isAuth ? CharacterListScreen() : AuthScreen(),
              routes: {
                // '/': (context) => CharacterListScreen(),
                CharacterFormScreen.routeName: (context) =>
                    CharacterFormScreen()
              },
            );
          },
        ));
  }
}
