import '../enums/message_type.dart';

String messageTypeToString(MessageType type) {
  switch (type) {
    case MessageType.audio:
      return "audio";
    case MessageType.image:
      return "image";
    case MessageType.text:
      return "text";
    case MessageType.video:
      return "video";

    default:
      return "text";
  }
}

MessageType stringToMessageType(String string) {
  switch (string) {
    case "audio":
      return MessageType.audio;
    case "image":
      return MessageType.image;
    case "text":
      return MessageType.text;
    case "video":
      return MessageType.video;
    default:
      return MessageType.text;
  }
}
