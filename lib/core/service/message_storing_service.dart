import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

import '../models/call.dart';
import '../models/contact.dart';
import '../models/message.dart';
import '../models/user.dart';

class MessageStoringService {
  MessageStoringService._privateConstructor();

  static final MessageStoringService _instance =
      MessageStoringService._privateConstructor();

  factory MessageStoringService() => _instance;

  late Database db;
  String? path;
  init() async {
    final String databasePath = await getDatabasesPath();
    path = databasePath + "/main.db";
    printInfo(info: "Got database path : " + path!);
    db = await openDatabase(path!, version: 1,
        onCreate: (Database database, int version) {
      database.execute("""CREATE TABLE IF NOT EXISTS messages (
        text TEXT,
        date TEXT,
        id TEXT PRIMARY KEY,
        fromx TEXT,
        tox TEXT,
        type TEXT,
        link TEXT,
        chatId TEXT
      )""");
      database.execute("""CREATE TABLE IF NOT EXISTS contacts (
        last_message REFERENCES messages(id) DEFERRABLE INITIALLY DEFERRED,
        contact_user TEXT,
        messages_not_seen INTEGER,
        chatId TEXT
      )""");
      database.execute("""CREATE TABLE IF NOT EXISTS users (
        uid TEXT PRIMARY KEY ,
        image TEXT,
        phone TEXT,
        username TEXT,
        active INTEGER
      )""");
      database.execute("""CREATE TABLE IF NOT EXISTS calls (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fromx TEXT,
        tox TEXT,
        date TEXT,
        call_state TEXT
      )""");
      database.execute("""CREATE TABLE IF NOT EXISTS my_user (
        uid TEXT PRIMARY KEY ,
        image TEXT,
        phone TEXT,
        username TEXT,
        active INTEGER
      )""");
      printInfo(info: "All tables created");
    });
  }

  deleteDatabaseFile() async {
    if (path == null) {
      await init();
    }
    await deleteDatabase(path!);
    printInfo(info: "Database deleted successfully");
  }

  Future<List<Message>> getMessages(String chatId) async {
    List<Map<String, dynamic>> query =
        await db.query("messages", where: "chatId = ?", whereArgs: [chatId]);
    List<Message> messages = query.map<Message>((e) {
      Map<String, dynamic> newElement = Map.of(e);
      newElement["from"] = newElement['fromx'];
      newElement["to"] = newElement["tox"];

      return Message.fromJson(newElement);
    }).toList();
    return messages;
  }

  Future<List<Call>> getCalls() async {
    List<Map<String, dynamic>> query = await db.query("calls");
    List<Call> calls = [];
    for (Map<String, dynamic> map in query) {
      UserModel from = await getSpecificUser(map['fromx']);
      UserModel to = await getSpecificUser(map["tox"]);
      map["from"] = from;
      map["to"] = to;
      Call call = Call.fromJson(map);
      calls.add(call);
    }
    return calls;
  }

  Future<UserModel> getSpecificUser(String userId) async {
    List<Map<String, dynamic>> query =
        await db.query("users", where: "uid = ?", whereArgs: [userId]);
    Map<String, dynamic> map = Map.of(query[0]);

    return UserModel.fromJson(query[0]);
  }

  Future<List<ChatContact>> getContacts() async {
    List<Map<String, dynamic>> query = await db.query("contacts");
    List<ChatContact> contacts = [];
    for (Map<String, dynamic> element in query) {
      printInfo(info: "Element : " + element.toString());
      Message lastMessage = await getSpecificMessage(element['last_message']);
      UserModel contactUser = await getSpecificUser(element["contact_user"]);
      ChatContact chatContact = ChatContact(
          messagesNotSeen: element['message_not_seen'],
          contactUser: contactUser,
          lastMesssage: lastMessage,
          chatId: element["chatId"]);
      contacts.add(chatContact);
    }
    return contacts;
  }

  Future<Message> getSpecificMessage(String messageId) async {
    List<Map<String, dynamic>> query =
        await db.query("messages", where: "id = ?", whereArgs: [messageId]);

    return Message.fromJson(query[0]);
  }

  Future<Message> getLastMessage(String chatId) async {
    List<Map<String, dynamic>> query = await db.rawQuery(
        "SELECT * FROM messages WHERE chatId = ? ORDER BY id DESC LIMIT 1",
        [chatId]);
    printInfo(info: "Query : " + query.toString());
    Map<String, dynamic> e = Map.of(query[0]);
    e["from"] = e['fromx'];
    e["to"] = e["tox"];
    return Message.fromJson(e);
  }

  Future<UserModel?> getMyUser() async {
    List<Map<String, dynamic>> query = await db.query("my_user");
    try {
      Map<String, dynamic> e = Map.of(query[0]);
      bool active = e["active"].toString() != "0";
      e["active"] = active;
      UserModel userModel = UserModel.fromJson(e);
      return userModel;
    } catch (e) {
      printError(info: e.toString());
      return null;
    }
  }

  Future<List<UserModel>> getUsers() async {
    List<Map<String, dynamic>> query = await db.query("users");
    List<UserModel> users = query.map<UserModel>((element) {
      Map<String, dynamic> e = Map.of(element);
      bool active = e["active"].toString() != "0";
      e["active"] = active;
      UserModel userModel = UserModel.fromJson(e);
      return userModel;
    }).toList();
    return users;
  }

  Future<void> addMessage(Message message) async {
    Map<String, dynamic> json = message.toJson();

    json['fromx'] = json.remove("from");
    json['tox'] = json.remove("to");
    int id = 0;
    try {
      id = await db.insert('messages', json);
    } catch (e) {
      printInfo(info: e.toString());
      return;
    }

    if (id == 0) {
      print("error in Adding message to sqflite");
      return;
    }
    print(id);
  }

  Future<void> addCall(Call call) async {
    Map<String, dynamic> json = call.toJson();
    json['fromx'] = json.remove("from");
    json['tox'] = json.remove("to");
    int id = await db.insert("calls", json);
    if (id == 0) {
      print("error in Adding call to sqflite");
      return;
    }
    print(id);
  }

  Future<void> addUser(UserModel userModel) async {
    int id = await db.insert("users", userModel.toJson());
    if (id == 0) {
      print("error in Adding call to sqflite");
      return;
    }
    print(id);
  }

  Future<void> addMyUser(UserModel userModel) async {
    int id = await db.insert("my_user", userModel.toJson());
    if (id == 0) {
      print("error in Adding call to sqflite");
      return;
    }
    print(id);
  }

  Future<void> addContact(ChatContact contact) async {
    Map<String, dynamic> json = contact.toJson();
    json['contact_user'] = json.remove("contactUser").id;
    json["last_message"] = json.remove("lastMessage").id;
    json['messages_not_seen'] = json.remove("message_not_seen");
    int id = await db.insert("contacts", json);
    if (id == 0) {
      print("error in Adding call to sqflite");
      return;
    }
    print(id);
  }
}
