import 'dart:developer';
import 'package:bondio/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../chat.dart';

class SelectGroupMember extends StatefulWidget {
  const SelectGroupMember({Key? key}) : super(key: key);

  @override
  State<SelectGroupMember> createState() => _SelectGroupMemberState();
}

class _SelectGroupMemberState extends State<SelectGroupMember> {
//controller
  HomeController homeController = Get.put(HomeController());
  ChatController chatController = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return (homeController.onTapOnAddGroupMember.value == true &&
                homeController.onTapOnGroupCreate.value == false)
            ? ChatBackground(
                floatingButton: FloatingActionButton(
                  onPressed: () {
                    if (chatController.selectedGroupMember.length >= 2) {
                      homeController.onTapOnGroupCreate.value = true;
                      homeController.update();
                    } else {
                      Fluttertoast.showToast(
                          msg:
                              'Please select minimum two members to create group.');
                    }
                  },
                  backgroundColor: ColorConstant.darkOrange,
                  child: Icon(Icons.arrow_forward, size: 4.h),
                ),
                onBackButtonPressed: () {
                  homeController.onTapOnAddGroupMember.value = false;
                  homeController.onTapOnGroupCreate.value = false;
                  homeController.update();
                  Get.back();
                },
                bodyWidget: ListView(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    children: [
                      smallSizedBox,
                      Padding(
                        padding: paddingSymmetric(
                            horizontalPad: 8.w, verticalPad: 0.0),
                        child: AppWidget.searchField(
                            controller: chatController.searchController.value,
                            onChanged: (v) {
                              chatController
                                      .availableChatPersonSearchList.value =
                                  chatController.availableChatPersonFromContacts
                                      .where((x) => (x.name
                                              .toString()
                                              .toLowerCase()
                                              .contains(chatController
                                                  .searchController
                                                  .value
                                                  .text) ||
                                          x.name
                                              .toString()
                                              .toUpperCase()
                                              .contains(chatController
                                                  .searchController
                                                  .value
                                                  .text)))
                                      .toList();
                              chatController.availableChatPersonSearchList
                                  .refresh();
                              chatController.availableChatPersonFromContacts
                                  .refresh();
                            }),
                      ),
                      smallerSizedBox,
                      if (chatController.selectedGroupMember.isNotEmpty)
                        Container(
                          height: 10.h,
                          alignment: Alignment.centerLeft,
                          //color: Colors.green,
                          child: Padding(
                            padding: EdgeInsets.only(left: 7.w),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(
                                    chatController.selectedGroupMember.length,
                                    (index) {
                                  log('LoginId ${chatController.selectedGroupMember[index].id}');
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 10.h,
                                        width: 18.w,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                chatController
                                                    .selectedGroupMember
                                                    .removeAt(index);
                                                chatController.update();
                                              },
                                              child: Container(
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
                                                        color: Colors.white,
                                                        width: 2),
                                                    color: Colors.grey,
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                            AppAssets
                                                                .addContact),
                                                        fit: BoxFit.cover)),
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey,
                                                      boxShadow: const [
                                                        BoxShadow(
                                                          color: Colors.black26,
                                                          blurRadius: 4,
                                                        )
                                                      ],
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          color: Colors.white)),
                                                  child: Icon(Icons.close,
                                                      size: 4.w,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                            Text(
                                                chatController
                                                        .selectedGroupMember[
                                                            index]
                                                        .name ??
                                                    '',
                                                overflow: TextOverflow.ellipsis,
                                                style: AppStyles
                                                    .smallerTextStyle
                                                    .copyWith(
                                                        color: Colors.black)),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 2.w,
                                      )
                                    ],
                                  );
                                }),
                              ),
                            ),
                          ),
                        ),
                      smallerSizedBox,
                      if (chatController.selectedGroupMember.isNotEmpty)
                        Padding(
                          padding: paddingSymmetric(
                              horizontalPad: 5.w, verticalPad: 0.0),
                          child: Divider(
                            color: Colors.grey.shade300,
                            thickness: 1,
                          ),
                        ),
                      Obx(
                        () => chatController.searchController.value.text.isEmpty
                            ? buildListView(
                                availableChatPersonFromContacts: chatController
                                    .availableChatPersonFromContacts)
                            : buildListView(
                                availableChatPersonFromContacts: chatController
                                    .availableChatPersonSearchList),
                      )
                    ]),
                textStyle: AppStyles.largeTextStyle,
                title: 'Create Group')
            : CreateGroup();
      },
    );
  }

  buildListView({RxList? availableChatPersonFromContacts}) {
    return ListView.builder(
        shrinkWrap: true,
        padding: paddingSymmetric(horizontalPad: 5.w, verticalPad: 1.h),
        itemCount: availableChatPersonFromContacts!.length,
        physics: const ClampingScrollPhysics(),
        itemBuilder: ((context, index) {
          return GestureDetector(
            onTap: () {
              if (chatController.selectedGroupMember.contains(
                      chatController.availableChatPersonFromContacts[index]) ==
                  false) {
                chatController.selectedGroupMember
                    .add(availableChatPersonFromContacts[index]);
                chatController.update();
              } else {
                Fluttertoast.showToast(msg: 'Already added.');
              }
            },
            child: Container(
              height: 8.h,
              margin: paddingSymmetric(verticalPad: 1.0),
              child: Row(children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ChatWidget.imageCircleAvatar(context: context),
                    ],
                  ),
                ),
                Expanded(
                    flex: 4,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(
                                availableChatPersonFromContacts[index].name ??
                                    '',
                                style: AppStyles.mediumTextStyle
                                    .copyWith(color: Colors.black),
                                overflow: TextOverflow.ellipsis),
                          ),
                          // if (availableChatPersonFromContacts.value[index]
                          //         .phoneNumber
                          //         .isNotEmpty ==
                          //     true)
                          Text(
                            availableChatPersonFromContacts[index]
                                    .phoneNumber ??
                                '(none)',
                            style: AppStyles.smallTextStyle.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ])),
              ]),
            ),
          );
        }));
  }
}
