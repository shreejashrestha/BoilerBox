import 'package:flutter/material.dart';

final List<String> entries = <String>[
  'Connect',
  'Modes',
  'Settings',
  'Profile'
];

class SpotifyPage extends StatefulWidget {
  SpotifyPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _SpotifyPage createState() => _SpotifyPage();
}

class _SpotifyPage extends State<SpotifyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text('Spotify'),
      ),
    );
  }
}
