import 'package:flutter/material.dart';
// import 'package:spotify/spotify.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

//class of track. holds returned info
class Track {
  // final int id;
  // final String uri;
  final String punchline;

  Track(this.punchline);

  Track.fromJson(Map<String, dynamic> json)
      // : id = json['id'],
      // uri = json['uri'],
      : punchline = json['punchline'];

  Map<String, dynamic> toJson() => {
        // 'id': id,
        'punchline': punchline,
        // 'uri': uri,
      };
}

// http get. returns converted json into dart class
Future<Track> fetchTrack() async {
  final response =
      await http.get('https://official-joke-api.appspot.com/random_joke');

  Map trackMap = jsonDecode(response.body);
  var track = Track.fromJson(trackMap);

  return track;
}

class SpotifyPage extends StatefulWidget {
  SpotifyPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _SpotifyPage createState() => _SpotifyPage();
}

// page
class _SpotifyPage extends State<SpotifyPage> {
  Future<Track> futureTrack;

  @override
  void initState() {
    super.initState();
    futureTrack = fetchTrack();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          title: Text('Fetch Data'),
        ),
        body: Center(
          child: FutureBuilder<Track>(
            future: futureTrack,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data.punchline);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
