/*
Author: BoilerBox Team - Abhimanyu Agarwal, Shreeja Shrestha and Max Hansen
Title of program/source code: 'Home' page on application
Code version: v1.0
Type (e.g. computer program, source code): BoilerBox DART file
*/
/*
Description : Creates the main application instance and widgets.
              Serves as the root of the BoilerBox application
*/

import 'package:flutter/material.dart';
import 'loadingPage.dart';
import 'package:flutter/services.dart';

void main()
{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget
{
  // This widget is the root of the BoilerBox application.
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: loadingPage());
  }
}
