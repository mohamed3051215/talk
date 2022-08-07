import 'package:chat_app/core/enums/message_type.dart';
import 'package:chat_app/core/helpers/message_type_transformer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String text;
  final String id;
  final DateTime date;
  final String from;
  final String to;
  final MessageType type;
  final String? link;
  Message(
      {this.link,
      required this.id,
      required this.type,
      required this.text,
      required this.date,
      required this.from,
      required this.to});

  factory Message.fromJson(Map<String, dynamic> data) {
    return Message(
        text: data["text"],
        date: (data["date"] as Timestamp).toDate(),
        from: data["from"],
        to: data["to"],
        id: data["id"],
        type: stringToMessageType(data['type']),
        link: data["type"] == "text" ? null : data["link"]);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {
      "text": text,
      "date": Timestamp.fromDate(date),
      "from": from,
      "to": to,
      "id": id,
      "type": messageTypeToString(type),
      "link": link
    };
    return data;
  }
}
