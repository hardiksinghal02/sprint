import 'package:flutter/material.dart';

typedef void IntCallback(int id);

class BottomBar extends StatefulWidget {
  final IntCallback buttonTap;
  BottomBar({required this.buttonTap});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _currentIndex = 0;

  onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    widget.buttonTap(index);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.task_alt_rounded), label: "Tasks"),
        BottomNavigationBarItem(
            icon: Icon(Icons.watch_later_outlined), label: "Timer"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
      ],
      currentIndex: _currentIndex,
      onTap: onTap,
      showSelectedLabels: true,
      showUnselectedLabels: false,
    );
  }
}
