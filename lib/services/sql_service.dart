import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqlService {
  Future<Database> connect() async {
    var databasePath = await getDatabasesPath();
    var path = join(databasePath, 'main.db');

    if (await databaseExists(path)) {
      print("Opening existing database, $path");
    } else {
      print("Creating new database from copied asset");
      await deleteDatabase(path);
      
      ByteData data = await rootBundle.load("assets/game.db");
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes);
    }

    return await openDatabase(
      path,
      version: 1
    );
  }
}