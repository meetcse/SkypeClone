import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:skypeclone/models/user.dart';
import 'package:skypeclone/provider/image_upload_provider.dart';
import 'package:skypeclone/resources/chat_methods.dart';

class StorageMethods {
  static final Firestore firestore = Firestore.instance;
  ChatMethods _chatMethods = ChatMethods();

  StorageReference _storageReference;
  User user = User();

  Future<String> uploadImageToStorage(File image) async {
    try {
      _storageReference = FirebaseStorage.instance
          .ref()
          .child('${DateTime.now().millisecondsSinceEpoch}');

      StorageUploadTask _storageUplaodTask = _storageReference.putFile(image);

      var url =
          await (await _storageUplaodTask.onComplete).ref.getDownloadURL();

      return url;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void uploadImage(File image, String receiverId, String senderId,
      ImageUploadProvider imageUploadProvider) async {
    // Set some  loading value  to db and show it to user
    imageUploadProvider.setToLoading();

    String url = await uploadImageToStorage(image);

    //Hide laoding
    imageUploadProvider.setToIdle();

    _chatMethods.setImageMsg(url, receiverId, senderId);
  }
}
