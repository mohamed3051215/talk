import 'package:chat_app/core/constants/colors.dart';
import 'package:chat_app/core/controllers/profile_controller.dart';
import 'package:chat_app/core/helpers/random_tag.dart';
import 'package:chat_app/core/models/user.dart';
import 'package:chat_app/core/service/firestore_service.dart';
import 'package:chat_app/view/screens/settings_screen.dart';
import 'package:chat_app/view/screens/view_image_screen.dart';

import 'package:chat_app/view/widgets/general%20widgets/custom_back_button.dart';
import 'package:chat_app/view/widgets/general%20widgets/custom_text.dart';
import 'package:chat_app/view/widgets/general%20widgets/logo.dart';
import 'package:chat_app/view/widgets/general%20widgets/setting_panel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserModel? _userModel;

  final User? user = FirebaseAuth.instance.currentUser;
  late String tag;
  bool loading = true;
  @override
  void initState() {
    super.initState();
    _setuser();
  }

  _setuser() {
    setState(() {
      loading = true;
    });
    FirestoreService.getUserModelFromId(widget.user.uid)
        .then((UserModel userModel) {
      setState(() {
        _userModel = userModel;
        tag = getRandomString(3);
        loading = false;
      });
    });
  }

  buildBottomSheet() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: Row(
            children: [
              CustomText(
                "Camera",
                color: lightPurple,
                fontSize: 18,
              ),
            ],
          ),
          leading: Icon(
            Icons.camera_alt_outlined,
            color: lightPurple,
            size: 40,
          ),
          onTap: () {
            Get.back(result: "camera");
          },
        ),
        ListTile(
          title: Row(
            children: [
              CustomText(
                "Gallary",
                color: lightPurple,
                fontSize: 18,
              ),
            ],
          ),
          leading: Icon(
            Icons.camera_alt_outlined,
            color: lightPurple,
            size: 40,
          ),
          onTap: () {
            Get.back(result: "gellary");
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          title: Logo(),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: CustomBackButton(),
          automaticallyImplyLeading: false,
        ),
        body: loading
            ? Center(
                child: CircularProgressIndicator(
                color: lightPurple,
              ))
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 40, bottom: 30),
                          child: Center(
                            child: Container(
                              width: Get.width - 130,
                              height: Get.width - 130,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: lightPurple, width: 7),
                                  shape: BoxShape.circle),
                              child: InkWell(
                                onTap: () {
                                  Get.to(() => ViewImageScreen(
                                      link: _userModel!.image, tag: tag));
                                },
                                child: CircleAvatar(
                                  backgroundImage: _userModel!.image == ""
                                      ? AssetImage("assets/images/unknwon.png")
                                      : NetworkImage(_userModel!.image)
                                          as ImageProvider,
                                ),
                              ),
                            ),
                          ),
                        ),
                        _userModel!.active
                            ? _userModel!.id !=
                                    FirebaseAuth.instance.currentUser!.uid
                                ? Positioned(
                                    bottom: 50,
                                    right: 90,
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: lightBlue, width: 3),
                                          shape: BoxShape.circle,
                                          color: Color(0xff00FF19)),
                                    ),
                                  )
                                : Positioned(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: lightPurple,
                                          shape: BoxShape.circle),
                                      child: IconButton(
                                          iconSize: 30,
                                          icon: Icon(Icons.camera_alt),
                                          onPressed: () async {
                                            final ProfileController controller =
                                                Get.find<ProfileController>();
                                            await controller
                                                .pick(buildBottomSheet());
                                            await controller.done();
                                            _setuser();
                                          }),
                                    ),
                                    right: 65,
                                    bottom: 40,
                                  )
                            : SizedBox(),
                      ],
                    ),
                    SettingPanel(
                      isMyName: true,
                      text: "Name: ${_userModel!.username}",
                      onPressed: () {},
                      func: _setuser,
                    ),
                    SettingPanel(
                      isMyName: false,
                      text: "phone: ${_userModel!.phoneNumber}",
                      onPressed: () {},
                    ),
                    SettingPanel(
                      isMyName: false,
                      text: "Chat Now",
                      onPressed: () {
                        Get.back();
                      },
                    ),
                    _userModel!.id != widget.user.uid
                        ? SettingPanel(
                            isMyName: false,
                            text: "Delete Contact",
                            onPressed: () {},
                          )
                        : SettingPanel(
                            isMyName: false,
                            text: "Settings",
                            onPressed: () {
                              Get.to(() => SettingsScreen());
                            },
                          ),
                  ],
                ),
              ));
  }
}
