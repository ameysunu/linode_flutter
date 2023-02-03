import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';

import 'controllers/linodedb.dart';

class Mood extends StatefulWidget {
  const Mood({super.key, required this.camera});

  final CameraDescription camera;

  @override
  State<Mood> createState() => _MoodState();
}

class _MoodState extends State<Mood> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Mood Analyzer",
                style: GoogleFonts.manrope(
                    textStyle: TextStyle(color: textColor, fontSize: 30)),
              ),
              Text(
                "Analyze your mood, and let us suggest a song for you.",
                style: GoogleFonts.manrope(
                    textStyle: TextStyle(color: textColor, fontSize: 15)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                child: FutureBuilder<void>(
                  future: _initializeControllerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      // If the Future is complete, display the preview.
                      return CameraPreview(_controller);
                    } else {
                      // Otherwise, display a loading indicator.
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
              Center(
                  child: Text("Say Cheese! You're looking pretty as usual!",
                      style: GoogleFonts.manrope(
                          textStyle:
                              TextStyle(color: textColor, fontSize: 20))))
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: textColor,
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final image = await _controller.takePicture();

            if (!mounted) return;

            // If the picture was taken, display it on a new screen.
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayImage(
                  // Pass the automatically generated path to
                  // the DisplayPictureScreen widget.
                  imagePath: image.path,
                ),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

class DisplayImage extends StatefulWidget {
  final String imagePath;
  const DisplayImage({super.key, required this.imagePath});

  @override
  State<DisplayImage> createState() => _DisplayImageState();
}

class _DisplayImageState extends State<DisplayImage> {
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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "Ready yet?",
            style: GoogleFonts.manrope(
                textStyle: TextStyle(color: textColor, fontSize: 30)),
          ),
          Text(
            "Make sure your face is visible, if not you can always go back and click another picture.",
            style: GoogleFonts.manrope(
                textStyle: TextStyle(color: textColor, fontSize: 15)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Image.file(File(widget.imagePath)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: textColor,
              ),
              onPressed: () {
                // print(widget.imagePath);
                uploadImage(widget.imagePath);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Start',
                    style: GoogleFonts.manrope(),
                  ),
                ],
              ),
            ),
          )
          //Text(widget.imagePath)
        ]),
      ),
    );
  }
}
