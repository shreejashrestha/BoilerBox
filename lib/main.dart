import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: FirstScreen(),
      ),
      routes: {
        '/second' :(context) => SecondScreen(),
      },
    ),
  );
}

class FirstScreen extends StatefulWidget {
  @override
  State<FirstScreen> createState() {
    return FirstScreenState();
  }
}

class FirstScreenState extends State<FirstScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('BoilerBox'),
      ),
      body: Align(
        alignment: Alignment(0.0, 0.7),   //This alignment is (0.0, 1.0)
        child: RaisedButton(
          child: Text('Press to start',
          style: TextStyle(fontSize: 30.0, color: Colors.black),
          ),
          onPressed: () {
            // Navigate to the second screen using a named route
            Navigator.pushNamed(context, '/second');
          },
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Feature Screen"),
      ),
      body: Align(
        alignment: Alignment(0.7,0.7),
        child: RaisedButton(
          onPressed: () {
            // Navigate back to the first screen by popping the current route
            // off the stack
//            Navigator.pop(context);
          },
          child: Text('Connect',
            style: TextStyle(fontSize: 30.0),
          ),
        ),
      ),
    );
  }
}


class BoilerBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: 150.0,
      width: 500.0,
      child: Center(
        child: Text(
          'Smart LED System',
          style: TextStyle(fontSize: 30.0, color: Colors.white),
        ),
      ),
    );
  }
}
