import 'package:flutter/material.dart';


class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (int index) {
        print(index);
        setState(() {
          _currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined), label: ('Home')),
        BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined), label: ('Profile')),
        BottomNavigationBarItem(
            icon: Icon(Icons.settings_applications_outlined), label: ('Settings'))
      ],
    );
  }
}
