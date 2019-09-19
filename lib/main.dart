import 'package:flutter/material.dart';
import 'package:my_firebase_app/provider/characters.dart';
import 'package:my_firebase_app/screen/router.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Characters(),
        )
      ],
      child: MaterialApp(
        title: 'Character App',
        debugShowCheckedModeBanner: false,
        theme:
            ThemeData(primaryColor: Colors.purple, accentColor: Colors.yellow),
        initialRoute: '/',
        onGenerateRoute: Router.generateRoute,
      ),
    );
  }
}
