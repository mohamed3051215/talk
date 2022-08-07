import 'package:chat_app/core/models/user.dart';

import 'message.dart';

class ChatContact {
  final Message? lastMesssage;
  final UserModel contactUser;
  final int messagesNotSeen;

  ChatContact(
      {required this.messagesNotSeen,
      this.lastMesssage,
      required this.contactUser});
}
