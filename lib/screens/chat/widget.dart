import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bondio/controller/controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../model/model.dart';

class ChatWidget {
  static ChatController chatController = Get.put(ChatController());
  static AuthController authController = Get.put(AuthController());

  static Future<void> getUserInfo() async {
    AuthController authController = Get.put(AuthController());
    var response = await SharedPrefClass.getUserData();
    log('Response $response');
    if (response.toString().isNotEmpty) {
      authController
          .userModel(LoginData.fromMap(jsonDecode(response.toString())));
      authController.userModel.refresh();
      authController.fullNameController.value.text =
          authController.userModel.value.user?.name.toString() ?? '';
      authController.zipCodeController.value.text =
          authController.userModel.value.user?.zipCode.toString() ?? '';
      authController.countryValue.value =
          authController.userModel.value.user?.country.toString() ?? '';
      authController.cityValue.value =
          authController.userModel.value.user?.city.toString() ?? '';
      authController.stateValue.value =
          authController.userModel.value.user?.state.toString() ?? '';
      authController.aboutMeController.value.text =
          authController.userModel.value.user?.aboutMe.toString() ?? '';
      authController.update();
      log('UserResponse ${authController.userModel.value.toMap()}');
      log('UserResponse ${authController.userModel.value.user?.id.toString()}');
    }
  }

  static Widget chatContainer(
          {String? imageString,
          String? titleText,
          String? subText,
          String? time}) =>
      Material(
        elevation: 2.w,
        borderRadius: BorderRadius.circular(4.w),
        child: Container(
          height: 10.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.w),
            color: Colors.white,
          ),
          child: Row(children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: paddingAll(paddingAll: 4.w),
                    height: 6.h,
                    decoration: BoxDecoration(
                        color: Colors.black26,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: ChatWidget.displayImage(image: imageString),
                            fit: BoxFit.cover)),
                  ),
                ],
              ),
            ),
            Expanded(
                flex: 4,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                              flex: 4,
                              child: Text(titleText ?? ' ',
                                  style: AppStyles.mediumTextStyle
                                      .copyWith(color: Colors.black))),
                          Expanded(
                              child: Text(time.toString(),
                                  style: AppStyles.smallerTextStyle.copyWith(
                                      fontSize: 8.sp, color: Colors.black))),
                        ],
                      ),
                      Text(
                        subText ?? ' ',
                        maxLines: 2,
                        style: AppStyles.smallerTextStyle
                            .copyWith(color: Colors.grey.shade800),
                        overflow: TextOverflow.ellipsis,
                      )
                    ])),
          ]),
        ),
      );

  static Widget customDrawer() => Container();

  static Widget appBarWidget({String? userName, String? status}) => SizedBox(
        height: 10.h,
        child: Row(
          children: [
            Expanded(
                child: CircleAvatar(
              maxRadius: 4.h,
              minRadius: 4.h,
            )),
            Expanded(
                flex: 4,
                child: Padding(
                    padding:
                        paddingSymmetric(horizontalPad: 2.w, verticalPad: 00),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          userName ?? 'Jack hem',
                          style: AppStyles.mediumTextStyle,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(status ?? 'Online',
                            overflow: TextOverflow.ellipsis,
                            style: AppStyles.smallerTextStyle)
                      ],
                    ))),
          ],
        ),
      );

  static Widget imageCircleAvatar(
          {Uint8List? imageString, required BuildContext context}) =>
      SizedBox(
        height: 6.h,
        width: MediaQuery.of(context).size.width,
        child: (imageString != null && imageString.isNotEmpty)
            ? CircleAvatar(
                backgroundImage: MemoryImage(imageString),
              )
            : CircleAvatar(
                backgroundColor: ColorConstant.backGroundColorOrange,
                child: Image.asset(AppAssets.user,
                    height: 3.h, color: Colors.white),
              ),
      );

  static Widget noConversionFound() => Column(
        children: [
          largeSizedBox,
          largeSizedBox,
          largeSizedBox,
          Center(
            child: Text(
              'No Conversion found',
              style: AppStyles.smallerTextStyle,
            ),
          ),
        ],
      );

  static showDialogForImage({required BuildContext context}) {
    return Get.defaultDialog(
        title: 'From where do you want to take the photo?',
        titleStyle: AppStyles.mediumTextStyle.copyWith(color: Colors.grey),
        contentPadding: EdgeInsets.zero,
        content: Padding(
          padding: paddingSymmetric(horizontalPad: 5.w, verticalPad: 0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                    _pickFromGalley();
                  },
                  child: Text(
                    'Gallery',
                    style:
                        AppStyles.smallTextStyle.copyWith(color: Colors.black),
                  ),
                ),
                smallerSizedBox,
                GestureDetector(
                  onTap: () {
                    Get.back();
                    _pickFromCamera();
                  },
                  child: Text(
                    'Camera',
                    style:
                        AppStyles.smallTextStyle.copyWith(color: Colors.black),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  static _pickFromGalley() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    chatController.pickedImage?.value = File(image.path);
    await authController.updateProfileApiCall(imagePath: File(image.path));
    // firebaseController.uploadPic(image: File(image.path));
    chatController.update();
  }

  static _pickFromCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return;
    chatController.pickedImage?.value = File(image.path);
    await authController.updateProfileApiCall(imagePath: File(image.path));
    // firebaseController.uploadPic(image: File(image.path));
    chatController.update();
  }

  static displayImage({String? image}) {
    return ((image.toString().isEmpty || image.toString() == ' '))
        ? AssetImage(AppAssets.addContact) as ImageProvider
        : NetworkImage('${ApiConstant.imageBaseUrl}${image.toString()}');
  }
}
