/*
Author: BoilerBox Team - Max Hansen
Date: 12/11/2020
Title of program/source code: Spotify Authentication and Get Features API'
Code version: v1.0
Type (e.g. computer program, source code): Spotify Page code
*/

// Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:after_layout/after_layout.dart';
import 'dart:math';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../BluetoothFolder/newbtmain.dart' as bt;
import 'package:rx_ble/rx_ble.dart';
import '../connectPage.dart';


// Necessary variables capturing the necessary information to execute authorization
String clientId = '93e0c543afa348869842187793f7fd77';
String scopes = 'user-read-private user-read-currently-playing user-read-playback-state user-modify-playback-state';
String redirectUri = 'https://engineering.purdue.edu/477grp24/Team/progress/img/max/auth_test.html';
var currentSong = "";
var currentTitle = "";
var currentArtist = "";
String albumArt = "https://engineering.purdue.edu/477grp24/images/max/blank.jpg";
var http_client = http.Client();
String auth_url;
String authToken;
Future <bool> auth;
bool updating = false;
bool isPlaying;
bool haveToken = false;
var playPause = Icons.play_arrow_outlined;
var song = null;
var mood;
const int MUSIC = 1;
const int STANDARD = 0;
var last_song = "placeholder";

Timer timer;

Text songInfo = Text("", style: TextStyle(fontSize: 18));

class PlayerPage extends StatefulWidget
{
  @override
  _PlayerPageState createState() => _PlayerPageState();
}

TextEditingController txt;
class _PlayerPageState extends State<PlayerPage> with AfterLayoutMixin<PlayerPage>{


  @override
  Widget build(BuildContext context) {
      return
        WillPopScope(
          onWillPop: _onBackPressed,
          child: Scaffold(
            appBar: AppBar(
                title: Text("Now Playing"),
                backgroundColor: Colors.black
            ),
            backgroundColor: Colors.black,
            body: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10),
                    Container(child: Image.network(albumArt),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white,
                            width: 30,
                          ),
                        )),
                    Spacer(),
                    Container(
                        child: Column(

                            children: [
                              SingleChildScrollView(
                                child: songInfo,
                                scrollDirection: Axis.horizontal,),
                              Text("by $currentArtist", style: TextStyle(color: Colors.white), textAlign: TextAlign.center,),]
                        )
                    ),
                    Spacer(),

                    Center(child: Row( mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ButtonTheme(
                          minWidth: 10,
                          height: 10,
                          child: IconButton(
                              onPressed: () {
                                prevTrack(authToken);
                              },
                              iconSize: 75,
                              icon: Icon(Icons.skip_previous_outlined,  color: Colors.white)),
                        ),
                        RaisedButton(
                            onPressed: () {
                              if (!updating && !haveToken)
                              {
                                new Timer.periodic(Duration(milliseconds: 250), (Timer t) => setState((){
                                  getSong(authToken);
                                  songInfo = Text("$currentTitle", style: TextStyle(fontSize: 18, color: Colors.white));
                                  updating = true;
                                }));
                              }
                              if (!isPlaying)
                              {
                                resumePlayback(authToken);
                              }
                              else
                              {
                                pausePlayback(authToken);
                              }
                            },
                            color: Colors.white,
                            shape: CircleBorder(),
                            child:  Icon(playPause, size: 100)),
                        ButtonTheme(
                          minWidth: 10,
                          height: 10,
                          child: IconButton(
                              onPressed: () {
                                nextTrack(authToken);
                              },
                              iconSize: 75,
                              icon: Icon(Icons.skip_next_outlined,  color: Colors.white)),
                        ),
                      ],
                    )
                    ),
                    Spacer(),
                  ],
                )
            ),
          )
        );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    // Calling the same function "after layout" to resolve the issue.
    if (haveToken && !updating && bt.connectionState == BleConnectionState.connected) {
      //mode = MUSIC;
      //loadModel();
      timer = new Timer.periodic(Duration(milliseconds: 250), (Timer t) =>

                  setState(() {
                    getSong(authToken);
                    if (currentSong != last_song)
                      {
                        //New song predict mood
                        getFeatures(authToken);
                        getMood();
                        last_song = currentSong;
                      }
                    getFeatures(authToken);
                    songInfo = Text("$currentTitle",
                        style: TextStyle(fontSize: 18, color: Colors.white));
                    updating = true;
                  }));
    }
    else if (!haveToken || bt.connectionState != BleConnectionState.connected)
      {
        _showMyDialog();
      }
  }
  Future<bool> _onBackPressed() async {
    print("Back Pressed");
    updating = false;
    mood = null;
    pausePlayback(authToken);
    timer.cancel();
    Navigator.pop(context);

  }
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Connect Spotify'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('You must connect Spotify & Bluetooth first!'),
                Text('Press continue to go to connections'),
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
                //Navigator.of(context).pop();
                //Navigator.pop(context);
                if (!updating)
                  {
                    timer = new Timer.periodic(Duration(milliseconds: 250), (Timer t) =>

                        setState(() {
                          getSong(authToken);
                          if (currentSong != last_song)
                          {
                            //New song predict mood
                            getMood();
                            last_song = currentSong;
                          }
                          songInfo = Text("$currentTitle",
                              style: TextStyle(fontSize: 18, color: Colors.white));
                          updating = true;
                        }));
                  }
              },
            ),
          ],
        );
      },
    );
  }

  void getSong(String accessToken) async
  {
    var response = await http_client.get("https://api.spotify.com/v1/me/player/currently-playing?market=US", headers: {'Authorization':'Bearer $accessToken'});

    Map<String, dynamic> all = jsonDecode(response.body);
    try{
      currentTitle = all['item']['name'].toString();
      currentArtist = all['item']['artists'][0]['name'].toString();
      currentSong = all['item']['id'].toString();
      albumArt = all['item']['album']['images'][0]['url'].toString();
      isPlaying = all['is_playing'];
      if (isPlaying)
      {
        playPause = Icons.pause;
      }
      else
      {
        playPause = Icons.play_arrow_outlined;
      }

      songInfo = Text("$currentTitle", style: TextStyle(fontSize: 18, color: Colors.white));
    }
    catch (e)
    {
    }
  }

  Future<List> getFeatures(String accessToken) async
  {
    var response = await http_client.get("https://api.spotify.com/v1/audio-features/$currentSong", headers: {'Authorization':'Bearer $accessToken'});
    Map<String, dynamic> all = jsonDecode(response.body);

    var danceability = all['danceability'];
    var energy = all['energy'];
    var loudness = all['loudness'];
    var speechiness = all['speechiness'];
    var acousticness = all['acousticness'];
    var instrumentalness = all['instrumentalness'];
    var liveness = all['liveness'];
    var valence = all['valence'];
    var tempo = all['tempo'];
    var duration_ms = all['duration_ms'];



    var song1 = [danceability, energy, loudness, speechiness, acousticness, instrumentalness, liveness, valence, tempo, duration_ms];

    return song1;
  }

  void pausePlayback(String authToken) async
  {
    var response = await http_client.put("https://api.spotify.com/v1/me/player/pause", headers: {'Authorization':'Bearer $authToken'});
    printWrapped(response.body);
  }

  void resumePlayback(String authToken) async
  {
    var response = await http_client.put("https://api.spotify.com/v1/me/player/play", headers: {'Authorization':'Bearer $authToken'});
    printWrapped(response.body);
    getSong(authToken);
  }

  void nextTrack(String authToken) async
  {
    var response = await http_client.post("https://api.spotify.com/v1/me/player/next", headers: {'Authorization':'Bearer $authToken'});

    //sleep(Duration(milliseconds: 500));

    printWrapped(response.body);

    getSong(authToken);

  }

  void prevTrack(String authToken) async
  {
    var response = await http_client.post("https://api.spotify.com/v1/me/player/previous", headers: {'Authorization':'Bearer $authToken'});
    printWrapped(response.body);
    getSong(authToken);
  }

  Future<String> getMood() async {
    getSong(authToken);
    final track = await getFeatures(authToken);
    Socket s = await Socket.connect("172.104.6.100", 4040);
    bt.text = "MP";
    await RxBle.writeChar(
      bt.deviceId,
      "FF01",
      RxBle.stringToChar(bt.text),
    );
    s.add(utf8.encode(track.toString()));
    final response = await s.close().then((response){
      response.cast<List<int>>().transform(utf8.decoder).listen((content){
        mood = content;
        sendMood(content);
        return content;});
    });

    return response;
  }

}

