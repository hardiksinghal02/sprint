import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sprint/providers/login_provider.dart';

import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  static const route = 'login-screen';
  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);

    void _loginWithGoogle() {
      loginProvider.signInWithGoogle().then((value) {
        loginProvider.isAuthenticated()
            ? Navigator.of(context).pushReplacementNamed(HomeScreen.route)
            : Navigator.of(context).pushReplacementNamed(LoginScreen.route);
      });
    }

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: _loginWithGoogle, child: Text("Google"))
            ],
          )
        ],
      ),
    );
  }
}
