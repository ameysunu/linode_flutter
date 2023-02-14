import 'dart:convert';

import 'package:linode_flutter/controllers/secrets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:http/http.dart' as http;

late MySQLConnection conn;

initializeDB() async {
  conn = await MySQLConnection.createConnection(
      host: LINODE_DB_HOST,
      port: 3306,
      userName: LINODE_DB_USERNAME,
      password: LINODE_DB_PASSWORD,
      secure: true);
  await conn.connect();
  await conn.execute("USE dev");
}

addDatatoDB(uid, currentDate, mood, insertionKey) async {
  // ignore: unnecessary_null_comparison
  if (conn == null) {
    await initializeDB();
  }
  await conn.execute("USE dev");
  try {
    var data = await conn.execute(
        "INSERT INTO userdata (userid, date, mood, insertion_key) VALUES ('$uid', '$currentDate', '$mood' , '$insertionKey')");
    print(data);
  } catch (e) {
    print(e);
  }
}

addSongtoDB(userid, name, img, artist, url, date, insertionKey) async {
  // ignore: unnecessary_null_comparison
  if (conn == null) {
    await initializeDB();
  }

  await conn.execute("USE dev");
  try {
    var data = await conn.execute(
        "INSERT INTO songdata (userid, name, img, artist, url, date, insertion_key) VALUES ('$userid', '$name', '$img', '$artist', '$url', '$date', '$insertionKey')");
    print(data);
  } catch (e) {
    print(e);
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

  try {
    var url = Uri.parse("$NGROK_URL/upload");

    var request = http.MultipartRequest("POST", url);
    var file = await http.MultipartFile.fromPath("image", path);
    request.files.add(file);

    final response = await request.send();

    final responseData = await response.stream.toBytes();
    final responseString = String.fromCharCodes(responseData);
    var jsonMap = jsonDecode(responseString);
    Map<String, dynamic> parsedJson = jsonDecode(jsonMap);
    String topEmotion = parsedJson['top_emotion'];

    if (topEmotion != null) {
      print(topEmotion);

      return topEmotion;
    } else {
      print("No face found, please try again.");
      return 'No face found, please try again.';
    }
  } catch (e) {
    print(e.toString());
  }
}

Future<List<dynamic>> getDataFromDB(uid) async {
  final conn = await MySQLConnection.createConnection(
      host: LINODE_DB_HOST,
      port: 3306,
      userName: LINODE_DB_USERNAME,
      password: LINODE_DB_PASSWORD,
      secure: true);
  await conn.connect();

  await conn.execute("USE dev");

  try {
    var data = await conn.execute(
        "SELECT userdata.*, COUNT(songdata.userid) AS total_songs, GROUP_CONCAT(songdata.name SEPARATOR ', ') AS songs, GROUP_CONCAT(songdata.img SEPARATOR ', ') AS images, GROUP_CONCAT(songdata.url SEPARATOR ', ') AS url, GROUP_CONCAT(songdata.artist SEPARATOR ', ') AS artists FROM userdata JOIN songdata ON userdata.userid = songdata.userid WHERE userdata.userid = '$uid' GROUP BY userdata.userid, userdata.id;");
    List<dynamic> rows = [];
    for (final row in data.rows) {
      rows.add(row.assoc());
    }
    return rows;
  } catch (e) {
    print(e);
    return [];
  }
}

Future<List<dynamic>> getMoodsFromDB(uid) async {
  final conn = await MySQLConnection.createConnection(
      host: LINODE_DB_HOST,
      port: 3306,
      userName: LINODE_DB_USERNAME,
      password: LINODE_DB_PASSWORD,
      secure: true);
  await conn.connect();
  await conn.execute("USE dev");
  try {
    var data =
        await conn.execute("SELECT * FROM userdata WHERE userid = '$uid';");
    List<dynamic> rows = [];
    for (final row in data.rows) {
      rows.add(row.assoc());
    }
    return rows;
  } catch (e) {
    print(e);
    return [];
  }
}

Future<List<dynamic>> getSongListFromDB(uid, insertionKey) async {
  final conn = await MySQLConnection.createConnection(
      host: LINODE_DB_HOST,
      port: 3306,
      userName: LINODE_DB_USERNAME,
      password: LINODE_DB_PASSWORD,
      secure: true);
  await conn.connect();
  await conn.execute("USE dev");
  try {
    var data = await conn.execute(
        "SELECT * FROM songdata WHERE userid = '${uid}' AND insertion_key = '${insertionKey}';");
    List<dynamic> rows = [];
    for (final row in data.rows) {
      rows.add(row.assoc());
    }
    return rows;
  } catch (e) {
    print(e);
    return [];
  }
}
