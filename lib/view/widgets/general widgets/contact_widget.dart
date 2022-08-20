import '../../../core/constants/colors.dart';
import '../../../core/constants/fonts.dart';
import '../../../core/controllers/chat_controller.dart';
import '../../../core/controllers/home_screen_controller.dart';
import '../../../core/models/contact.dart';
import '../../../core/models/user.dart';
import '../../screens/chat_screen.dart';
import '../general%20widgets/custom_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactWidget extends StatelessWidget {
  final ChatContact contact;
  final UserModel user;

  const ContactWidget({Key? key, required this.contact, required this.user})
      : super(key: key);

  String getStringDate() {
    if (contact.lastMesssage != null) {
      final int hours = contact.lastMesssage!.date.hour;
      final int mins = contact.lastMesssage!.date.minute;
      final int day = contact.lastMesssage!.date.day;
      final int month = contact.lastMesssage!.date.month;
      final int year = contact.lastMesssage!.date.year;
      final String dateString = "$hours:$mins $day-$month-$year";
      return dateString;
    }
    return "";
  }

  Map<String, Stream<DatabaseEvent>> getMap(HomeScreenController controller) {
    return controller.activeUsers.where((p0) {
      return p0.keys.first == contact.contactUser.id;
    }).toList()[0];
  }

  @override
  Widget build(BuildContext context) {
    final HomeScreenController _homeController =
        Get.find<HomeScreenController>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: InkWell(
        onTap: () async {
          final HomeScreenController homeController =
              Get.find<HomeScreenController>();
          final int index = homeController.contacts.indexOf(contact);
          final String chatId = homeController.allUsersChatId[index];

          Get.put(ChatController(contact.contactUser.id));

          Get.to(() => ChatScreen());
        },
        child: Container(
            width: Get.width,
            height: 78,
            child: Row(
              children: [
                Container(
                  width: 65,
                  height: 65,
                  child: Stack(children: [
                    CircleAvatar(
                      minRadius: 30,
                      maxRadius: 30,
                      backgroundImage: NetworkImage(contact.contactUser.image),
                    ),
                    StreamBuilder(
                        stream: getMap(_homeController)
                            .values
                            .first
                            .asBroadcastStream(),
                        builder: (BuildContext context,
                            AsyncSnapshot<DatabaseEvent> snapshot) {
                          if (snapshot.hasData) {
                            var data = snapshot.data!.snapshot.value.toString();

                            bool active = data[9] == "t";
                            if (active)
                              return Positioned(
                                bottom: 5,
                                right: 5,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: lightBlue, width: 3),
                                      shape: BoxShape.circle,
                                      color: Color(0xff00FF19)),
                                ),
                              );
                            else
                              return SizedBox();
                          } else {
                            return SizedBox();
                          }
                        })
                  ]),
                ),
                SizedBox(
                  width: 6,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: Get.width - 130,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 8, 0, 6),
                            child: Container(
                              width: Get.width - 140,
                              child: CustomText(
                                contact.contactUser.username,
                                fontFamily: rMedium,
                                fontSize: 20,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ),
                          Spacer(),
                          CustomText(
                            getStringDate(),
                            fontSize: 12,
                            fontFamily: "",
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: Get.width - 130,
                      child: Row(
                        children: [
                          Container(
                            width: Get.width - 160,
                            child: contact.lastMesssage != null
                                ? CustomText(
                                    contact.lastMesssage!.text,
                                    color: Colors.white,
                                    fontFamily: rMedium,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                : SizedBox(),
                          ),
                          Spacer(),
                          contact.messagesNotSeen != 0
                              ? Container(
                                  width: 15,
                                  height: 15,
                                  decoration: BoxDecoration(
                                      color: lightPurple,
                                      shape: BoxShape.circle),
                                  child: Center(
                                    child: CustomText(
                                      contact.messagesNotSeen.toString(),
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ))
                              : SizedBox()
                        ],
                      ),
                    )
                  ],
                )
              ],
            )),
      ),
    );
  }
}
