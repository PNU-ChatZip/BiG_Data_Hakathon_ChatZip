import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Notification {
  final DateTime time;
  final String? name;
  final String? comment;
  final String? icon;

  Notification({
    required this.time,
    this.name,
    this.comment,
    required IconData iconData,
  }) : icon = convertIconDataToString(iconData);

  static String convertIconDataToString(IconData iconData) {
    final codePoint = iconData.codePoint;
    final fontFamily = iconData.fontFamily;
    final fontPackage = iconData.fontPackage;
    final matchTextDirection = iconData.matchTextDirection;

    return '$codePoint,$fontFamily,$fontPackage,$matchTextDirection';
  }

  Map<String, dynamic> toMap() {
    return {
      'time': time.toIso8601String(),
      'name': name,
      'comment': comment,
      'icon': icon,
    };
  }

  @override
  String toString() {
    return 'Notification{time: $time, name: $name, comment: $comment, icon: $icon}';
  }
}
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   final database = openDatabase(
//     join(await getDatabasesPath(), 'doggie_database.db'),
//     onCreate: (db, version) {
//       return db.execute(
//         'CREATE TABLE Notification(time DATETIME, name TEXT, comment TEXT, icon TEXT)',
//       );
//     },
//     version: 1,
//   );
//
//   Future<void> insertNot(Notification notification) async {
//     final db = await database;
//     await db.insert(
//       'Notification',
//       notification.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }
//
//   IconData convertStringToIcon(String iconString) {
//     final parts = iconString.split(',');
//
//     final codePoint = int.parse(parts[0], radix: 16);
//     final fontFamily = parts[1];
//     final fontPackage = parts[2];
//     final matchTextDirection = parts[3] == 'true';
//
//     final iconData = IconData(
//       codePoint,
//       fontFamily: fontFamily,
//       fontPackage: fontPackage,
//       matchTextDirection: matchTextDirection,
//     );
//
//     return iconData;
//   }
//
//   Future<List<Notification>> getNotifications() async {
//     final db = await database;
//     final List<Map<String, dynamic>> maps = await db.query('Notification');
//
//     return List.generate(maps.length, (i) {
//       return Notification(
//         time: DateTime.parse(maps[i]['time']),
//         name: maps[i]['name'],
//         comment: maps[i]['comment'],
//         iconData: convertStringToIcon(maps[i]['icon']),
//       );
//     });
//   }
//
//   Future<void> deleteNot(Notification notification) async {
//     final db = await database;
//
//     await db.delete(
//       'Notification',
//       where: 'icon = ?',
//       whereArgs: [notification.icon],
//     );
//   }
//
//   var fido = Notification(
//     time: DateTime.now(),
//     name: 'Fido',
//     comment: "hello",
//     iconData: Icons.ac_unit,
//   );
//   await insertNot(fido);
//
//   print(await getNotifications());
// }
