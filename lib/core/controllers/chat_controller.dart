import 'dart:async';
import 'dart:io';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

import '../../view/screens/video_call_screen.dart';
import '../../view/screens/voice_call_screen.dart';
import '../enums/call_type.dart';
import '../enums/message_type.dart';
import '../helpers/random_tag.dart';
import '../helpers/show_error.dart';
import '../models/contact.dart';
import '../models/message.dart';
import '../models/user.dart';
import '../service/firestore_service.dart';
import '../service/local_storage_service.dart';
import '../service/storage_service.dart';
import '../service/user_status_service.dart';
import 'home_screen_controller.dart';

class ChatController extends GetxController {
  UserModel? userModel;
  RxBool isRecording = false.obs;
  final HomeScreenController homeController = Get.find<HomeScreenController>();
  final String userId;
  ChatController(this.userId, {this.userModel, this.chatId});
  RxList<Message> messages = <Message>[].obs;
  final UserStatuesService _userStatuesService = UserStatuesService();

  RxBool isSend = false.obs;
  var chatId;
  final LocalStorageService _cacheService = LocalStorageService();
  // ignore: cancel_subscriptions
  late StreamSubscription messageStream;
  final TextEditingController messageController = TextEditingController();
  late Stream<DatabaseEvent> activeStream;
  RxDouble inputHeight = 50.0.obs;
  bool hasPermission = false;
  final Record _audioRecorder = Record();
  Timer? _timer;
  Rx<Duration> duration = Duration(seconds: 0).obs;
  late RtcEngine _agoraEngine;
  RxInt remoteUID = 0.obs;

  Rx<Offset> position = Offset(10, 10).obs;
  bool isInCall = false;
  @override
  Future<void> onInit() async {
    super.onInit();
    _setUserModelAndChatId();
    _askForPermissions();
    _setupMessageStream();
    _setupActiveStream();
    _setMessageController();
  }

  _setUserModelAndChatId() {
    if (userModel == null) {
      ChatContact contact = homeController.contacts
          .firstWhere((user) => user.contactUser.id == userId);
      userModel = contact.contactUser;
      final int index = homeController.contacts.indexOf(contact);
      chatId = homeController.allUsersChatId[index];
      printInfo(info: "cantacta is : kj $contact");
    }
  }

  _setMessageController() {
    messageController.addListener(_checkInputHeight);
  }

  RtcEngine get agoraEngine => _agoraEngine;
  _setupActiveStream() {
    activeStream = _userStatuesService.userStatues(userModel!.id);
  }

  _setupMessageStream() async {
    // bool gotData = false;
    messageStream = FirebaseFirestore.instance
        .collection("chat")
        .doc(chatId)
        .collection("messages")
        .orderBy("date", descending: false)
        .snapshots()
        .listen((QuerySnapshot<Map<String, dynamic>> event) {
      event.docChanges.forEach((e) async {
        bool newItem = true;

        Message _message = Message.fromJson(e.doc.data()!);
        messages.forEach((element) {
          if (element.id == _message.id) {
            newItem = false;
          }
        });

        if (newItem) {
          messages.insert(0, _message);
        } else
          printInfo(info: "Already Exists");
        FirebaseFirestore.instance
            .collection("chat")
            .doc(chatId)
            .collection("messages")
            .orderBy("date", descending: true)
            .limit(1)
            .get()
            .then((value) {
          printInfo(info: "Messge Id is :" + value.docs[0]["id"]);
        });

        update();
      });
    });
  }

  _startTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      duration.value += Duration(milliseconds: 100);
    });
  }

  _stopTimer() {
    _timer?.cancel();
    duration.value = Duration(seconds: 0);
  }

  void _checkInputHeight() async {
    messageController.text.isNotEmpty
        ? isSend.value = true
        : isSend.value = false;
    int count = messageController.text.split('\n').length;
    if (count == 0 && inputHeight.value == 50.0) {
      return;
    }
    if (count <= 5) {
      var newHeight = count == 0 ? 50.0 : 28.0 + (count * 18.0);
      inputHeight.value = newHeight;
    }
  }

  startRecording() async {
    _stopTimer();
    isRecording.value = true;
    await Future.delayed(Duration(seconds: 1));
    // final String fileName = getRandomString(12);
    // final String path =
    //     (await pv.getExternalStorageDirectory())!.path + "/audio/$fileName.m4a";
    if (hasPermission && isRecording.value) {
      _startTimer();
      // Directory dir = Directory.fromUri(Uri.parse(path));

      _audioRecorder.start();
    } else {
      showError("Please allow using microphone to send voice messages");
    }
  }

  endRecording() async {
    isRecording.value = false;
    final DateTime dateTime = DateTime.now();
    final String? path = await _audioRecorder.stop();
    _stopTimer();

    final String messageId = getRandomString(6);
    _cacheService.storeLocalAudio(
        chatId: chatId, messageId: messageId, path: path!);
    StorageService()
        .uploadMessageAudio(File(path), chatId, messageId)
        .then((link) {
      FirebaseFirestore.instance
          .collection("chat")
          .doc(chatId)
          .collection("messages")
          .doc(messageId)
          .update({"link": link});
    });
    final Message message = Message(
        from: Get.find<HomeScreenController>().userModel!.id,
        to: userModel!.id,
        date: dateTime,
        id: messageId,
        chatId: chatId,
        text: '',
        type: MessageType.audio,
        link: null);
    FirestoreService.sendMessage(message, userModel!, chatId);
    // OneSignalService().sendMessage(userModel: userModel, message: message);
  }

  _askForPermissions() async {
    hasPermission = await _audioRecorder.hasPermission();
    await ph.Permission.manageExternalStorage.request();
    await ph.Permission.storage.request();
  }

  sendMessage() async {
    final String text = messageController.text;
    messageController.text = '';

    update();

    final Message message = Message(
        id: getRandomString(10),
        type: MessageType.text,
        text: text,
        chatId: chatId,
        date: DateTime.now(),
        from: Get.find<HomeScreenController>().userModel!.id,
        to: userModel!.id);
    FirestoreService.sendMessage(message, userModel!, chatId);
  }

  call(CallType type) {
    if (type == CallType.videoCall) {
      Get.to(() => VideoCallScreen());
      printInfo(info: "Started to call");
      isInCall = true;
    } else if (type == CallType.voiceCall) {
      Get.to(VoiceCallScreen());
      isInCall = true;
    } else {
      printInfo(info: "Some Error happened #9862");
    }
  }

  @override
  void dispose() {
    super.dispose();
    messageStream.cancel();
  }
}
