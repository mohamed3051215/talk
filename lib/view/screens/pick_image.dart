import 'dart:io';

import 'package:chat_app/core/constants/colors.dart';
import 'package:chat_app/core/constants/fonts.dart';
import 'package:chat_app/core/controllers/image_picker_controller.dart';
import 'package:chat_app/view/widgets/general%20widgets/custom_text.dart';
import 'package:chat_app/view/widgets/general%20widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PickImageScreen extends StatelessWidget {
  const PickImageScreen({Key? key}) : super(key: key);
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
    final ImagePickerController controller = Get.put(ImagePickerController());
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Logo(),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() => AnimatedOpacity(
                    opacity: controller.opacity.value,
                    duration: Duration(milliseconds: 500),
                    child: AnimatedPadding(
                        padding: EdgeInsets.only(
                            top: controller.padding.value, bottom: 30),
                        duration: Duration(milliseconds: 500),
                        child: Center(
                            child: CustomText(
                          "You have to pick an image",
                          color: lightPurple,
                          fontSize: 26,
                          fontFamily: rBold,
                        ))),
                  )),
              GetBuilder<ImagePickerController>(
                builder: (controller) {
                  return Stack(
                    children: [
                      Container(
                        width: Get.width - 80,
                        height: Get.width - 80,
                        decoration: BoxDecoration(
                          color: lightPurple,
                          shape: BoxShape.circle,
                        ),
                        child: controller.path == null
                            ? Image.asset(
                                "assets/images/unknwon.png",
                                fit: BoxFit.cover,
                              )
                            : CircleAvatar(
                                backgroundImage: FileImage(
                                  File(controller.path!.value),
                                ),
                              ),
                      ),
                      Positioned(
                        child: Container(
                          decoration: BoxDecoration(
                              color: lightPurple, shape: BoxShape.circle),
                          child: IconButton(
                              iconSize: 50,
                              icon: Icon(Icons.camera_alt),
                              onPressed: () {
                                controller.pick(buildBottomSheet());
                              }),
                        ),
                        right: 10,
                        bottom: 10,
                      )
                    ],
                  );
                },
              ),
            ],
          ),
          GetBuilder<ImagePickerController>(builder: (controller) {
            return controller.path != null
                ? Positioned(
                    child: Container(
                      child: MaterialButton(
                        onPressed: () {
                          controller.done();
                        },
                        child: CustomText(
                          "Done",
                          fontSize: 18,
                          color: lightPurple,
                        ),
                      ),
                    ),
                    right: 20,
                    bottom: 20)
                : SizedBox();
          })
        ],
      ),
    );
  }
}
