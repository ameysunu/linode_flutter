import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:linode_flutter/controllers/secrets.dart';

Future<Map<String, dynamic>> getValue() async {
  var url =
      'https://europe-west1-randommusicgenerator-34646.cloudfunctions.net/app/getRandomTrack?market=US&decade=all&tag_new=false&exclude_singles=false';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    print(json.decode(response.body));
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
