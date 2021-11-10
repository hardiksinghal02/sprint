import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sprint/providers/login_provider.dart';
import 'package:sprint/providers/task_provider.dart';
import 'package:sprint/screens/home_screen.dart';
import 'package:sprint/screens/login_screen.dart';
import 'package:sprint/utils/date_util.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginProvider loginProvider = Provider.of<LoginProvider>(context);

    loginProvider.initialSetup().then((value) {
      if (loginProvider.isAuthenticated()) {
        final taskProvider = Provider.of<TaskProvider>(context, listen: false);
        taskProvider.setUserReference(loginProvider.getUserId());
        taskProvider.setTasks().then((value) async {
          return await taskProvider
              .setStatus(DateUtil.getDateId(DateTime.now()));
        }).then((value) {
          Navigator.of(context).pushReplacementNamed(HomeScreen.route);
        });
      } else {
        Navigator.of(context).pushReplacementNamed(LoginScreen.route);
      }
    }).catchError((e) => print("Error occured while setting initial setup"));

    // loginProvider.setUser().then((_) {
    //   if (loginProvider.isAuthenticated()) {
    //     final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    //     taskProvider.setUserReference(loginProvider.getUserId());
    //     taskProvider.setTasks().then((value) {
    //       taskProvider
    //           .setStatus(DateUtil.getDateId(DateTime.now()))
    //           .then((_) {});
    //     });
    //   } else {

    //   }
    // });

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  CircularProgressIndicator(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Loading data"),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
