/*
Author: BoilerBox Team - Abhimanyu Agarwal, Max Hansen and Shreeja Shrestha
Date: 12/11/2020
Title of program/source code: 'Modes' page with two modes - Standard and Music
Code version: v1.0
Type (e.g. computer program, source code): BoilerBox DART file
*/
/*
Description: Comprises 2 modes that the user can choose from.
             On selecting one of the specific modes, the user can
             enjoy the preset modes along with the light show
*/

//Imports
import 'package:flutter/material.dart';
import 'package:rx_ble/rx_ble.dart';
import 'flutter_circle_color_picker.dart';
import 'SpotifyFolder/spotifymain.dart';
import 'BluetoothFolder/newbtmain.dart' as bt;
import 'package:after_layout/after_layout.dart';
import 'connectPage.dart';
import 'dart:async';

//Variables
Color user_color = Colors.purple;
Color user_color1 = Colors.purple;
Color user_color2 = Colors.purple;
Color user_color3 = Colors.purple;
Color user_color4 = Colors.purple;
double speed_slider = 100.0;
Color sent_color;
int speed = 100;
var isSelected = [false, false, false, false, false, false, false, false];
Timer timer;

class ModesPage extends StatefulWidget {
  @override
  _ModesPageState createState() => _ModesPageState();
}

class _ModesPageState extends State<ModesPage>
{
  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return Scaffold(
      appBar: AppBar(
          title: Text("Modes"),
          backgroundColor: Colors.black
      ),
      backgroundColor: Colors.black,
      body:
        Center(
          child:
          Column(
            children:
              [
                Center(
                    child:
                    IconButton(
                      icon: Icon(Icons.music_note_outlined, color: Colors.white),
                      iconSize: 275,
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PlayerPage()));
                      },

                )),
                Text("Music Mode", style: TextStyle(color: Colors.white)),
                Center(
                    child:
                    IconButton(
                      icon: Icon(Icons.lightbulb_outline, color: Colors.white),
                      iconSize: 275,
                      onPressed: () {
                        //mode = STANDARD;
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => StandardMode()));
                      },

                    )),
                Text("Standard Mode", style: TextStyle(color: Colors.white)),
              ]
          )
        ),
    );
  }
}

class StandardMode extends StatefulWidget {
  @override
  _StandardModeState createState() => _StandardModeState();
}

