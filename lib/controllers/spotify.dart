import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:linode_flutter/controllers/secrets.dart';

Future<Map<String, dynamic>> getValue() async {
  var url =
      'https://europe-west1-randommusicgenerator-34646.cloudfunctions.net/app/getRandomTrack?market=US&decade=all&tag_new=false&exclude_singles=false';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    //print(json.decode(response.body));
    var responseBody = json.decode(response.body);
    return responseBody;
  } else {
    throw Exception('e');
  }
}

String getScanCode(Map<String, dynamic> responseBody) {
  var jsonURI = responseBody['uri'];
  return 'https://scannables.scdn.co/uri/plain/jpeg/ffffff/black/640/$jsonURI';
}

Future<Map<String, dynamic>> getSongList() async {
  var url =
      'https://europe-west1-randommusicgenerator-34646.cloudfunctions.net/app/getRandomTrack?q=sad&market=US&decade=all&tag_new=false&exclude_singles=false';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    //print(json.decode(response.body));
    var responseBody = json.decode(response.body);
    return responseBody;
  } else {
    throw Exception('e');
  }
}

// void fetchTracks(String emotion) async {
//   var response = await http.get(
//       Uri.parse(
//           "https://api.spotify.com/v1/search?q=$emotion&type=track&limit=10"),
//       headers: {
//         "Authorization":
//             "BQB_0VclEL6FjyiT8fdW8k38apMyyHKhJUM6JR88tq8tL1SPSnsmBOCAZiX_6njrRuHkpdnT_fQoXrPuDG7dKuF8rBWkTM7FOn-MYfnNXnMsK-mqJAGpE13T06VPsJLsq4Z5rMFlIjsTETCnEqff4DkNEBzmX0sFDVEF4_CYsTMrvhYCoLdYEgWMqZdy3OdM"
//       });

//   var data = json.decode(response.body);
//   // setState(() {
//   //   tracks = data["tracks"]["items"];
//   // });
//   print(data["tracks"]["items"]);
// }

// Future<Map<String, dynamic>> fetchTracks(String emotion) async {
//   var url =
//       'https://api.spotify.com/v1/search?q=$emotion&type=track&limit=10&market=US';
//   final response = await http.get(Uri.parse(url), headers: {
//     'Authorization':
//         'Bearer BQDmEmFQ35FFrDElvw2Vun8tZQzW4Nqu-q9c9bLe8pgg0__SHvOIb1U-TAw47FASO-QBoM4pZ4YtRgoRDJR3j1K60k5zr41jw5KXnBPAmkkTH6Y6qnq1rIu4YsIN7GnU3PrBdDMtWTovt7g0lFZyTsklsUOrZT6m1PhXY8sYtM_JHx0H2qEdRnKCttbZ41ZX'
//   });

//   if (response.statusCode == 200) {
//     print(json.decode(response.body));
//     var responseBody = json.decode(response.body);
//     return responseBody["tracks"]["items"];
//   } else {
//     throw Exception('e');
//   }
// }

Future<List> fetchTracks(String emotion) async {
  var url =
      'https://api.spotify.com/v1/search?q=$emotion&type=track&limit=10&market=US';
  final response = await http
      .get(Uri.parse(url), headers: {'Authorization': 'Bearer $SPOTIFY_API'});

  if (response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    List tracks = [];
    for (var track in responseBody["tracks"]["items"]) {
      //print(track['name']);
      tracks.add(track);
    }
    return tracks;
  } else {
    throw Exception('Failed to load tracks');
  }
}

Future<String> getSpotifyApiKey() async {
  final response = await http.get(Uri.parse(
      'http://109.74.199.203:6969/api/env_variables/SPOTIFY_API_KEY'));

  Map<String, dynamic> responseMap = jsonDecode(response.body);
  String apiKey = responseMap['value'];
  print(apiKey);
  return apiKey;
}
