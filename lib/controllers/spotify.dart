import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:linode_flutter/controllers/secrets.dart';

final String url = 'https://api.spotify.com/v1/tracks';
final String accept = 'application/json';
final String contentType = 'application/json';
final String token = SPOTIFY_TOKEN;
final Map<String, String> headers = {
  'Accept': accept,
  'Content-Type': contentType,
  'Authorization': 'Bearer $token',
};

final Map<String, String> parameters = {
  'market': 'US',
  'ids': '$SPOTIFY_ID_1, $SPOTIFY_ID_2, $SPOTIFY_ID_3',
};

Future<http.Response> getTracks() async {
  final String host = 'api.spotify.com';
  final String path = '/v1/tracks';
  final Uri uri =
      Uri(scheme: 'https', host: host, path: path, queryParameters: parameters);
  final response = await http.get(uri, headers: headers);
  return response;
}

getValue() async {
  final response = await getTracks();
  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    print(jsonData);
  } else {
    // handle the error case
  }
}
