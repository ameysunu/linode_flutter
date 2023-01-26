import 'package:linode_flutter/controllers/secrets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:mysql_client/mysql_client.dart';

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
