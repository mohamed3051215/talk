import '../../core/constants/colors.dart';
import '../../core/constants/fonts.dart';
import '../../core/constants/images.dart';
import '../../core/constants/titles.dart';
import '../../core/controllers/splash_controller.dart';
import '../widgets/general%20widgets/custom_text.dart';
import '../widgets/general%20widgets/logo.dart';
import '../widgets/general%20widgets/page_ciew_circle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SplashController controller = Get.find<SplashController>();
    return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          title: Logo(),
          centerTitle: true,
          backgroundColor: bgColor,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Container(
            height: Get.height,
            width: Get.width,
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: Get.width,
                  height: Get.height - 260,
                  child: PageView.builder(
                      controller: controller.pageController,
                      onPageChanged: (int indx) =>
                          controller.index.value = indx,
                      itemCount: 3,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            Container(
                                width: Get.width,
                                height: Get.height - 400,
                                child: Image.asset(images[index],
                                    fit: BoxFit.cover)),
                            SizedBox(
                              height: 20,
                            ),
                            CustomText(
                              titles[index],
                              fontSize: 40,
                              fontFamily: osSemiBold,
                              maxLines: 2,
                            )
                          ],
                        );
                      }),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 40,
                      child: ListView.builder(
                          itemCount: 3,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                controller.index.value = index;
                                controller.pageController.animateToPage(index,
                                    duration: Duration(milliseconds: 400),
                                    curve: Curves.ease);
                              },
                              child: Obx(() => PageCircle(
                                  value: controller.index.value, index: index)),
                            );
                          }),
                    )
                  ],
                ),
                Expanded(child: SizedBox()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      child: MaterialButton(
                          onPressed: () => controller.next(),
                          child: Row(
                            children: [
                              Obx(() => CustomText(
                                    controller.index.value != 2
                                        ? "Next "
                                        : "Finish",
                                    fontSize: 18,
                                    color: lightPurple,
                                  )),
                              RotatedBox(
                                quarterTurns: 2,
                                child: Icon(
                                  Icons.arrow_back,
                                  color: lightPurple,
                                ),
                              )
                            ],
                          )),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
