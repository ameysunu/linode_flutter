import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linode_flutter/controllers/firebase_auth.dart';
import 'package:linode_flutter/controllers/spotify.dart';
import 'package:linode_flutter/mood.dart';
import 'package:linode_flutter/nocamera.dart';
import 'package:url_launcher/url_launcher.dart';

import 'mydata.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Map<String, dynamic>> responseFuture;

  void initState() {
    super.initState();
    responseFuture = getValue();
    // WidgetsBinding.instance.addPostFrameCallback((_) => getValue());
  }

  @override
  Widget build(BuildContext context) {
    const bckColor = const Color(0xFFB392E4F);
    const textColor = Colors.white;

    return Scaffold(
        backgroundColor: textColor,
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: logoutFirebase,
                icon: Icon(
                  Icons.logout,
                  color: bckColor,
                ))
          ],
          elevation: 0,
          backgroundColor: textColor,
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome!",
                    style: GoogleFonts.manrope(
                        textStyle: TextStyle(color: bckColor, fontSize: 30)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: InkWell(
                      onTap: () async {
                        WidgetsFlutterBinding.ensureInitialized();
                        final cameras = await availableCameras();

                        if (cameras.isNotEmpty) {
                          final frontCamera =
                              cameras.firstWhere((CameraDescription camera) {
                            return camera.lensDirection ==
                                CameraLensDirection.front;
                          });

                          // Use the firstCamera
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Mood(camera: frontCamera)),
                          );
                        } else {
                          print("No Camera");
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => NoCamera()),
                          );
                        }

                        // ignore: use_build_context_synchronously
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: bckColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Analyze my mood',
                                  style: GoogleFonts.manrope(
                                      textStyle: TextStyle(
                                          fontSize: 20, color: Colors.white)),
                                ),
                                Text("See if I'm groovy today!",
                                    style: GoogleFonts.manrope(
                                        textStyle:
                                            TextStyle(color: Colors.white)))
                              ],
                            ),
                            Icon(
                              Icons.music_note,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyData()),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: bckColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Things I did',
                                  style: GoogleFonts.manrope(
                                      textStyle: TextStyle(
                                          fontSize: 20, color: Colors.white)),
                                ),
                                Text(
                                  "All my previous mood swings!",
                                  style: GoogleFonts.manrope(
                                      textStyle:
                                          TextStyle(color: Colors.white)),
                                )
                              ],
                            ),
                            Icon(
                              Icons.security,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Text(
                      "Daily vibes ✨",
                      style: GoogleFonts.manrope(
                          textStyle: TextStyle(color: bckColor, fontSize: 30)),
                    ),
                  ),
                  Text(
                    "A random song for you everyday!",
                    style: GoogleFonts.manrope(
                        textStyle: TextStyle(color: bckColor, fontSize: 18)),
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 35.0),
                            child: FutureBuilder(
                              future: responseFuture,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Image.network(
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                    snapshot.data!['image'] as String,
                                    fit: BoxFit.fill,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: bckColor,
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
                                  );
                                } else if (snapshot.hasError) {
                                  return Text("Error loading image");
                                } else {
                                  return CircularProgressIndicator();
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: FutureBuilder(
                              future: responseFuture,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  Map<String, dynamic>? response =
                                      snapshot.data;
                                  return Image.network(
                                    getScanCode(response!),
                                    width: MediaQuery.of(context).size.width *
                                        0.432,
                                    fit: BoxFit.fill,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: bckColor,
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
                                  );
                                } else if (snapshot.hasError) {
                                  return Text("Error loading image");
                                } else {
                                  return CircularProgressIndicator();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: FutureBuilder(
                              future: responseFuture,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      child: Text(
                                        snapshot.data!['name'] as String,
                                        style: GoogleFonts.manrope(
                                            textStyle:
                                                TextStyle(color: bckColor),
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ));
                                } else if (snapshot.hasError) {
                                  return Text("Error loading image");
                                } else {
                                  return CircularProgressIndicator();
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: FutureBuilder(
                              future: responseFuture,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      child: Text(
                                        snapshot.data!['artists'][0]['name']
                                            as String,
                                        style: GoogleFonts.manrope(
                                          textStyle: TextStyle(color: bckColor),
                                          fontSize: 16,
                                        ),
                                      ));
                                } else if (snapshot.hasError) {
                                  return Text("Error loading image");
                                } else {
                                  return CircularProgressIndicator();
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10.0, top: 10),
                            child: FutureBuilder(
                              future: responseFuture,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      child: InkWell(
                                        onTap: () async {
                                          var url = snapshot.data!['link'];
                                          final uri = Uri.parse(url);
                                          if (await canLaunchUrl(uri)) {
                                            await launchUrl(uri);
                                          } else {
                                            throw 'Could not launch $url';
                                          }
                                        },
                                        child: Text(
                                          'Play on Spotify',
                                          style: GoogleFonts.manrope(
                                            textStyle:
                                                TextStyle(color: bckColor),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ));
                                } else if (snapshot.hasError) {
                                  return Text("Error loading image");
                                } else {
                                  return CircularProgressIndicator();
                                }
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          responseFuture = getValue();
                        });
                      },
                      child: Row(
                        children: [
                          Spacer(),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Text(
                              "Want to vibe on something else? Refresh here",
                              style: GoogleFonts.manrope(
                                  textStyle:
                                      TextStyle(color: bckColor, fontSize: 18)),
                            ),
                          ),
                          Spacer()
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
