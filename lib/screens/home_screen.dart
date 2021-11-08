import 'package:bottom_bar_page_transition/bottom_bar_page_transition.dart';
import 'package:flutter/material.dart';
import 'package:sprint/screens/account_screen.dart';
import 'package:sprint/screens/task_screen.dart';
import 'package:sprint/screens/timer_screen.dart';
import 'package:sprint/widgets/bottom_bar.dart';

class HomeScreen extends StatefulWidget {
  static const route = "home-screen";
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int pageId = 0;

  List<Widget> screens = [TaskScreen(), TimerScreen(), AccountScreen()];

  void updateId(int id) {
    setState(() {
      pageId = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: BottomBarPageTransition(
            builder: (_, index) => screens[index],
            currentIndex: pageId,
            totalLength: screens.length,
            transitionType: TransitionType.slide,
            transitionDuration: const Duration(milliseconds: 100),
            transitionCurve: Curves.easeIn,
          ),
        ),
        bottomNavigationBar: BottomBar(
          buttonTap: (int id) {
            updateId(id);
          },
        ));
  }
}
