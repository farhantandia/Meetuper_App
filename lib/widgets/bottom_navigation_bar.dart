import 'package:flutter/material.dart';
import 'package:meetuper_app/blocs/user_bloc/states.dart';
import 'package:meetuper_app/utils/jwt.dart';

class BottomNavigation extends StatelessWidget {
  final currentIndex;
  final Function(int) onChange;
  final UserState? userState;
  BottomNavigation({required this.userState, required this.onChange, required this.currentIndex});

  _handleTap(int index, BuildContext context) {
    if (_canAccess()) {
      onChange(index);
    } else {
      if (index != 0) {
        snackbar('You need to log in and to be member of this meetup!', context, 1);
            }
    }
  }

_renderColor() {
  return _canAccess() ? null : Colors.black12;
}

bool _canAccess() {
  return userState is UserIsMember || userState is UserIsMeetupOwner;
}

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (i) =>_handleTap(i,context),
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ('Home')),
        BottomNavigationBarItem(
            icon: Icon(Icons.note, color: _renderColor()),
            label: 'Threads',
            backgroundColor: _renderColor()),
        BottomNavigationBarItem(
            icon: Icon(Icons.people, color: _renderColor()),
            label: 'People',
            backgroundColor: _renderColor()),
      ],
    );
  }
}
