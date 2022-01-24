import 'package:flutter/material.dart';

class AppStore extends StatefulWidget {
  final Widget child;
  // final String data;
  const AppStore({
    required this.child,
    // required this.data
  });
  @override
  _AppStoreState createState() => _AppStoreState();

  static _AppStoreState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_InheritedAppState>()!.data;
}

class _AppStoreState extends State<AppStore> {
  String testingData = 'Testing Data :)';

  @override
  Widget build(BuildContext context) {
    return _InheritedAppState(child: widget.child, data: this);
  }
}

class _InheritedAppState extends InheritedWidget {
  final _AppStoreState data;
  _InheritedAppState({required Widget child, required this.data})
      : super(child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return true;
  }
}
