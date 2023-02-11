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
                        return Text(data['mood'].toString());
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
