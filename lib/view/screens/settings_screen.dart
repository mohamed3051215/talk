import 'package:flutter/material.dart';

import '../../core/constants/colors.dart';
import '../../core/constants/fake_data.dart';
import '../../core/enums/message_type.dart';
import '../../core/helpers/generate_random_string.dart';
import '../../core/models/contact.dart';
import '../../core/models/message.dart';
import '../../core/service/message_storing_service.dart';
import '../widgets/general widgets/custom_text.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({Key? key}) : super(key: key);
  final MessageStoringService service = MessageStoringService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(),
              ElevatedButton(
                  onPressed: () async {
                    print(await service.getMessages("dsyogfysdgyu"));
                  },
                  child: CustomText(
                    "get all messages",
                    fontSize: 20,
                  )),
              ElevatedButton(
                  onPressed: () async {
                    await service.deleteDatabaseFile();
                  },
                  child: CustomText(
                    "delete data base",
                    fontSize: 20,
                  )),
              ElevatedButton(
                  onPressed: () async {
                    await service.init();
                  },
                  child: CustomText(
                    "Init database",
                    fontSize: 20,
                  )),
              ElevatedButton(
                  onPressed: () {
                    service.addMessage(Message(
                        chatId: "dsyogfysdgyu",
                        id: generateRandomString(10),
                        type: MessageType.text,
                        text: generateRandomString(50),
                        date: DateTime.now(),
                        from: mohamed.id,
                        to: monika.id));
                    service.addMessage(messages[0]);
                  },
                  child: CustomText(
                    "Add message",
                    fontSize: 20,
                  )),
              ElevatedButton(
                  onPressed: () async {
                    await service.addUser(mohamed);
                  },
                  child: CustomText(
                    "add user",
                    fontSize: 20,
                  )),
              ElevatedButton(
                  onPressed: () async {
                    print(await service.getUsers());
                  },
                  child: CustomText(
                    "get all users",
                    fontSize: 20,
                  )),
              ElevatedButton(
                  onPressed: () async {
                    print(await service.getMyUser());
                  },
                  child: CustomText(
                    "get my user",
                    fontSize: 20,
                  )),
              ElevatedButton(
                  onPressed: () async {
                    await service.addMyUser(mohamed);
                  },
                  child: CustomText(
                    "add my user",
                    fontSize: 20,
                  )),
              ElevatedButton(
                  onPressed: () async {
                    await service.addCall(calls[3]);
                  },
                  child: CustomText(
                    "add call",
                    fontSize: 20,
                  )),
              ElevatedButton(
                  onPressed: () async {
                    print(await service.getContacts());
                  },
                  child: CustomText(
                    "get all contacts",
                    fontSize: 20,
                  )),
              ElevatedButton(
                  onPressed: () async {
                    await service.addContact(
                      ChatContact(
                          chatId: "dsyogfysdgyu",
                          messagesNotSeen: 2,
                          contactUser: mohamed,
                          lastMesssage: messages[0]),
                    );
                  },
                  child: CustomText(
                    "add contact",
                    fontSize: 20,
                  )),
              ElevatedButton(
                  onPressed: () async {
                    print(await service.getLastMessage("dsyogfysdgyu"));
                  },
                  child: CustomText(
                    "get last message",
                    fontSize: 20,
                  )),
              ElevatedButton(
                  onPressed: () {},
                  child: CustomText(
                    "get all messages",
                    fontSize: 20,
                  )),
              ElevatedButton(
                  onPressed: () {},
                  child: CustomText(
                    "get all messages",
                    fontSize: 20,
                  )),
              ElevatedButton(
                  onPressed: () {},
                  child: CustomText(
                    "get all messages",
                    fontSize: 20,
                  )),
              ElevatedButton(
                  onPressed: () {},
                  child: CustomText(
                    "get all messages",
                    fontSize: 20,
                  )),
            ]),
      ),
    );
  }
}
