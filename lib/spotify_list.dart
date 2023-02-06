import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class SpotifyWidget extends StatefulWidget {
  final List tracks;
  const SpotifyWidget({super.key, required this.tracks});

  @override
  State<SpotifyWidget> createState() => _SpotifyWidgetState();
}

class _SpotifyWidgetState extends State<SpotifyWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.tracks);
  }

  @override
  Widget build(BuildContext context) {
    const textColor = const Color(0xFFB392E4F);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.tracks.map((item) {
            return Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10, right: 10),
              child: InkWell(
                onTap: () async {
                  var url = item['external_urls']['spotify'];
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
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: Image.network(
                        item['album']['images'][0]['url'] as String,
                        fit: BoxFit.fill,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              color: Colors.blue,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['name'],
                              softWrap: true,
                              style: GoogleFonts.manrope(
                                  textStyle: TextStyle(color: textColor),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              item['artists'][0]['name'],
                              softWrap: true,
                              style: GoogleFonts.manrope(
                                  textStyle: TextStyle(color: textColor),
                                  fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }).toList()),
    );
  }
}
