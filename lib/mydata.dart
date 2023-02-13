import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linode_flutter/controllers/linodedb.dart';

class MyData extends StatefulWidget {
  const MyData({super.key});

  @override
  State<MyData> createState() => _MyDataState();
}

class _MyDataState extends State<MyData> {
  late Future<List<dynamic>> responseFuture;

  @override
  void initState() {
    super.initState();
    responseFuture = getDataFromDB(FirebaseAuth.instance.currentUser?.uid);
  }

  @override
  Widget build(BuildContext context) {
    const textColor = const Color(0xFFB392E4F);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(
          color: textColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('All your saved music and mood content!',
                  style: GoogleFonts.manrope(
                      textStyle: TextStyle(color: textColor, fontSize: 30))),
              Text(
                "We've saved all your music playlist for various moods, right here.",
                style: GoogleFonts.manrope(
                    textStyle: TextStyle(color: textColor, fontSize: 15)),
              ),
              FutureBuilder(
                future: responseFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: snapshot.data!.map((data) {
                        return Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Text(
                                      data['mood']
                                              .toString()
                                              .substring(0, 1)
                                              .toUpperCase() +
                                          data['mood'].toString().substring(1),
                                      style: GoogleFonts.manrope(
                                          textStyle: TextStyle(
                                              color: textColor, fontSize: 20))),
                                ),
                                Text(data['date'].toString(),
                                    style: GoogleFonts.manrope(
                                        textStyle: TextStyle(
                                            color: textColor, fontSize: 20)))
                              ],
                            ),
                            Spacer(),
                            IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DataWidget(
                                        date: data['date'].toString(),
                                        mood: data['mood']
                                                .toString()
                                                .substring(0, 1)
                                                .toUpperCase() +
                                            data['mood']
                                                .toString()
                                                .substring(1),
                                        songs: data['songs'],
                                        images: data['images'],
                                        urls: data['url'],
                                        artists: data['artists'],
                                      ),
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.arrow_forward_ios,
                                  color: textColor,
                                ))
                          ],
                        );
                      }).toList(),
                    );
                  } else if (snapshot.hasError) {
                    return Text("Error loading data");
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DataWidget extends StatefulWidget {
  final String date;
  final String mood;
  final String songs;
  final String images;
  final String urls;
  final String artists;

  const DataWidget(
      {super.key,
      required this.date,
      required this.mood,
      required this.songs,
      required this.images,
      required this.urls,
      required this.artists});

  @override
  State<DataWidget> createState() => _DataWidgetState();
}

class _DataWidgetState extends State<DataWidget> {
  @override
  late List<String> songList;
  initState() {
    String songs = widget.songs;
    songList = songs.split(', ');
    print(songList);
  }

  Widget build(BuildContext context) {
    const textColor = const Color(0xFFB392E4F);

    return Scaffold(
        appBar: AppBar(
      title: Text(
        '${widget.mood} songs from ${widget.date}',
        style: GoogleFonts.manrope(textStyle: TextStyle(color: textColor)),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      leading: BackButton(
        color: textColor,
      ),
    ));
  }
}