//Future <WebViewController> _controller;
Future <String> currentUrl;
WebViewController webController;
BuildContext webContext;

class WebViewPage1 extends StatelessWidget {
  @override


  Widget build(webContext) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Connect Spotify"),
        backgroundColor: Colors.black,
      ),
      body: Center(
          child: WebView(initialUrl: getAuthorizationUrl(clientId, redirectUri, scopes, getState()),
              javascriptMode: JavascriptMode.unrestricted,

              onWebViewCreated: (webController) async {

                String s = await webController.getTitle();
                while (s != 'Max Hansen Progress Reports')
                {
                  s = await webController.getTitle();
                }
                currentUrl =webController.currentUrl();
                currentUrl.then((s) {authToken = extractToken(s); if (authToken.isNotEmpty) {haveToken = true;}});
                Navigator.pop(webContext);
              })
      ),
    );
  }
}

String getState() {
  String seed = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890abcdefghijklmnoqrstuvwxyz';
  StringBuffer sb = new StringBuffer();
  Random r = new Random();
  for (int i = 0; i < 20; i++) {
    sb.write(seed[r.nextInt(seed.length)]);
  }
  return sb.toString();
}

String getAuthorizationUrl(String clientId, String redirectUri, String scopes, String state) {
  return 'https://accounts.spotify.com/authorize?response_type=token&client_id=$clientId' '&scope=$scopes&redirect_uri=$redirectUri&state=$state';
}

extractToken(String auth_url)
{
  RegExp exp = new RegExp(r'#access_token=+[A-Za-z0-9_-]*');
  var token = exp.firstMatch(auth_url).group(0).substring(14);
  return token;
}

void printWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

Future sleep1() {
  return new Future.delayed(const Duration(milliseconds: 750));
}

void sendMood(String mood) async
{
  if (mood == "0")
    {
      print("${currentTitle} is a sad song.\n");
      bt.text = "MS";
      await RxBle.writeChar(
        bt.deviceId,
        "FF01",
        RxBle.stringToChar(bt.text),
      );
    }
  else if (mood == "1")
    {
      print("${currentTitle} is a happy song.\n");
      bt.text = "MH";
      await RxBle.writeChar(
        bt.deviceId,
        "FF01",
        RxBle.stringToChar(bt.text),
      );
    }
  else if (mood == "2")
    {
      print("${currentTitle} is a chill song.\n");
      bt.text = "MC";
      await RxBle.writeChar(
        bt.deviceId,
        "FF01",
        RxBle.stringToChar(bt.text),
      );
    }
  else if (mood == "3")
    {
      print("${currentTitle} is a energetic song.\n");
      bt.text = "ME";
      await RxBle.writeChar(
        bt.deviceId,
        "FF01",
        RxBle.stringToChar(bt.text),
      );
    }
}


