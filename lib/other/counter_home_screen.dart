import 'package:meetuper_app/blocs/counter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:meetuper_app/widgets/bottom_navigation_bar.dart';

class CounterHomeScreen extends StatefulWidget {
  final String _appTitle;

  CounterHomeScreen({required String title}) : _appTitle = title;

  CounterHomeScreenState createState() {
    return CounterHomeScreenState();
  }
}

class CounterHomeScreenState extends State<CounterHomeScreen> {

  dispose(){
    counterBloc.dispose();
  }
  int _counter = 0;
  _increment() {
    counterBloc.increment(15);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: _increment,
          backgroundColor: Colors.blue,
          child: Icon(Icons.add),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(

                "Welcome to ${widget._appTitle}, let's increment numbers",
                style: TextStyle(fontSize: 16),textAlign: TextAlign.center,
              ),
              StreamBuilder(
                stream: counterBloc.counterController.stream,
                builder: (BuildContext context, AsyncSnapshot<int> snapshot){
                  if (snapshot.data != null){
                    return Text(
                        'Counter: ${snapshot.data}',
                        textDirection: TextDirection.ltr,
                        style: TextStyle(fontSize: 30.0)
                    );
                  } else {
                    return Text(
                        'Counter is sad :( No data',
                        textDirection: TextDirection.ltr,
                        style: TextStyle(fontSize: 30.0)
                    );
                  }
                },
              ),
              ElevatedButton(
                  child: StreamBuilder(
                    stream: counterBloc.counterController.stream,
                    builder:  (BuildContext context, AsyncSnapshot<int> snapshot) {
                      if (snapshot.hasData) {
                        return Text('Counter - ${snapshot.data}');
                      } else {
                        return Text('Counter is sad :(');
                      }
                    },
                  ),
                  onPressed: () => Navigator.pushNamed(context, '/meetupDetail'))
            ],
          ),
        ),
        appBar: AppBar(
          title: Text(widget._appTitle),
          centerTitle: true,
        ),
        bottomNavigationBar: BottomNavigation());
  }
}

// simple stream and builder tutorial
/*Simple stream builder tutorial
class CounterHomeScreen extends StatefulWidget {
  final String _appTitle;

  CounterHomeScreen({required String title}) : _appTitle = title;

  CounterHomeScreenState createState() {
    return CounterHomeScreenState();
  }
}

class CounterHomeScreenState extends State<CounterHomeScreen> {

  final StreamController<int> _streamController = StreamController.broadcast();
  final StreamController<int> _counterController = StreamController.broadcast();

  initState(){
    super.initState();
    _streamController.stream
        .listen((int number) {
      _counter += number;
      _counterController.sink.add(_counter);
    });
  }

  dispose(){
    _streamController.close();
    _counterController.close();
    super.dispose();
  }
  int _counter = 0;
  _increment() {
    _streamController.sink.add(15);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: _increment,
          backgroundColor: Colors.blue,
          child: Icon(Icons.add),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(

                "Welcome to ${widget._appTitle}, let's increment numbers",
                style: TextStyle(fontSize: 16),textAlign: TextAlign.center,
              ),
              StreamBuilder(
                stream: _counterController.stream,
                builder: (BuildContext context, AsyncSnapshot<int> snapshot){
                  if (snapshot.data != null){
                    return Text(
                        'Counter: ${snapshot.data}',
                        textDirection: TextDirection.ltr,
                        style: TextStyle(fontSize: 30.0)
                    );
                  } else {
                    return Text(
                        'Counter is sad :( No data',
                        textDirection: TextDirection.ltr,
                        style: TextStyle(fontSize: 30.0)
                    );
                  }
                },
              ),
              ElevatedButton(
                  child: StreamBuilder(
                    stream: _counterController.stream,
                    builder:  (BuildContext context, AsyncSnapshot<int> snapshot) {
                      if (snapshot.hasData) {
                        return Text('Counter - ${snapshot.data}');
                      } else {
                        return Text('Counter is sad :(');
                      }
                    },
                  ),
                  onPressed: () => Navigator.pushNamed(context, '/meetupDetail'))
            ],
          ),
        ),
        appBar: AppBar(
          title: Text(widget._appTitle),
          centerTitle: true,
        ),
        bottomNavigationBar: BottomNavigation());
  }
}
*/
