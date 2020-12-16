/*
Author: BoilerBox Team - Abhimanyu Agarwal, Shreeja Shrestha and Max Hansen
Date: 12/11/2020
Title of program/source code: 'Loading' page on application
Code version: v1.0
Type (e.g. computer program, source code): BoilerBox DART file
*/
/*
Description : Creates the loadingPage with the BoilerBox official logo appearing for 3 seconds,
              and then navigates onto the homePage
*/


//Imports
import 'package:flutter/material.dart';
import 'homePage.dart';
import 'dart:async';

//Creates the loadingPage with the BoilerBox official logo appearing for 3 seconds,
//and then navigates onto the homePage
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
              builder: (BuildContext context) => MyHomePage(title: 'BoilerBox'),
            )
        )
    );
  }

  //Builds the splash screen 'BoilerBox' logo
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        //Here is the logo.
        child: Image.asset('assets/boilerboxlogo.png'),
      ),
    );
  }
}