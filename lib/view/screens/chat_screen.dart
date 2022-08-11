import 'package:chat_app/core/constants/colors.dart';

import 'package:chat_app/core/constants/fonts.dart';
import 'package:chat_app/core/controllers/chat_controller.dart';
import 'package:chat_app/core/models/message.dart';
import 'package:chat_app/core/models/user.dart';
import 'package:chat_app/view/widgets/general%20widgets/circular_button.dart';
import 'package:chat_app/view/widgets/general%20widgets/custom_text.dart';
import 'package:chat_app/view/widgets/message%20collections/message_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/enums/call_type.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatController controller = Get.find<ChatController>();

  @override
  void dispose() {
    super.dispose();
    Get.delete<ChatController>();
  }

  InputBorder inputBorder() {
    return OutlineInputBorder(borderRadius: BorderRadius.circular(30));
  }

  String getText(Duration duration) {
    final int allSeconds = duration.inSeconds;
    final int seconds = allSeconds % 60;
    final int minutes = duration.inMinutes;

    return "$minutes:${seconds.toString().length == 1 ? '0$seconds' : seconds}";
  }

  @override
  Widget build(BuildContext context) {
    final UserModel chattingUser = controller.userModel!;
    return Scaffold(
      backgroundColor: bgColor,
      appBar: PreferredSize(
        preferredSize: Size(Get.width, 70),
        child: AppBar(
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.phone, color: lightPurple),
              onPressed: () {
                controller.call(CallType.voiceCall);
              },
            ),
            IconButton(
              icon: Icon(Icons.videocam, color: lightPurple),
              onPressed: () {
                controller.call(CallType.videoCall);
              },
            ),
            IconButton(
              icon: Icon(Icons.more_vert, color: lightPurple),
              onPressed: () {},
            ),
          ],
          title: Container(
            height: 50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  chattingUser.username,
                  fontFamily: rMedium,
                  fontSize: 20,
                ),
                Spacer(),
                CustomText(chattingUser.active ? "Active Now" : "Offline")
              ],
            ),
          ),
          leadingWidth: 90,
          leading: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BackButton(
                color: lightPurple,
                onPressed: () {
                  Get.back();
                },
              ),
              Container(
                width: 40,
                height: 65,
                child: Stack(children: [
                  CircleAvatar(
                    minRadius: 30,
                    maxRadius: 30,
                    backgroundImage: NetworkImage(chattingUser.image),
                  ),
                  StreamBuilder(
                      stream: controller.activeStream,
                      builder: (BuildContext context, snapshots) {
                        return Positioned(
                          bottom: 5,
                          right: 1,
                          child: Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                                border: Border.all(color: lightBlue, width: 3),
                                shape: BoxShape.circle,
                                color: Color(0xff00FF19)),
                          ),
                        );
                      })
                ]),
              ),
            ],
          ),
          backgroundColor: bgColor,
          bottom: PreferredSize(
            child: Divider(
              color: lightBlue,
            ),
            preferredSize: Size(Get.width, 2),
          ),
        ),
      ),
      body: Container(
        height: Get.height - 100,
        width: Get.width,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: Get.height - 100 - 50,
                width: Get.width,
                child: Obx(() => ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.messages.length,
                    reverse: true,
                    itemBuilder: (BuildContext context, int index) {
                      final Message message = controller.messages[index];

                      return MessageWidget(
                          message: message, chatId: controller.chatId);
                    })),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: Container(
                    // height: 50,
                    width: Get.width,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Obx(() => CircularButton(
                            isExists: true,
                            onPressEnd: () {
                              !controller.isSend.value
                                  ? controller.endRecording()
                                  : print("should send text image");
                            },
                            onPressStart: () {
                              !controller.isSend.value
                                  ? controller.startRecording()
                                  : print("should send text image");
                            },
                            onPressed: () {
                              controller.isSend.value
                                  ? controller.sendMessage()
                                  : print("should record");
                            },
                            widget: !controller.isRecording.value
                                ? Icon(
                                    controller.isSend.value
                                        ? Icons.send
                                        : Icons.keyboard_voice_rounded,
                                    size: 30,
                                    color: bluePurple)
                                : Obx(() => Container(
                                      child: CustomText(
                                          getText(controller.duration.value),
                                          color: bluePurple),
                                    )))),
                        CircularButton(
                            onPressEnd: () {},
                            onPressStart: () {},
                            isExists: true,
                            onPressed: () {},
                            widget:
                                Icon(Icons.image, size: 30, color: bluePurple)),
                        SizedBox(
                          width: 3,
                        ),
                        Obx(() => Container(
                              width: Get.width - 54 * 2 - 19,
                              height: controller.inputHeight.value,
                              child: GetBuilder<ChatController>(
                                builder: (controller) {
                                  return TextField(
                                    controller: controller.messageController,
                                    decoration: InputDecoration(
                                        fillColor: lightBlue,
                                        filled: true,
                                        hintText: "Type something ...",
                                        border: inputBorder(),
                                        hintStyle: TextStyle(
                                            color: bluePurple, fontSize: 18),
                                        enabledBorder: inputBorder(),
                                        focusedBorder: inputBorder(),
                                        disabledBorder: inputBorder(),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10)),
                                    textInputAction: TextInputAction.newline,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    style: TextStyle(
                                        color: bluePurple, fontSize: 18),
                                  );
                                },
                              ),
                            ))
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
