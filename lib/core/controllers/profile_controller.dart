import 'dart:io';

import 'home_screen_controller.dart';
import '../helpers/show_error.dart';
import '../service/firestore_service.dart';
// import 'package:chat_app/core/service/storage_service.dart';
import 'package:chat_app/view/widgets/general%20widgets/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  final Rx<TextEditingController> nameController = TextEditingController().obs;

  ImagePicker _picker = ImagePicker();
  // final StorageService _storageService = StorageService();
  RxString? path;

  @override
  onInit() {
    super.onInit();
    nameController.value.text =
        Get.find<HomeScreenController>().userModel!.username;
  }

  updateUser() async {
    if (nameController.value.text.length > 3) {
      FirestoreService.editName(nameController.value.text);
    } else
      showError("Invalid name, Please try again with  real name");
  }

  pick(Widget bottomSheet) async {
    final String option = await Get.bottomSheet(
      BottomSheet(
        onClosing: () {},
        builder: (BuildContext context) {
          return bottomSheet;
        },
      ),
    );

    if (option == 'camera') {
      final XFile? xfile =
          await _picker.pickImage(source: ImageSource.camera, imageQuality: 20);
      if (xfile != null) {
        path = xfile.path.obs;
        update();
      }
    } else if (option == "gellary") {
      final XFile? xfile = await _picker.pickImage(
          source: ImageSource.gallery, imageQuality: 20);
      if (xfile != null) {
        path = xfile.path.obs;
        update();
      }
    } else {
      printInfo(info: "Option is : " + option);
    }
  }

  done() async {
    Get.dialog(LoadingDialog());

    await FirestoreService.changeImage(File(path!.value));

    Get.back();
  }
}
