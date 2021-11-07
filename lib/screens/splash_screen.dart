import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sprint/providers/login_provider.dart';
import 'package:sprint/screens/home_screen.dart';
import 'package:sprint/screens/login_screen.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LoginProvider loginProvider = Provider.of<LoginProvider>(context);
    // loginProvider.signOut();
    loginProvider.setUser().then((_) {
      print("Setting done");
      print(loginProvider.getUser());
      if (loginProvider.isAuthenticated())
        Navigator.of(context).pushReplacementNamed(HomeScreen.route);
      else
        Navigator.of(context).pushReplacementNamed(LoginScreen.route);
    });

    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
