import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:linode_flutter/controllers/secrets.dart';

getValue() async {
  var url =
      'https://europe-west1-randommusicgenerator-34646.cloudfunctions.net/app/getRandomTrack?genre=random&market=random&decade=all&tag_new=false&exclude_singles=false';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    print(json.decode(response.body));
    return json.decode(response.body);
  } else {
    return (response.statusCode);
  }
}

getImageURL() async {
  final responseBody = await getValue();
  return responseBody["image"];
}

getScanCode() async {
  final responseBody = await getValue();
  var jsonURI = responseBody["uri"];
  return 'https://scannables.scdn.co/uri/plain/jpeg/ffffff/black/640/${jsonURI}';
}
