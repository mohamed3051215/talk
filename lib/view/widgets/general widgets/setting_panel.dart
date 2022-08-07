import 'package:chat_app/core/constants/colors.dart';
import 'package:chat_app/core/constants/fonts.dart';
import 'package:chat_app/core/controllers/profile_controller.dart';
import 'package:chat_app/view/widgets/general%20widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingPanel extends StatelessWidget {
  const SettingPanel({
    Key? key,
    this.isMyName = false,
    required this.text,
    required this.onPressed,
    this.func,
  }) : super(key: key);
  final bool isMyName;
  final String text;
  final Function onPressed;
  final Function? func;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 9),
      child: InkWell(
        borderRadius: BorderRadius.circular(200),
        onTap: () {
          onPressed();
        },
        child: Container(
            height: 68,
            width: Get.width,
            decoration: BoxDecoration(
              color: lightPurple,
              borderRadius: BorderRadius.circular(200),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text,
                    color: bluePurple,
                    fontSize: 18,
                    fontFamily: rRegular,
                  ),
                  isMyName
                      ? IconButton(
                          icon: Icon(Icons.edit, color: bluePurple),
                          onPressed: () {
                            Get.dialog(AlertDialog(
                              title: CustomText("Edit Name : ",
                                  color: lightPurple),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Obx(() => TextField(
                                        controller:
                                            Get.find<ProfileController>()
                                                .nameController
                                                .value,
                                      ))
                                ],
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Get.find<ProfileController>()
                                          .updateUser();
                                      Get.back();
                                      func!();
                                    },
                                    child:
                                        CustomText("Done", color: lightPurple)),
                                TextButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: CustomText("Cancel",
                                        color: lightPurple))
                              ],
                            ));
                          })
                      : SizedBox(),
                ],
              ),
            )),
      ),
    );
  }
}
