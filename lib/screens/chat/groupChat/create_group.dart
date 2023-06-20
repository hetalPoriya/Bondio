import 'dart:developer';

import 'package:bondio/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../chat.dart';

class CreateGroup extends StatelessWidget {
  CreateGroup({Key? key}) : super(key: key);

  //controller
  HomeController homeController = Get.put(HomeController());
  AuthController authController = Get.put(AuthController());

  ChatController chatController = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return ChatBackground(
        appBarWidget:
            ChatWidget.appBarWidget(userName: 'Group title', status: 'Users'),
        floatingButton: Obx(() => Padding(
              padding: EdgeInsets.only(left: 20.w, right: 12.w),
              child: AppWidget.elevatedButton(
                  text: 'done',
                  loading: chatController.isLoading.value,
                  onTap: chatController.isLoading.value == true
                      ? () {}
                      : () async {
                          log('${chatController.groupNameController.value.text.isEmpty}');
                          if (chatController
                                  .groupNameController.value.text.isEmpty ==
                              true) {
                            AppWidget.toast(text: 'Please add your GroupName');
                          } else {
                            await chatController.createGroup(
                                userName: authController
                                    .userModel.value.user!.name
                                    .toString(),
                                groupName: chatController
                                    .groupNameController.value.text);
                            homeController.onTapOnAddContact.value = false;
                            homeController.onTapOnAddGroupMember.value = false;
                            Get.back();
                            homeController.selectedIndex.value = 1;
                            homeController.innerTabSelectedIndex.value = 1;
                            homeController.update();
                          }
                        }),
            )),
        // GestureDetector(
        //   onTap: () async {
        //     await chatController.createGroup(
        //         userName: authController.userModel.value.user!.name.toString(),
        //         groupName: chatController.groupNameController.value.text);
        //     homeController.onTapOnAddContact.value = false;
        //     homeController.onTapOnAddGroupMember.value = false;
        //     Get.back();
        //     homeController.selectedIndex.value = 1;
        //     homeController.innerTabSelectedIndex.value = 1;
        //     homeController.update();
        //   },
        //   child: Container(
        //     alignment: Alignment.center,
        //     width: 25.w,
        //     height: 4.h,
        //     decoration: BoxDecoration(
        //       color: ColorConstant.backGroundColorOrange,
        //       boxShadow: const [
        //         BoxShadow(
        //             blurRadius: 1,
        //             offset: Offset(
        //               0.0,
        //               0.0,
        //             ),
        //             color: Colors.black12,
        //             spreadRadius: 1)
        //       ],
        //       borderRadius: BorderRadius.circular(4.w),
        //     ),
        //     child: Text('done', style: AppStyles.smallTextStyle),
        //   ),
        // ),
        bodyWidget: ListView(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          children: [
            smallSizedBox,
            Padding(
              padding: paddingSymmetric(horizontalPad: 8.w, verticalPad: 0.0),
              child: RichText(
                  text: TextSpan(
                      text: 'Participants:',
                      style: AppStyles.smallerTextStyle
                          .copyWith(color: Colors.grey),
                      children: [
                    TextSpan(
                        text: chatController.selectedGroupMember.length
                            .toString(),
                        style: AppStyles.smallerTextStyle
                            .copyWith(color: Colors.black))
                  ])),
            ),
            smallerSizedBox,
            Container(
              height: 10.h,
              alignment: Alignment.centerLeft,
              margin: paddingSymmetric(verticalPad: 1.h),
              //color: Colors.green,
              child: Padding(
                padding: EdgeInsets.only(left: 7.w),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                        chatController.selectedGroupMember.length,
                        (index) => Row(
                              children: [
                                SizedBox(
                                  width: 18.w,
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 7.h,
                                        width: 14.w,
                                        decoration: BoxDecoration(
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.black26,
                                                blurRadius: 4,
                                              )
                                            ],
                                            border: Border.all(
                                                color: Colors.white, width: 2),
                                            color: Colors.grey,
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    AppAssets.addContact),
                                                fit: BoxFit.cover)),
                                      ),
                                      Text(
                                        chatController
                                                .selectedGroupMember[index]
                                                .name ??
                                            '',
                                        overflow: TextOverflow.ellipsis,
                                        style: AppStyles.smallerTextStyle
                                            .copyWith(fontSize: 8.sp),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 2.w,
                                )
                              ],
                            )),
                  ),
                ),
              ),
            ),
            Padding(
              padding: paddingSymmetric(horizontalPad: 5.w, verticalPad: 0.0),
              child: SizedBox(
                height: 8.h,
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                      height: 8.h,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade100,
                          border: Border.all(color: Colors.grey.shade400)),
                      child: Icon(Icons.camera_alt,
                          color: Colors.grey.shade400, size: 3.h),
                    )),
                    SizedBox(
                      width: 2.w,
                    ),
                    Expanded(
                        flex: 6,
                        child: Obx(
                          () => TextField(
                            controller:
                                chatController.groupNameController.value,
                            decoration: InputDecoration(
                                hintText: 'Add group title..',
                                hintStyle: AppStyles.smallerTextStyle,
                                suffixIcon: const Icon(
                                  Icons.emoji_emotions_outlined,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: ColorConstant.lightOrange)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: ColorConstant.lightOrange))),
                            cursorColor: ColorConstant.lightOrange,
                          ),
                        ))
                  ],
                ),
              ),
            ),
            largeSizedBox,
          ],
        ),
        title: '',
        onBackButtonPressed: () {
          homeController.onTapOnAddGroupMember.value = true;
          homeController.onTapOnGroupCreate.value = false;
          homeController.update();
        });
  }
}