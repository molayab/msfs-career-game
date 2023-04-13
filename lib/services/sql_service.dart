import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';

class SqlService {
  Future<Database> connect() async {
    sqfliteFfiInit();

    //return await databaseFactoryFfi.openDatabase("assets/game.db");

    var databasePath = await getApplicationDocumentsDirectory();
    var path = join(databasePath.path, "game.db");

    if (await databaseExists(path)) {
      print("Opening existing database, $path");
    } else {
      print("Creating new database from copied asset");
      await deleteDatabase(path);

      ByteData data = await rootBundle.load("assets/game.db");
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes);
    }

    return await databaseFactoryFfi.openDatabase(path);
  }

  Future<bool> databaseExists(String path) async {
    return await File(path).exists();
  }

  Future<void> deleteDatabase(String path) async {
    if (!(await databaseExists(path))) {
      return;
    }

    await File(path).delete();
  }
}
