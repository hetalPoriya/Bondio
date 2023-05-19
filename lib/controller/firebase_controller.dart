import 'dart:developer';
import 'dart:io';
import 'package:bondio/controller/controller.dart';

import 'package:bondio/model/user_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class FirebaseController extends GetxController {
  FirebaseFirestore fireStoreInstant = FirebaseFirestore.instance;

  FirebaseStorage storage = FirebaseStorage.instance;
  CollectionReference<Map<String, dynamic>>? contactCollection;


  Rx<UserInfo> userInfo = UserInfo().obs;


  Future<Uri?> uploadPic({required File image}) async {
    AuthController authController = Get.put(AuthController());
    log('Enter');

    try {
      var reference = storage
          .ref()
          .child("chat/${authController.userModel.value.user!.id.toString()}");
      Fluttertoast.showToast(
          msg: 'Please wait..', toastLength: Toast.LENGTH_LONG);
      TaskSnapshot uploadTask = await reference.putFile(File(image.path));
      String imageUrl = await uploadTask.ref.getDownloadURL();
    } catch (e) {
      log('error occured');
    }

    //Upload the file to firebase
    // Fluttertoast.showToast(
    //     msg: 'Please wait..', toastLength: Toast.LENGTH_LONG);
    // UploadTask uploadTask = reference.putFile(File(image.path));
    // TaskSnapshot snapshot = await uploadTask;
    // String imageUrl = await snapshot.ref.getDownloadURL();
    //
    // DocumentReference documentRef = fireStoreInstant
    //     .collection(AppStrings.chatRoomCollection)
    //     .doc(collectionId.value);
    //
    // DocumentSnapshot userDoc = await fireStoreInstant
    //     .collection(AppStrings.chatRoomCollection)
    //     .doc(collectionId.value)
    //     .get();
    //
    // documentRef.get().then((value) {
    //   Fluttertoast.showToast(msg: 'Uploaded Successfully.');
    //   if (authController.userInfo.value.user!.id.toString() ==
    //       value.get('user_id')) {
    //     documentRef.set({
    //       'peer_profile': imageUrl,
    //     }, SetOptions(merge: true)).then((value) {
    //       oneToOneChatUser.value = OneToOneChatList.fromDocument(userDoc);
    //       log('VALUE ${oneToOneChatUser.value}');
    //     });
    //   } else {
    //     documentRef.set({
    //       'user_profile': imageUrl,
    //     }, SetOptions(merge: true)).then((value) {
    //       oneToOneChatUser.value = OneToOneChatList.fromDocument(userDoc);
    //       log('VALUE ${oneToOneChatUser.value}');
    //     });
    //   }
    // });

    // fireStoreInstant.collection(AppStrings.chatRoomCollection)
    return null;
  }

  addUserIdToChatUserListCollectionToManageChatList(
      {required String id}) async {
    await fireStoreInstant
        .collection(ApiConstant.personalChatListCollection)
        .doc(id)
        .set({});
  }

  @override
  void onInit() {
    // AuthController authController = Get.put(AuthController());
    contactCollection =
        fireStoreInstant.collection(ApiConstant.manageContactCollection);
    // currentUserId.value = authController.userInfo.value.user!.id.toString();

    super.onInit();
  }
}
