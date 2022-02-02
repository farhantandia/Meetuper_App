import 'package:flutter/material.dart';

abstract class BlocBase {
  void dispose();
}

class BlocProvider<T extends BlocBase> extends StatefulWidget {
  final T bloc;
  final Widget child;

  BlocProvider({Key? key, required this.child, required this.bloc})
      : super(key: key);

  _BlocProviderState<T> createState() => _BlocProviderState<T>();
  static T? of<T extends BlocBase>(BuildContext context) {
    var provider = context.findAncestorWidgetOfExactType<
        _BlocProviderInherited<T>>();
    _BlocProviderInherited<T>? widget = provider;
    return widget?.bloc;
  }
}

class _BlocProviderState<T extends BlocBase> extends State<BlocProvider<T>> {
  dispose() {
    widget.bloc.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return _BlocProviderInherited(
      child: widget.child,
      bloc: widget.bloc,
    );
  }
}

class _BlocProviderInherited<T> extends InheritedWidget {
  final T bloc;

  _BlocProviderInherited({Key? key, required Widget child, required this.bloc})
      : super(key: key, child: child);

  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}
