import '../enums/message_type.dart';
import '../helpers/message_type_transformer.dart';

class Message {
  final String text;
  final String id;
  final DateTime date;
  final String from;
  final String to;
  final MessageType type;
  final String? link;
  final String chatId;
  Message(
      {required this.chatId,
      this.link,
      required this.id,
      required this.type,
      required this.text,
      required this.date,
      required this.from,
      required this.to});

  factory Message.fromJson(Map<String, dynamic> data) {
    return Message(
        text: data["text"],
        date: DateTime.parse(data["date"].toString()),
        from: data["from"],
        to: data["to"],
        id: data["id"],
        type: stringToMessageType(data['type']),
        link: data["type"] == "text" ? null : data["link"],
        chatId: data["chatId"]);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {
      "text": text,
      "date": date.toIso8601String(),
      "from": from,
      "to": to,
      "id": id,
      "type": messageTypeToString(type),
      "link": link,
      "chatId": chatId,
    };
    return data;
  }
}
