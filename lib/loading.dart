import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rive/rive.dart';

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
          return Column(
            children: [
              Text(widget.data,
                  style: GoogleFonts.manrope(
                    textStyle: TextStyle(color: textColor, fontSize: 20),
                  ))
            ],
          );
        }),
      ),
    );
  }
}
