import 'package:bondio/controller/controller.dart';
import 'package:bondio/screens/chat/chat.dart';
import 'package:bondio/screens/auth/bigPolygon_background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthController authController = Get.put(AuthController());
  ChatController chatController = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return BigPolygonBackground(
        aboveText: Row(children: [
          Expanded(
            flex: 3,
            child: Center(
              child: Text(
                  authController.userModel.value.user?.name.toString() ??
                      'Guest',
                  style: mediumTextStyleWhiteText.copyWith(
                      fontWeight: FontWeight.w500)),
            ),
          ),
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () => ChatWidget.showDialogForImage(context: context),
              child: SizedBox(
                // color: Colors.red,
                height: 10.h,
                child: Stack(alignment: Alignment.bottomRight, children: [
                  CircleAvatar(
                    minRadius: 5.h,
                    maxRadius: 6.h,
                    backgroundImage: chatController.pickedImage?.value == null
                        ? AssetImage(AppAssets.addContact) as ImageProvider
                        : FileImage(
                            chatController.pickedImage!.value!,
                          ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 2.w),
                      child: CircleAvatar(
                        minRadius: 2.h,
                        maxRadius: 2.h,
                        backgroundColor: ColorConstant.lightRed,
                        child:
                            const Icon(Icons.camera_alt, color: Colors.white),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ),
          Expanded(child: Container()),
        ]),
        widget: Center(
          child: Form(
            child: Padding(
                padding: paddingSymmetric(horizontalPad: 10.w, verticalPad: 00),
                child: Obx(
                  () => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'My profile',
                        style: headerTextStyleBlack.copyWith(fontSize: 20.sp),
                      ),
                      smallSizedBox,
                      AppWidget.textFormFiledProfilePage(
                          textEditingController:
                              authController.fullNameController.value,
                          hintText: AppStrings.fullName,
                          textInputType: TextInputType.name),
                      smallSizedBox,
                      AppWidget.textFormFiledProfilePage(
                          textEditingController:
                              authController.zipCodeController.value,
                          hintText: AppStrings.zipCode,
                          textInputType: TextInputType.number),
                      smallSizedBox,
                      AppWidget.cscPiker(authController: authController),
                      smallSizedBox,
                      Container(
                        height: 10.h,
                        alignment: Alignment.topLeft,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: ColorConstant.backGroundColorOrange,
                            ),
                            borderRadius: BorderRadius.circular(2.w)),
                        child: TextField(
                            cursorColor: ColorConstant.backGroundColorOrange,
                            maxLines: null,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: AppStrings.briefYourself,
                            )),
                      ),
                      smallSizedBox,
                      AppWidget.elevatedButton(
                          text: AppStrings.update,
                          onTap: () {
                            authController.update();
                            Get.back();
                          }),
                      largeSizedBox
                    ],
                  ),
                )),
          ),
        ));
  }

// Future<PermissionStatus> _getImagePickerPermission() async {
//   PermissionStatus permission = await Permission.camera.status;
//   if (permission != PermissionStatus.granted &&
//       permission != PermissionStatus.permanentlyDenied) {
//     PermissionStatus permissionStatus = await Permission.camera.request();
//     return permissionStatus;
//   } else {
//     return permission;
//   }
// }
}
