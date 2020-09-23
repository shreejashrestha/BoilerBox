import 'package:flutter/material.dart';
import 'homePage.dart';
import 'dart:async';

class loadingPage extends StatefulWidget {
  @override
  _loadingPageState createState() => _loadingPageState();
}

class _loadingPageState extends State<loadingPage> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MyHomePage(title: 'BoilerBox'),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,

        //Could add boilerbox picture
        child: FlutterLogo(size: MediaQuery.of(context).size.height));
  }
}
