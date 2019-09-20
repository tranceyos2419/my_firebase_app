import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_firebase_app/screen/character_form_screen.dart';
import 'package:my_firebase_app/screen/character_list_screen.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => CharacterListScreen());
      case CharacterFormScreen.routeName:
        return MaterialPageRoute(builder: (_) => CharacterFormScreen());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}
