import 'dart:io';

import 'package:dio/dio.dart';
import 'package:external_path/external_path.dart';
import 'package:get/get_utils/src/extensions/dynamic_extensions.dart';
import 'package:permission_handler/permission_handler.dart';

class LocalStorageService {
  LocalStorageService._privateConstructor();

  static final LocalStorageService _instance =
      LocalStorageService._privateConstructor();

  factory LocalStorageService() {
    return _instance;
  }
  Future<String?> storeAudio(
      {required String id,
      required String link,
      required String chatId}) async {
    String dir = (await ExternalPath.getExternalStorageDirectories())[0];

    Directory.fromUri(Uri.parse(dir + "/talk/")).createSync();
    Directory.fromUri(Uri.parse(dir + "/talk/audio/")).createSync();
    Directory.fromUri(Uri.parse(dir + "/talk/audio/" + chatId + "/"))
        .createSync();
    dir += '/talk/audio/$chatId/';
    final Directory _dir = Directory.fromUri(Uri.parse(dir));
    if (!(await _dir.exists())) {
      await _dir.create();
    }
    final Dio dio = Dio();
    Response response = await dio.download(link, _dir.path + '$id.m4a');

    printInfo(info: "DIRECTORY IS : ${response.data}");
    return "$dir/$id.m4a";
  }

  storeLocalAudio(
      {required String messageId,
      required String path,
      required String chatId}) async {
    String dir = (await ExternalPath.getExternalStorageDirectories())[0];
    File mainAudioFile = File.fromUri(Uri.parse(path));

    Directory.fromUri(Uri.parse(dir + "/talk/")).createSync();
    Directory.fromUri(Uri.parse(dir + "/talk/audio/")).createSync();
    Directory.fromUri(Uri.parse(dir + "/talk/audio/" + chatId + "/"))
        .createSync();
    dir += '/talk/audio/$chatId/';
    final Directory _dir = Directory.fromUri(Uri.parse(dir));
    if (!(await _dir.exists())) {
      await _dir.create();
    }
    final data = mainAudioFile.readAsBytesSync();
    File(_dir.path + '$messageId.m4a').writeAsBytesSync(data);
  }

  Future<String?> getAudio({required String id, required String chatId}) async {
    String dir = (await ExternalPath.getExternalStorageDirectories())[0];
    Directory.fromUri(Uri.parse(dir + "/talk/")).createSync();
    Directory.fromUri(Uri.parse(dir + "/talk/audio/")).createSync();
    Directory.fromUri(Uri.parse(dir + "/talk/audio/" + chatId + "/"))
        .createSync();
    dir += '/talk/audio/$chatId/';
    final Directory _dir = Directory.fromUri(Uri.parse(dir));
    if (!(await _dir.exists())) {
      await Permission.storage.request();
      _dir.createSync();
    }
    File file = File.fromUri(Uri.parse(_dir.path + "/" + id + ".m4a"));
    if (await file.exists()) {
      return file.path;
    } else {
      return null;
    }
  }

  Future<bool> isAudioFileExists(id, chatId) async {
    String dir = (await ExternalPath.getExternalStorageDirectories())[0];
    dir += '/talk/audio/$chatId/';
    File file = File(dir + id + ".m4a");
    return file.existsSync();
  }
}