class _StandardModeState extends State<StandardMode> with AfterLayoutMixin<StandardMode>
{
  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return Scaffold(
      appBar: AppBar(
          title: Text("Standard Mode"),
          backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body:
      Center(
          child:
          Column(
              children:
              [
                CircleColorPicker(
                  initialColor: Colors.purple,
                  onChanged: (color) async {
                    user_color = color;
                  },
                  size: const Size(240, 240),
                  strokeWidth: 4,
                  thumbSize: 36,
                  textStyle: TextStyle(color: Colors.white),
                ),
                Spacer(),
                Center(
                  child:
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ButtonTheme(
                      minWidth: 75,
                      height: 75,
                      shape: CircleBorder(),
                      child:
                      RaisedButton(
                        shape: CircleBorder(),
                        color: user_color1,
                        child: Text("Color 1"),
                        onPressed: () async {
                          //send
                          user_color1 = user_color;
                          user_color2 = user_color;
                          user_color3 = user_color;
                          user_color4 = user_color;
                          print("Color: $user_color");
                          String red = user_color.red.toString();
                          String green = user_color.green.toString();
                          String blue = user_color.blue.toString();
                          String color_str = get_color_text(red, green, blue);
                          bt.text = "UC1$color_str";
                          setState(() {
                          });
                          await RxBle.writeChar(
                            bt.deviceId,
                            "FF01",
                            RxBle.stringToChar(bt.text),
                          );
                        },
                      ),
                    ),
                    ButtonTheme(
                      minWidth: 75,
                      height: 75,
                      shape: CircleBorder(),
                      child:
                      RaisedButton(
                        shape: CircleBorder(),
                        color: user_color2,
                        child: Text("Color 2"),
                        onPressed: () async {
                          //send
                          user_color2 = user_color;
                          user_color3 = user_color;
                          user_color4 = user_color;
                          print("Color: $user_color");
                          String red = user_color.red.toString();
                          String green = user_color.green.toString();
                          String blue = user_color.blue.toString();
                          String color_str = get_color_text(red, green, blue);
                          bt.text = "UC2$color_str";
                          setState(() {
                          });
                          await RxBle.writeChar(
                            bt.deviceId,
                            "FF01",
                            RxBle.stringToChar(bt.text),
                          );
                        },
                      ),
                    ),
                    ButtonTheme(
                      minWidth: 75,
                      height: 75,
                      shape: CircleBorder(),
                      child:
                      RaisedButton(
                        shape: CircleBorder(),
                        color: user_color3,
                        child: Text("Color 3"),
                        onPressed: () async {
                          //send
                          user_color3 = user_color;
                          user_color4 = user_color;
                          print("Color: $user_color");
                          String red = user_color.red.toString();
                          String green = user_color.green.toString();
                          String blue = user_color.blue.toString();
                          String color_str = get_color_text(red, green, blue);
                          bt.text = "UC3$color_str";
                          setState(() {
                          });
                          await RxBle.writeChar(
                            bt.deviceId,
                            "FF01",
                            RxBle.stringToChar(bt.text),
                          );
                        },
                      ),
                    ),
                    ButtonTheme(
                      minWidth: 75,
                      height: 75,
                      shape: CircleBorder(),
                      child:
                      RaisedButton(
                        shape: CircleBorder(),
                        color: user_color4,
                        child: Text("Color 4"),
                        onPressed: () async {
                          //send
                          user_color4 = user_color;
                          print("Color: $user_color");
                          String red = user_color.red.toString();
                          String green = user_color.green.toString();
                          String blue = user_color.blue.toString();
                          String color_str = get_color_text(red, green, blue);
                          bt.text = "UC4$color_str";
                          setState(() {
                          });
                          await RxBle.writeChar(
                            bt.deviceId,
                            "FF01",
                            RxBle.stringToChar(bt.text),
                          );
                        },
                      ),
                    ),
                  ]
                )),
                SizedBox(
                  height: 5,
                ),
                Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      ButtonTheme(
                        minWidth: 75,
                        height: 75,
                        shape: CircleBorder(),
                        child: RaisedButton(
                            color: Colors.white,
                            onPressed: () async
                          {
                            bt.text = "B1";
                            await RxBle.writeChar(
                              bt.deviceId,
                              "FF01",
                              RxBle.stringToChar(bt.text),
                            );
                          },
                            child: Text("Mode 1"),
                      ),
                    ),
                        ButtonTheme(
                          minWidth: 75,
                          height: 75,
                          shape: CircleBorder(),
                          child: RaisedButton(
                            color: Colors.white,
                            onPressed:  () async
                            {
                              bt.text = "B2";
                              await RxBle.writeChar(
                                bt.deviceId,
                                "FF01",
                                RxBle.stringToChar(bt.text),
                              );
                            },
                            child: Text("Mode 2"),
                          ),
                        ),
                        ButtonTheme(
                          minWidth: 75,
                          height: 75,
                          shape: CircleBorder(),
                          child: RaisedButton(
                            color: Colors.white,
                            onPressed:  () async
                            {
                              bt.text = "B3";
                              await RxBle.writeChar(
                                bt.deviceId,
                                "FF01",
                                RxBle.stringToChar(bt.text),
                              );
                            },
                            child: Text("Mode 3"),
                          ),
                        ),
                        ButtonTheme(
                          minWidth: 75,
                          height: 75,
                          shape: CircleBorder(),
                          child: RaisedButton(
                            color: Colors.white,
                            onPressed: () async{
                              bt.text = "B4";
                              await RxBle.writeChar(
                                bt.deviceId,
                                "FF01",
                                RxBle.stringToChar(bt.text),
                              );
                            },
                            child: Text("Mode 4"),
                          ),
                        ),

                  ],

                )),
                SizedBox(
                  height: 5,
                ),
                Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ButtonTheme(
                          minWidth: 75,
                          height: 75,
                          shape: CircleBorder(),
                          child: RaisedButton(
                            color: Colors.white,
                            onPressed:  () async
                            {
                              bt.text = "B5";
                              await RxBle.writeChar(
                                bt.deviceId,
                                "FF01",
                                RxBle.stringToChar(bt.text),
                              );
                            },
                            child: Text("Mode 5"),
                          ),
                        ),
                        ButtonTheme(
                          minWidth: 75,
                          height: 75,
                          shape: CircleBorder(),
                          child: RaisedButton(
                            color: Colors.white,
                            onPressed:  () async
                            {
                              bt.text = "B6";
                              await RxBle.writeChar(
                                bt.deviceId,
                                "FF01",
                                RxBle.stringToChar(bt.text),
                              );
                            },
                            child: Text("Mode 6"),
                          ),
                        ),
                        ButtonTheme(
                          minWidth: 75,
                          height: 75,
                          shape: CircleBorder(),
                          child: RaisedButton(
                            color: Colors.white,
                            onPressed:  () async
                            {
                              bt.text = "B7";
                              await RxBle.writeChar(
                                bt.deviceId,
                                "FF01",
                                RxBle.stringToChar(bt.text),
                              );
                            },
                            child: Text("Mode 7"),
                          ),
                        ),
                        ButtonTheme(
                          minWidth: 75,
                          height: 75,
                          shape: CircleBorder(),
                          child: RaisedButton(
                            color: Colors.white,
                            onPressed:  () async
                            {
                              bt.text = "B8";
                              await RxBle.writeChar(
                                bt.deviceId,
                                "FF01",
                                RxBle.stringToChar(bt.text),
                              );
                            },
                            child: Text("Mode 8"),
                          ),
                        ),

                      ],

                    )),
                Spacer(),
                SizedBox(
                    width: 350,
                    child: Text("Speed", style: TextStyle(color: Colors.white))
                ),
                Slider(
                  value: speed_slider,
                  activeColor: Colors.white,
                  inactiveColor: Colors.grey,
                  min: 0,
                  max: 100,
                  divisions: 100,
                  label: speed.toString(),
                  onChanged: (double value) async {
                    setState(() {
                      speed_slider = value.roundToDouble();
                      speed = value.round();
                      bt.text = "US$speed";

                    });
                    await RxBle.writeChar(
                      bt.deviceId,
                      "FF01",
                      RxBle.stringToChar(bt.text),
                    );

                  },
                ),
              Spacer()
              ]
          )


      ),

    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    // Calling the same function "after layout" to resolve the issue.
    if (bt.connectionState == BleConnectionState.connected) {
      //mode = STANDARD;
      /*
      do nothing, just for debugging
       */
    }
    else
    {
      _showMyDialog();
    }
  }
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Connect Bluetooth'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('You must connect Bluetooth First!'),
                Text('Press continue to go to connections.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Continue'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ConnectPage()));
              },
            ),
          ],
        );
      },
    );
  }
}

//Building strings to send to the ESP32 MCU
String get_color_text(String r, String g, String b)
{
  while(r.length != 3)
    {
      r = "0"+r;
    }
  while(g.length != 3)
  {
    g = "0"+g;
  }
  while(b.length != 3)
  {
    b = "0"+b;
  }
  return r + g + b;
}