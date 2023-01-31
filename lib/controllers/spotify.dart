import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:linode_flutter/controllers/secrets.dart';

var imageUrl;

// final String url = 'https://api.spotify.com/v1/tracks';
// final String accept = 'application/json';
// final String contentType = 'application/json';
// final String token = SPOTIFY_TOKEN;
// final Map<String, String> headers = {
//   'Accept': accept,
//   'Content-Type': contentType,
//   'Authorization': 'Bearer $token',
// };

// final Map<String, String> parameters = {
//   'market': 'US',
//   //'ids': '$SPOTIFY_ID_1, $SPOTIFY_ID_2, $SPOTIFY_ID_3',
//   'ids': '7ouMYWpwJ422jRcDASZB7P,4VqPOruhp5EdPBeR92t6lQ,2takcwOaAZWiXQijPHIx7B'
// };

// Future<http.Response> getTracks() async {
//   final String host = 'api.spotify.com';
//   final String path = '/v1/tracks';
//   final Uri uri =
//       Uri(scheme: 'https', host: host, path: path, queryParameters: parameters);
//   final response = await http.get(uri, headers: headers);
//   return response;
// }
final String url = 'https://api.spotify.com/v1/tracks/11dFghVXANMlKmJXsNCbNl';
final String accept = 'application/json';
final String contentType = 'application/json';
final String token =
    'BQD8C47ROgbbbSyvHKjRgbvF1a80iqV4UDDPcE-STWys1FenU-B28fkIn0RqUFdGFwx_ULKK1RcRAsoF9CsOE7IiJ_rwIexWs1rV0KstE_oNog1FqxKeppnvr3uSN89_lFKdenrS5gTe2bOrs_3kR5GOaN1PhX3_scGLbmXVX09kx_aIRb0MZSg7WMgQ2W-H';
final Map<String, String> headers = {
  'Accept': accept,
  'Content-Type': contentType,
  'Authorization': 'Bearer $token',
};

final Map<String, String> parameters = {
  'market': 'ES',
};

Future<http.Response> getTracks() async {
  final String host = 'api.spotify.com';
  final String path = '/v1/tracks/11dFghVXANMlKmJXsNCbNl';
  final Uri uri =
      Uri(scheme: 'https', host: host, path: path, queryParameters: parameters);
  final response = await http.get(uri, headers: headers);
  return response;
}

getValue() async {
  final response = await getTracks();
  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    //print(jsonData["tracks"][0]["artists"][0]["uri"]);
    print(jsonData);
    // print(jsonData["tracks"][0]["album"]);
    // imageUrl = (jsonData["tracks"][0]["album"]["images"][0]["url"]);
    // print(imageUrl);

    print(jsonData);
  } else {
    print("Error : ${response.statusCode}");
  }
}

getImageURL() async {
  final response = await getTracks();
  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    return jsonData["tracks"][0]["album"]["images"][0]["url"];
  } else {
    print("Error");
  }
}

// getScanCode() async {
//   final response = await getTracks();
//   if (response.statusCode == 200) {
//     final jsonData = jsonDecode(response.body);
//     final jsonURI = jsonData["tracks"][0]["artists"][0]["uri"];
//     return 'https://scannables.scdn.co/uri/plain/jpeg/ffffff/black/640/${jsonURI}';
//   } else {
//     print("Error");
//   }
// }
