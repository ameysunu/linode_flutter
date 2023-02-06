import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

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
    return Column(
        children: widget.tracks.map((item) {
      return Text(
        item['name'],
        style: TextStyle(color: Colors.red),
      );
    }).toList());
  }
}
