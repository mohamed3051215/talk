import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  Reference storage = FirebaseStorage.instance.ref().child("Users Images");
  Future<String> storeUserImage(String path) async {
    File file = File(path);
    final User user = FirebaseAuth.instance.currentUser!;
    Reference image = storage.child(user.uid + ".jpg");
    await image.putFile(file).whenComplete(() => null);
    return await image.getDownloadURL();
  }

  Future<String> changeImage(File file) async {
    final User user = FirebaseAuth.instance.currentUser!;
    Reference image = storage.child(user.uid + ".jpg");
    await image.delete();
    await image.putFile(file).whenComplete(() => null);
    return await image.getDownloadURL();
  }

  Future<String> uploadMessageAudio(
      File file, String chatId, String messageId) async {
    Reference ref =
        storage.child("chat").child(chatId).child(messageId + ".m4a");
    await ref.putFile(file).whenComplete(() => null);
    return await ref.getDownloadURL();
  }
}
