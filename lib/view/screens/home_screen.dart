import '../../core/constants/colors.dart';
import '../../core/constants/fake_data.dart';
import '../../core/constants/fonts.dart';
import '../../core/controllers/home_screen_controller.dart';
import '../../core/controllers/tab_controller.dart';
import '../../core/enums/call_state.dart';
import '../../core/models/call.dart';
import '../../core/models/contact.dart';
import '../widgets/general%20widgets/calls_widget.dart';
import '../widgets/general%20widgets/contact_widget.dart';
import '../widgets/general%20widgets/custom_text.dart';
import '../widgets/general%20widgets/logo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  final CustomTabController tabController = Get.put(CustomTabController());

  @override
  Widget build(BuildContext context) {
    final HomeScreenController controller = Get.put(HomeScreenController());

    return SafeArea(
      child: Scaffold(
        backgroundColor: bgColor,
        body: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 17.0),
                  child: Logo(),
                ),
                Obx(() => AnimatedPadding(
                      duration: Duration(milliseconds: 300),
                      padding: controller.isMenuOpened.value
                          ? const EdgeInsets.fromLTRB(8, 8, 40, 8)
                          : EdgeInsets.all(8),
                      child: PopupMenuButton(
                        color: lightPurple,
                        offset: Offset(50, 55),
                        elevation: 10,
                        onCanceled: () {
                          tabController.showed = false;
                        },
                        onSelected: (v) async {
                          switch (v) {
                            case "logout":
                              await controller.logOut();
                              break;
                            case "profile":
                              controller.goProfile();
                              break;
                            case "settings":
                              controller.goSettings();
                              break;
                            case "aboutus":
                              controller.aboutUs();
                              break;
                            default:
                          }
                          tabController.showed = false;
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        itemBuilder: (BuildContext context) {
                          tabController.showed = true;

                          return [
                            PopupMenuItem(
                              height: 30,
                              child: Center(
                                child: CustomText(
                                  "Profile",
                                  fontFamily: rMedium,
                                ),
                              ),
                              value: "profile",
                            ),
                            PopupMenuItem(
                              height: 30,
                              child: Column(
                                children: [
                                  Divider(
                                    color: lightBlue,
                                  ),
                                  Center(
                                    child: CustomText(
                                      "Settings",
                                      fontFamily: rMedium,
                                    ),
                                  ),
                                ],
                              ),
                              value: "settings",
                            ),
                            PopupMenuItem(
                              height: 30,
                              child: Column(
                                children: [
                                  Divider(
                                    color: lightBlue,
                                  ),
                                  Center(
                                    child: CustomText(
                                      "About Us",
                                      fontFamily: rMedium,
                                    ),
                                  ),
                                ],
                              ),
                              value: "aboutus",
                            ),
                            PopupMenuItem(
                              height: 30,
                              child: Column(
                                children: [
                                  Divider(
                                    color: lightBlue,
                                  ),
                                  Center(
                                    child: CustomText(
                                      "Logout",
                                      fontFamily: rMedium,
                                    ),
                                  ),
                                ],
                              ),
                              value: "logout",
                            ),
                          ];
                        },
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              child: controller.userModel != null
                                  ? FittedBox(
                                      child: StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection("users")
                                              .doc(controller.userModel!.id)
                                              .snapshots(),
                                          builder: (context,
                                              AsyncSnapshot snapshot) {
                                            if (snapshot.hasData)
                                              return Container(
                                                width: 35,
                                                height: 35,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            snapshot
                                                                .data["image"]),
                                                        fit: BoxFit.fill)),
                                              );
                                            else
                                              return Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                color: lightPurple,
                                              ));
                                          }),
                                      fit: BoxFit.fill,
                                    )
                                  : Center(
                                      child: CircularProgressIndicator(
                                      color: lightPurple,
                                    )),
                            ),
                            Positioned(
                                top: 25,
                                left: -5,
                                child: Obx(() => Icon(
                                      tabController.isShowed.value
                                          ? Icons.arrow_drop_up
                                          : Icons.arrow_drop_down,
                                      color: lightPurple,
                                      size: 50,
                                    )))
                          ],
                        ),
                      ),
                    )),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            SizedBox(
              height: 17,
            ),
            Obx(() => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    height: 38,
                    width: Get.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: lightBlue, width: .3)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              tabController.isContact = false;
                            },
                            child: Container(
                              height: 35,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      bottomLeft: Radius.circular(15)),
                                  color: tabController.isContacts.value
                                      ? bgColor
                                      : lightPurple),
                              child: Center(
                                child: CustomText(
                                  "Calls",
                                  fontFamily: rMedium,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                        VerticalDivider(
                          color: lightBlue,
                          width: 1,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              tabController.isContact = true;
                            },
                            child: Container(
                              height: 38,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(15),
                                      bottomRight: Radius.circular(15)),
                                  color: tabController.isContacts.value
                                      ? lightPurple
                                      : bgColor),
                              child: Center(
                                child: CustomText(
                                  "Contacts",
                                  fontFamily: rMedium,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
            SizedBox(
              height: 40,
            ),
            Obx(() => Container(
                  child: tabController.isContacts.value
                      ? GetBuilder<HomeScreenController>(
                          builder: (controller) {
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: controller.contacts.length,
                              itemBuilder: (BuildContext context, int index) {
                                final ChatContact contact =
                                    controller.contacts[index];
                                return ContactWidget(
                                    contact: contact,
                                    user: controller.userModel!);
                              },
                            );
                          },
                        )
                      : Column(
                          children: [
                            CallWidget(
                                call: Call(
                                    date: DateTime.now(),
                                    from: mohamed,
                                    to: monika,
                                    callState: CallState.answered)),
                            CallWidget(
                                call: Call(
                                    date: DateTime.now(),
                                    from: monika2,
                                    to: mohamed,
                                    callState: CallState.missed))
                          ],
                        ),
                ))
          ],
        ),
      ),
    );
  }
}
