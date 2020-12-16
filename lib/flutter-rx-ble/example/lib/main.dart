import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rx_ble/rx_ble.dart';

String text= "";

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Connect Bluetooth'),
        ),
        body: MyApp(),
      ),
    ),
  );
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

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var returnValue;
  String deviceId;
  Exception returnError;
  final results = <String, ScanResult>{};
  var chars = Map<String, List<String>>();
  final writeCharValueControl = TextEditingController();
  var connectionState = BleConnectionState.disconnected;
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
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: <Widget>[
              RaisedButton(
                child: Text(
                  "Enable Bluetooth",
                ),
                onPressed: wrapCall(RxBle.requestAccess),
              ),
              Divider(),
              RaisedButton(
                child: Text(
                  "Scan Devices",
                ),
                onPressed: wrapCall(startScan),
              ),
              Divider(),

              if (results.isEmpty)
                //Text('Start scanning to connect to BoilerBox'),
              Text("Select Device"),
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
                  }),
                ),
              Divider(),
              if (connectionState != BleConnectionState.connected)
                Text("You are not currently connected.")
              else ...[
                RaisedButton(
                  child: Text(
                    "Disconnect",
                  ),
                  onPressed: wrapCall(RxBle.disconnect),
                ),
                Divider(),
                TextField(
                  controller: writeCharValueControl,
                  decoration: InputDecoration(
                    labelText: "Data to send",
                  ),
                ),
                RaisedButton(
                  child: Text(
                    "Send data",
                  ),
                  onPressed: wrapCall(writeChar),
                ),
              ],
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            if (isWorking) LinearProgressIndicator(value: null),
          ],
        ),
      ],
    );
  }
}
