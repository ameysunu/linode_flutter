import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linode_flutter/controllers/firebase_auth.dart';
import 'package:linode_flutter/controllers/spotify.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    const backgroundColor = const Color(0xFFB392E4F);

    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: logoutFirebase,
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                ))
          ],
          elevation: 0,
          backgroundColor: backgroundColor,
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome!",
                  style: GoogleFonts.manrope(
                      textStyle: TextStyle(color: Colors.white, fontSize: 30)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.white,
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
                                  textStyle: TextStyle(fontSize: 20)),
                            ),
                            const Text("See if I'm groovy today!")
                          ],
                        ),
                        Icon(Icons.music_note)
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.white,
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
                                  textStyle: TextStyle(fontSize: 20)),
                            ),
                            const Text("All my previous mood swings!")
                          ],
                        ),
                        Icon(Icons.security)
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: () async {
                      getValue();
                    },
                    child: Text("data"))
              ],
            ),
          ),
        ));
  }
}
