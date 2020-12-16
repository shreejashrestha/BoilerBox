/*
Author: BoilerBox software - Abhimanyu Agarwal, Shreeja Shrestha and Max Hansen
Date:
Title of program/source code: 'Home' page on application
Code version: v1.0
Type (e.g. computer program, source code): BoilerBox DART file
*/
/*
Description: Towards the end of the splash screen BoilerBox logo, this page is pushed onto the stack and is returned with page navigation buttons.
             These buttons correspond to Connect and Modes which enables you to use Bluetooth and explore the music player along with the mood prediction feature.
*/

//Imports
import 'package:flutter/material.dart';
import 'modesPage.dart';
import 'connectPage.dart';

//List of pages
final List<String> entries = <String>['Connect',  'Modes'];
final List pages = [ConnectPage(), ModesPage()];

//Creates the homePage widget with state status: Stateful Widget
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

//This homePage comes with an updated BoilerBox logo
class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text('BoilerBox'),
      ),
      body: SafeArea(
        child: ListView.builder(
            itemCount: 2,
            itemBuilder: (context, index) {
              return new GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => pages[index]));
                },
                child: Container(
                  margin: EdgeInsets.all(16),
                  child: Stack(
                    children: <Widget>[
                      Card(
                        elevation: 12,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        color: Colors.white,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 36),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            gradient: LinearGradient(
                                colors: [Color(0xFF000000), Color(0xFF000000)]),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Image.asset(
                                'assets/croppedlogo.png',
                                height: 100,
                                width: 100,
                              ),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      '${entries[index]}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          .copyWith(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.navigate_next,
                                size: 36,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
