import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sprint/providers/login_provider.dart';
import 'package:sprint/providers/task_provider.dart';
import 'package:sprint/screens/home_screen.dart';
import 'package:sprint/screens/login_screen.dart';
import 'package:sprint/screens/splash_screen.dart';

void main() async {
  try {
    await Firebase.initializeApp();
  } catch (error) {
    print(error);
  }
  runApp(Main());
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => LoginProvider()),
        ChangeNotifierProvider(create: (ctx) => TaskProvider()),
      ],
      child: MaterialApp(
        home: SplashScreen(),
        theme: ThemeData(brightness: Brightness.dark, accentColor: Colors.blue),
        themeMode: ThemeMode.dark,
        routes: {
          HomeScreen.route: (ctx) => HomeScreen(),
          LoginScreen.route: (ctx) => LoginScreen()
        },
      ),
    );
  }
}
