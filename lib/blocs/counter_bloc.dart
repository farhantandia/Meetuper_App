
import 'package:flutter/material.dart';
import 'dart:async';

import 'bloc_provider.dart';

class CounterBloc extends BlocBase{
  final StreamController<int> _streamController = StreamController<int>.broadcast();
  final StreamController<int> _counterController = StreamController<int>.broadcast();
  int _counter = 0;

  Stream<int> get counterStream => _counterController.stream;
  StreamSink<int> get counterSink => _counterController.sink;

  CounterBloc() {
    _streamController.stream
        .listen(_handleIncrement);
  }

  _handleIncrement(int number) {
    _counter += number;
    counterSink.add(_counter);
  }

  increment(int incrementer) {
    _streamController.sink.add(incrementer);
  }

  dispose() {
    _streamController.close();
    _counterController.close();
  }
}

class CounterBlocProvider extends StatefulWidget {
  final CounterBloc bloc;
  final Widget child;

  CounterBlocProvider({Key? key, required this.child})
      : bloc = CounterBloc(),
        super(key: key);

  _CounterBlocProviderState createState() => _CounterBlocProviderState();
  static CounterBloc of(BuildContext context) {
    _CounterBlocProviderInherited provider =
    (context.getElementForInheritedWidgetOfExactType<_CounterBlocProviderInherited>()?.widget
    as _CounterBlocProviderInherited);

    return provider.bloc;
  }
}

class _CounterBlocProviderState extends State<CounterBlocProvider> {

  dispose(){
    widget.bloc.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {
    return _CounterBlocProviderInherited(
      
      child: widget.child,
      bloc: widget.bloc

    );
  }
}


class _CounterBlocProviderInherited extends InheritedWidget {
  final CounterBloc bloc;

  _CounterBlocProviderInherited({required Widget child, required CounterBloc bloc,Key? key})
      : bloc = CounterBloc(),
        super(key: key, child: child);

  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}