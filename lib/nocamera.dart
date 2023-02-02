import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linode_flutter/mood.dart';
import 'package:rive/rive.dart';

class NoCamera extends StatefulWidget {
  const NoCamera({super.key});

  @override
  State<NoCamera> createState() => _NoCameraState();
}

class _NoCameraState extends State<NoCamera> {
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "No Camera detected",
                style: GoogleFonts.manrope(
                    textStyle: TextStyle(color: textColor, fontSize: 30)),
              ),
              Text(
                "We could'nt detect a camera module in your device. Don't worry, we still got you. You can upload a picture from your gallery.",
                style: GoogleFonts.manrope(
                    textStyle: TextStyle(color: textColor, fontSize: 15)),
              ),
              Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: RiveAnimation.asset('assets/camera.riv')),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: textColor,
                  ),
                  onPressed: () {
                    _getFromGallery();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Upload an image',
                        style: GoogleFonts.manrope(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      //DisplayImage
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DisplayImage(imagePath: imageFile.path)),
      );
    }
  }
}
