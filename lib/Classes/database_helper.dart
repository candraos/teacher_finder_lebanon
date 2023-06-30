import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:teacher_finder_lebanon/Models/Notification.dart';
class DatabaseHelper{
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??  await _initDatabase();

  Future<Database> _initDatabase() async{
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path,"teacher_finder.db");
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate
    );
  }

  Future _onCreate(Database db,int version) async{
    await db.execute(""
        "CREATE TABLE Notifications("
        "id INTEGER, "
        "title TEXT, "
        "description TEXT, "
        "type text, "
        "email text, "
        "user text, "
        "section text, "
        "currency text NULL, "
        "price INTEGER NULL, "
        "rating INTEGER NULL, "
        "latitude INTEGER NULL, "
        "longitude INTEGER NULL, "
        "firstName text, "
        "lastName text, "
        "image text, "
        "role text "
        ")"
    );
  }

  Future<List<Notification>> getNotifications() async{
    Database db = await instance.database;
    var notifications = await db.query("Notifications");
    List<Notification> notificationList = notifications.isNotEmpty ? notifications.map((n) => Notification.fromMap(n)).toList() : [];
    return notificationList;
  }

  Future<int> addNotification(Notification notification) async{
    Database db = await instance.database;
    return await db.insert("Notifications", notification.toMap());
  }


  Future<int> deleteConnectionNotifications() async{
    Database db = await instance.database;
    return await db.delete("Notifications",where: "type = 'Type.Connection'");
  }

  Future<int> deleteConnectionNotificationWithId(int id) async{
    Database db = await instance.database;
    return await db.delete("Notifications",where: "id = $id");
  }
}