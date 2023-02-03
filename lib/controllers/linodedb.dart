import 'dart:convert';

import 'package:linode_flutter/controllers/secrets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:http/http.dart' as http;

connectToDB() async {
  // Linode credentials saved in secrets.dart file
  final conn = await MySQLConnection.createConnection(
      host: LINODE_DB_HOST,
      port: 3306,
      userName: LINODE_DB_USERNAME,
      password: LINODE_DB_PASSWORD,
      secure: true);
  await conn.connect();

  await conn.execute("USE dev");
  var result = await conn.execute("SELECT * FROM users");
  for (final row in result.rows) {
    print(row.assoc());
  }
}

uploadImage(String path) async {
  // String? responseBody;
  // var url = Uri.parse(
  //     "https://1a79-2a01-7e00-00-f03c-93ff-fe62-8edd.eu.ngrok.io/upload");

  // try {
  //   var request = http.MultipartRequest("POST", url);
  //   var file = await http.MultipartFile.fromPath("image", path);
  //   request.files.add(file);
  //   final response = await request.send();
  // } catch (e) {
  //   print(e);
  //   responseBody = null;
  // }

  // if (responseBody != null) {
  //   Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
  //   String topEmotion = jsonResponse["top_emotion"];
  //   print(topEmotion);
  //   return topEmotion;
  // } else {
  //   print("Failed to retrieve data from the server.");
  // }

  var jsonMap;

  try {
    var url = Uri.parse("$NGROK_URL/upload");

    var request = http.MultipartRequest("POST", url);
    var file = await http.MultipartFile.fromPath("image", path);
    request.files.add(file);

    final response = await request.send();

    final responseData = await response.stream.toBytes();
    final responseString = String.fromCharCodes(responseData);
    jsonMap = jsonDecode(responseString);
  } catch (e) {
    print(e.toString());
  }

  if (jsonMap['top_emotion'] != null) {
    String topEmotion = jsonMap['top_emotion'];

    print(topEmotion);

    return topEmotion;
  } else {
    print("No face found, please try again.");
    return 'No face found, please try again.';
  }
}
