///This data was just for making the UI until moving to Firebase

import 'package:chat_app/core/enums/message_type.dart';
import 'package:chat_app/core/models/message.dart';
import 'package:chat_app/core/models/user.dart';

final UserModel monika = UserModel(
    id: "123",
    oneSignalID: null,
    image:
        "https://ath2.unileverservices.com/wp-content/uploads/sites/4/2020/02/IG-annvmariv-1024x1016.jpg",
    active: false,
    phoneNumber: "01556462676",
    username: "Monika");
final Message lastMessage = Message(
    id: "124",
    type: MessageType.text,
    date: DateTime.now(),
    from: monika.id,
    to: mohamed.id,
    text: "Hello Monika how the fuck are you");

final UserModel mohamed = UserModel(
  id: "1234",
    oneSignalID: null,
  image:
      "https://ath2.unileverservices.com/wp-content/uploads/sites/4/2020/02/IG-annvmariv-1024x1016.jpg",
  active: false,
  username: "Mohamed",
  phoneNumber: "01556462676",
);

final UserModel monika2 = UserModel(
    id: "123",
    image:
        "https://ath2.unileverservices.com/wp-content/uploads/sites/4/2020/02/IG-annvmariv-1024x1016.jpg",
    active: true,
    phoneNumber: "01556462676",
    oneSignalID: null,
    username: "Monika");

final List<Message> messages = [
  Message(
      id: "234",
      date: DateTime.now(),
      from: mohamed.id,
      to: monika.id,
      type: MessageType.text,
      text: "hello, How Are you"),
  Message(
      id: "1236",
      date: DateTime.now(),
      from: monika.id,
      to: mohamed.id,
      type: MessageType.text,
      text: "iam Fine Thank you, how are you to ple"),
  Message(
      id: "134s",
      date: DateTime.now(),
      from: mohamed.id,
      to: monika.id,
      text: 'here an image',
      type: MessageType.image,
      link: "https://static.dw.com/image/45665028_303.jpg"),
  Message(
      id: "1234",
      date: DateTime.now(),
      from: monika.id,
      to: mohamed.id,
      text: 'here a great video',
      type: MessageType.video,
      link:
          "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4"),
  Message(
      id: "12345",
      date: DateTime.now(),
      type: MessageType.text,
      text: "This Video is not good",
      from: mohamed.id,
      to: monika.id),
  Message(
      id: "123",
      date: DateTime.now(),
      type: MessageType.text,
      text: "Take This",
      from: mohamed.id,
      to: monika.id),
  Message(
      id: "567",
      from: mohamed.id,
      to: monika.id,
      type: MessageType.audio,
      date: DateTime.now(),
      text: "",
      link: "https://luan.xyz/files/audio/ambient_c_motion.mp3")
];
