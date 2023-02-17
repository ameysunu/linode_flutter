import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linode_flutter/controllers/linodedb.dart';
import 'package:url_launcher/url_launcher.dart';

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
    //responseFuture = getDataFromDB(FirebaseAuth.instance.currentUser?.uid);
    responseFuture = getMoodsFromDB(FirebaseAuth.instance.currentUser?.uid);
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
                              onPressed: () async {
                                print(data['insertion_key']);
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return StatefulBuilder(
                                      builder: (BuildContext context,
                                          StateSetter setState) {
                                        return AlertDialog(
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'Are you sure, you want to delete?',
                                                style: GoogleFonts.manrope(),
                                              )
                                            ],
                                          ),
                                          actions: [
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(
                                                    true); // Return true when delete button is pressed
                                              },
                                              child: Text('Delete'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(
                                                    false); // Return false when cancel button is pressed
                                              },
                                              child: Text('Cancel'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ).then((value) async {
                                  if (value != null && value) {
                                    await deleteRecordFromDB(
                                        data['insertion_key']);
                                    setState(() {
                                      responseFuture = getMoodsFromDB(
                                          FirebaseAuth
                                              .instance.currentUser?.uid);
                                    });
                                  }
                                });
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
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
                                          insertionKey: data['insertion_key'],
                                        ),
                                      ));
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
  final String insertionKey;
  const DataWidget(
      {super.key,
      required this.date,
      required this.mood,
      required this.insertionKey});

  @override
  State<DataWidget> createState() => _DataWidgetState();
}

class _DataWidgetState extends State<DataWidget> {
  late Future<List<dynamic>> responseFuture;

  @override
  void initState() {
    super.initState();
    responseFuture = getSongListFromDB(
        FirebaseAuth.instance.currentUser?.uid, widget.insertionKey);
  }

  @override
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
      ),
      body: FutureBuilder(
        future: responseFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: snapshot.data!.map((item) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, bottom: 10, right: 10),
                        child: InkWell(
                          onTap: () async {
                            var url = item['url'];
                            final uri = Uri.parse(url);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                child: Image.network(
                                  item['img'] as String,
                                  fit: BoxFit.fill,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.blue,
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['name'],
                                        softWrap: true,
                                        style: GoogleFonts.manrope(
                                            textStyle:
                                                TextStyle(color: textColor),
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        item['artist'],
                                        softWrap: true,
                                        style: GoogleFonts.manrope(
                                            textStyle:
                                                TextStyle(color: textColor),
                                            fontSize: 15),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }).toList()),
              ),
            );
          } else if (snapshot.hasError) {
            return Text("Error loading data");
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
