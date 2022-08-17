import 'package:chat_app/core/models/user.dart';

import 'message.dart';

class ChatContact {
  final Message? lastMesssage;
  final UserModel contactUser;
  final int messagesNotSeen;
  final String chatId;

  ChatContact(
      {required this.chatId,
      required this.messagesNotSeen,
      this.lastMesssage,
      required this.contactUser});

  ChatContact fromJson(Map<String, dynamic> data) {
    return ChatContact(
      chatId: data['chatId'],
      messagesNotSeen: data['message_not_seen'],
      lastMesssage: data['lastMessage'],
      contactUser: data['contactUser'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "chatId": chatId,
      "message_not_seen": messagesNotSeen,
      "lastMessage": lastMesssage,
      "contactUser": contactUser,
    };
  }
}
