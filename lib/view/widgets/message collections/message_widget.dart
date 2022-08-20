import '../../../core/enums/message_type.dart';
import '../../../core/models/message.dart';
import '../message%20collections/audio_widget.dart';
import '../message%20collections/image_message.dart';
import '../message%20collections/text_message.dart';
import '../message%20collections/video_message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget({Key? key, required this.message, required this.chatId}) : super(key: key);
  final Message message;
  final String chatId;
  @override
  Widget build(BuildContext context) {
    final DateFormat format = DateFormat.Hm();
    final String time = format.format(message.date);
    switch (message.type) {
      case MessageType.text:
        return TextMessage(message: message, time: time , chatId: chatId);
      case MessageType.image:
        return ImageMessage(message: message, time: time , chatId : chatId);
      case MessageType.video:
        return VideoMessage(message: message, time: time , chatId : chatId);
      case MessageType.audio:
        return AudioMessage(message: message, time: time , chatId: chatId,);
      default:
        break;
    }
    return SizedBox();
  }
}
