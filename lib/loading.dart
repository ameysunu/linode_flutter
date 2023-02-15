import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:linode_flutter/controllers/linodedb.dart';
import 'package:linode_flutter/spotify_list.dart';
import 'package:rive/rive.dart';

import 'controllers/generator.dart';
import 'controllers/spotify.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key, required this.response});

  final Future<dynamic> response;

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  String _text = "We are processing your data, hang on!";

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 10), () {
      setState(() {
        _text = "Our robots are working their magic, just a little bit longer.";
      });
    });
    Future.delayed(Duration(seconds: 20), () {
      setState(() {
        _text = "This is unexpectedly taking a little longer.";
      });
    });
  }

  Widget build(BuildContext context) {
    const textColor = const Color(0xFFB392E4F);

    return Scaffold(
      body: FutureBuilder(
        future: widget.response,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  leading: BackButton(
                    color: textColor,
                  ),
                ),
                // body: Container(
                //   child: Center(
                //     child: Text(snapshot.data.toString(),
                //         style: GoogleFonts.manrope(
                //           textStyle: TextStyle(color: textColor, fontSize: 20),
                //         )),
                //   ),
                // ),
                body: ResultWidget(data: snapshot.data));
          } else if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                leading: BackButton(
                  color: textColor,
                ),
              ),
              body: Container(
                child: Center(
                  child: Text("An error has occurred"),
                ),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Container(
                    height: MediaQuery.of(context).size.height * 0.75,
                    child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.75,
                        child: RiveAnimation.asset('assets/loader.riv'))),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    _text,
                    style: GoogleFonts.manrope(
                        textStyle: TextStyle(color: textColor, fontSize: 20)),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class ResultWidget extends StatefulWidget {
  const ResultWidget({super.key, required this.data});

  final String data;

  @override
  State<ResultWidget> createState() => _ResultWidgetState();
}

class _ResultWidgetState extends State<ResultWidget> {
  var sentence;
  var emotion;
  late Future<List<dynamic>> responseFuture;
  var _fabUpdated = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sentence = generatorSentence(widget.data);
    // fetchTracks(widget.data).then((tracks) {
    //   setState(() {
    //     list_tracks = tracks;
    //   });
    // });
    emotion = emotionWord(widget.data);
    responseFuture = fetchTracks(emotion);
    print(FirebaseAuth.instance.currentUser?.uid);
    initializeDB();
  }

  @override
  Widget build(BuildContext context) {
    const textColor = const Color(0xFFB392E4F);
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Builder(builder: (context) {
            if (widget.data == 'No face found, please try again.') {
              return Container(
                child: Center(
                  child: Text(widget.data,
                      style: GoogleFonts.manrope(
                        textStyle: TextStyle(color: textColor, fontSize: 20),
                      )),
                ),
              );
            }
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(widget.data,
                    //     style: GoogleFonts.manrope(
                    //       textStyle: TextStyle(color: textColor, fontSize: 20),
                    //     )),
                    Text(sentence,
                        style: GoogleFonts.manrope(
                          textStyle: TextStyle(color: textColor, fontSize: 25),
                        )),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                          'Here are some songs for you, just for your mood',
                          style: GoogleFonts.manrope(
                            textStyle:
                                TextStyle(color: textColor, fontSize: 17),
                          )),
                    ),
                    // SingleChildScrollView(
                    //   child: list_tracks != null
                    //       ? SpotifyWidget(tracks: list_tracks)
                    //       : Container(),
                    // ),
                    FutureBuilder(
                      future: responseFuture,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return SpotifyWidget(tracks: snapshot.data!);
                        } else if (snapshot.hasError) {
                          return Text("Error loading image");
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
        floatingActionButton: _fabUpdated
            ? FloatingActionButton.extended(
                backgroundColor: textColor,
                onPressed: () async {
                  List<dynamic> data = await responseFuture;
                  String dataString = data.join(', ');
                  var insertionKey = generateInsertionKey();
                  addDatatoDB(
                      FirebaseAuth.instance.currentUser?.uid,
                      DateTime.now().toString().substring(0, 10),
                      widget.data,
                      insertionKey);
                  setState(() {
                    _fabUpdated = false;
                  });
                  data.forEach((item) {
                    //addSongtoDB(userid, name, img, artist, url)
                    addSongtoDB(
                        FirebaseAuth.instance.currentUser?.uid,
                        item['name'],
                        item['album']['images'][0]['url'],
                        item['artists'][0]['name'],
                        item['external_urls']['spotify'],
                        DateTime.now().toString().substring(0, 10),
                        insertionKey);
                  });
                },
                icon: Icon(Icons.music_note),
                label:
                    Text('Save this playlist?', style: GoogleFonts.manrope()),
              )
            : FloatingActionButton(
                backgroundColor: Colors.green,
                onPressed: null,
                child: Icon(Icons.check),
              ));
  }
}
