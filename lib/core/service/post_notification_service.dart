import 'dart:convert';

import 'package:get/get.dart';

import '../models/user.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class PostNotificationService {
  PostNotificationService._privateConstructor();
  static final _instance = PostNotificationService._privateConstructor();
  factory PostNotificationService() => _instance;
  final Map<String, String> _headers = {
    "Content-Type": "application/json",
    "Authorization":
        "key=AAAAGZxZycU:APA91bE3iUFN5U6gsuf8BfP4gWsA0yVQFGhgZohdBk7vJUoCR4woJBs3hXxweg43cjFgpw4SYgu3oeqbxCCfTxgZq5p6cM-_cbYSHQqv9zSDgFRB2-nCBd7qKMAH6ZDuedmW4zzVcoB-"
  };
  Future<bool> postCallNotification(
      {required UserModel userModel,
      required String token,
      required String channelName,
      required String chatId,
      required bool isVideo}) async {
    Map<String, dynamic> data = {
      "to": userModel.firebaseToken,
      "data": {
        "title": userModel.username,
        "body": userModel.username +
            " is asking you for ${isVideo ? "video call" : "voice call"}",
        "type": "${isVideo ? "videocall" : "voicecall"}",
        "sender data": {
          "uid": userModel.id,
          "image": userModel.image,
          "phone": userModel.phoneNumber,
          "username": userModel.username,
          "active": userModel.active,
          "chatId": chatId,
          "channel name": channelName,
          "token": token
        }
      }
    };
    Uri uri = Uri.parse("https://fcm.googleapis.com/fcm/send");
    http.Response response =
        await http.post(uri, headers: _headers, body: json.encode(data));
    Map<String, dynamic> responseBody = json.decode(response.body);
    printInfo(info: "post notifcation body is : " + responseBody.toString());
    if (responseBody["success"] == 1) {
      return true;
    } else {
      return false;
    }
  }
}
