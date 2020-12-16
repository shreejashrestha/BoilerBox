/*
  This file is modified version of an example found online
  https://github.com/scientifichackers/flutter-rx-ble/blob/master/example/lib/main.dart
  Author: Dev Aggarwal (on github)
  Date: April 13th 2020
  "flutter-rx-ble-example"
*/
/*
Description : This file is used by BoilerBox to facilitate Bluetooth low energy connection.
            This is the updated Bluetooth connection after it was conclude that
            the previous bluetooth instance was not giving optimal performance
            when playing music and changing LED colors synchronously.
*/

//Imports
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:rx_ble/rx_ble.dart';


String text= "";
String deviceId;
var connectionState = BleConnectionState.disconnected;
class BluetoothPage extends StatefulWidget {
  @override
  _BluetoothPageState createState() => _BluetoothPageState();
}
class _BluetoothPageState extends State<BluetoothPage> {
  var returnValue;
  Exception returnError;
  final results = <String, ScanResult>{};
  var chars = Map<String, List<String>>();
  final writeCharValueControl = TextEditingController();
  var isWorking = false;
  Function wrapCall(Function fn) {
    return () async {
      var value, error;
      setState(() {
        returnError = returnValue = null;
        isWorking = true;
      });
      try {
        text = writeCharValueControl.text;
        value = await fn();
        print('returnValue: $value');
      } catch (e, trace) {
        print('returnError: $e\n$trace');
        error = e;
      } finally {
        if (mounted) {
          setState(() {
            isWorking = false;
            returnError = error;
            returnValue = value;
          });
        }
      }
    };
  }
  Future<void> startScan() async {
    await for (final scanResult in RxBle.startScan()) {
      results[scanResult.deviceId] = scanResult;
      if (!mounted) return;
      setState(() {
        returnValue = JsonEncoder.withIndent(" " * 2, (o) {
          if (o is ScanResult) {
            return o.toString();
          } else {
            return o;
          }
        }).convert(results);
      });
    }
  }
  Future<void> writeChar() async {
    return await RxBle.writeChar(
      deviceId,
      "FF01",
      RxBle.stringToChar(text),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text('Bluetooth'),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child:
                IconButton(
                  icon: Icon(Icons.bluetooth, color: Colors.black),
                  iconSize: 200,
                  onPressed: (wrapCall(RxBle.requestAccess)),
                )),
            Center(
              child: IconButton(
                icon: Icon(Icons.scanner, color: Colors.black),
                iconSize: 200,
                onPressed: (wrapCall(startScan)),
              )),
            if (results.isEmpty)
              Text("Select Device", style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  decoration: TextDecoration.none)),
            for (final scanResult in results.values)
              if(scanResult.deviceName == "ESP_COEX_BLE_DEMO")
                RaisedButton(
                  child: Text(
                    "BoilerBox",
                  ),
                  onPressed: wrapCall(() async {
                    await RxBle.stopScan();
                    setState(() {
                      deviceId = scanResult.deviceId;
                    });
                    await for (final state in RxBle.connect(deviceId)) {
                      print("device state: $state");
                      if (!mounted) return;
                      setState(() {
                        connectionState = state;
                      });
                    }
                  }
                  ),
                ),
            if (connectionState != BleConnectionState.connected)
              Text("You are not currently connected.", style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  decoration: TextDecoration.none))
            else
              ...[
                RaisedButton(
                  child: Text(
                    "Disconnect",
                  ),
                  onPressed: wrapCall(RxBle.disconnect),
                ),
              ],
          ],
        ),
      ),
    );
  }
}
class YesNoDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Location Permission Required'),
      content: Text(
        "This app needs location permission in order to access Bluetooth.\n"
            "Continue?",
      ),
      actions: <Widget>[
        SimpleDialogOption(
          child: Text(
            "NO",
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        SimpleDialogOption(
          child: Text(
            "YES",
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        )
      ],
    );
  }
}