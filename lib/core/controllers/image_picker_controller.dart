import 'sign_up_controller.dart';
import 'tab_controller.dart';
import '../service/firestore_service.dart';
import '../service/storage_service.dart';
import '../service/user_status_service.dart';
import '../../view/screens/home_screen.dart';
import '../../view/widgets/general%20widgets/loading_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerController extends GetxController {
  RxDouble padding = 0.0.obs;
  RxString? path;
  RxDouble opacity = 0.0.obs;
  final UserStatuesService _userStatuesService = UserStatuesService();
  ImagePicker _picker = ImagePicker();
  final StorageService _storageService = StorageService();

  @override
  Future<void> onInit() async {
    super.onInit();
    await Future.delayed(Duration(seconds: 1));
    padding.value = 30;
    opacity.value = 1;
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
    final SignUpController _signUpController = Get.find<SignUpController>();
    final String link = await _storageService.storeUserImage(path!.value);
    await FirestoreService.addUser(
        _signUpController.username.text,
        _signUpController.dialCodee + _signUpController.phone.text,
        FirebaseAuth.instance.currentUser!,
        _signUpController.password.text,
        link,
        "");
    await _userStatuesService.addUser(FirebaseAuth.instance.currentUser!.uid);
    Get.back();
    Get.put(CustomTabController());
    Get.to(HomeScreen());
  }
}
