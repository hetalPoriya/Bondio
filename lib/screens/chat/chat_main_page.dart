import 'package:bondio/controller/controller.dart';
import 'package:bondio/route_helper/route_helper.dart';
import 'package:bondio/screens/chat/chat.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';

class ChatMainPage extends StatefulWidget {
  final VoidCallback? onButtonPressed;

  const ChatMainPage({Key? key, this.onButtonPressed}) : super(key: key);

  @override
  State<ChatMainPage> createState() => _ChatMainPageState();
}

class _ChatMainPageState extends State<ChatMainPage> {
  Widget displayScreen = Container();

  List<Widget> displayTab = [
    const ChatList(),
    const GroupChatList(),
  ];

  //controller
  HomeController homeController = Get.put(HomeController());
  ChatController chatController = Get.put(ChatController());
  AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => (homeController.onTapOnAddContact.value == true)
        ? const ContactScreen()
        : _chatAndGroupTabScreen());
  }

  Widget _addContactContainer() {
    return Column(children: [
      largeSizedBox,
      SizedBox(
        width: double.infinity,
        //color: Colors.red,
        child: Image.asset(
          AppAssets.addContact,
          height: 25.h,
        ),
      ),
      smallSizedBox,
      Text(
        AppStrings.conversations,
        style: AppStyles.mediumTextStyle.copyWith(color: Colors.black),
      ),
      Padding(
        padding: paddingSymmetric(horizontalPad: 4.w, verticalPad: 00),
        child: Text(
          AppStrings.conversationsDes,
          style: AppStyles.smallTextStyle.copyWith(color: Colors.black),
          textAlign: TextAlign.center,
        ),
      ),
      smallSizedBox,
      Padding(
        padding: paddingSymmetric(horizontalPad: 20.w, verticalPad: 00),
        child: AppWidget.elevatedButton(
            text: AppStrings.addPeople, onTap: () => _askPermissions()),
      ),
      smallSizedBox,
    ]);
  }

  Widget _chatAndGroupTabScreen() {
    if (SharedPrefClass.getBool(
            SharedPrefStrings.isDisplayContactScreenFirstTime, true) ==
        true) {
      homeController.titleWidget.value = Text('Add Contact',
          style: AppStyles.extraLargeTextStyle.copyWith(fontSize: 18.sp));
      homeController.update();
    } else if (homeController.innerTabSelectedIndex.value == 0) {
      homeController.titleWidget.value =
          Text('Chat', style: AppStyles.extraLargeTextStyle);
      homeController.update();
    } else if (homeController.innerTabSelectedIndex.value == 1) {
      homeController.titleWidget.value =
          Text('Group', style: AppStyles.extraLargeTextStyle);
      homeController.update();
    }
    return Obx(
      () {
        return ChatBackground(
            onBackButtonPressed: () {
              homeController.selectedIndex.value = 0;
              homeController.update();
            },
            appBarWidget: homeController.titleWidget.value,
            bodyWidget: SizedBox(
              width: MediaQuery.of(context).size.width,
              //color: Colors.grey,
              child: Column(
                children: [
                  smallSizedBox,
                  Padding(
                    padding:
                        paddingSymmetric(horizontalPad: 6.w, verticalPad: 00),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(
                          () => Row(
                            children: [
                              ChatWidget.tabContainer(
                                textColor: homeController
                                            .innerTabSelectedIndex.value ==
                                        0
                                    ? Colors.white
                                    : Colors.grey,
                                color: homeController
                                            .innerTabSelectedIndex.value ==
                                        0
                                    ? [
                                        ColorConstant.darkRed,
                                        ColorConstant.lightRed
                                      ]
                                    : [Colors.white, Colors.white],
                                text: 'Chats',
                                index: 0,
                                onTap: () {
                                  homeController.innerTabSelectedIndex.value =
                                      0;
                                  homeController
                                      .innerTabForActiveAndArchiveIndex
                                      .value = 0;
                                  homeController.update();
                                },
                              ),
                              SizedBox(
                                width: 4.w,
                              ),
                              ChatWidget.tabContainer(
                                textColor: homeController
                                            .innerTabSelectedIndex.value ==
                                        1
                                    ? Colors.white
                                    : Colors.grey,
                                color: homeController
                                            .innerTabSelectedIndex.value ==
                                        1
                                    ? [
                                        ColorConstant.darkRed,
                                        ColorConstant.lightRed
                                      ]
                                    : [Colors.white, Colors.white],
                                text: 'Groups',
                                index: 1,
                                onTap: () {
                                  homeController.innerTabSelectedIndex.value =
                                      1;
                                  homeController
                                      .innerTabForActiveAndArchiveIndexForGroup
                                      .value = 0;
                                  homeController.update();
                                },
                              ),
                            ],
                          ),
                        ),
                        if (homeController.innerTabSelectedIndex.value == 0)
                          GestureDetector(
                            onTap: () {
                              if (SharedPrefClass.getBool(
                                      SharedPrefStrings.isLogin, false) ==
                                  false) {
                                _showDialogToGuest();
                              } else {
                                SharedPrefClass.setBool(
                                    SharedPrefStrings
                                        .isDisplayContactScreenFirstTime,
                                    false);
                                homeController.onTapOnAddContact.value = true;
                                homeController.update();
                              }
                            },
                            child: Icon(
                              Icons.person_add_alt_1,
                              size: 3.h,
                              color: ColorConstant.backGroundColorOrange,
                            ),
                          ),
                        if (homeController.innerTabSelectedIndex.value == 1)
                          GestureDetector(
                            onTap: () {
                              homeController.onTapOnAddGroupMember.value = true;
                              homeController.onTapOnGroupCreate.value = false;

                              chatController.selectedGroupMember.value = [];
                              chatController.update();
                              homeController.update();
                              Get.toNamed(RouteHelper.selectGroupMember);
                            },
                            child: Icon(
                              Icons.people_alt_rounded,
                              size: 3.h,
                              color: ColorConstant.backGroundColorOrange,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (SharedPrefClass.getBool(
                          SharedPrefStrings.isDisplayContactScreenFirstTime,
                          true) ==
                      true) ...[
                    _addContactContainer(),
                  ] else ...[
                    Obx(
                      () => displayTab.elementAt(
                          homeController.innerTabSelectedIndex.value),
                    ),
                  ]
                ],
              ),
            ));
      },
    );
  }

  Future<void> _askPermissions() async {
    if (SharedPrefClass.getBool(SharedPrefStrings.isLogin, false) == false) {
      _showDialogToGuest();
    } else {
      PermissionStatus permissionStatus = await _getContactPermission();
      if (permissionStatus == PermissionStatus.granted) {
        SharedPrefClass.setBool(
            SharedPrefStrings.isDisplayContactScreenFirstTime, false);
        homeController.onTapOnAddContact.value = true;
        homeController.update();
      } else {
        _handleInvalidPermissions(permissionStatus);
      }
    }
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      openAppSettings();
    }
  }

  _showDialogToGuest() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Bondio',
              style: AppStyles.mediumTextStyle
                  .copyWith(color: ColorConstant.darkOrange)),
          content: Text('Looks like you are not a member, Kindly SignUp first.',
              style: AppStyles.smallTextStyle.copyWith(color: Colors.black)),
          actionsPadding: EdgeInsets.zero,
          actions: [
            TextButton(
                onPressed: () {
                  Get.back();
                  Get.toNamed(RouteHelper.signUpPage);
                },
                child: Text(
                  'Ok',
                  style: AppStyles.smallTextStyle.copyWith(color: Colors.black),
                ))
          ],
        );
      },
    );
  }
}