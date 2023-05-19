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
  // for which data display on title and screen
  //Widget? titleWidget;
  Widget displayScreen = Container();

  List<Widget> displayTab = [
    const ChatList(),
    const GroupChatList(),
  ];

  //controller
  HomeController homeController = Get.put(HomeController());
  ChatController chatController = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    // return (homeController.onTapOnAddContact.value == true)
    //     ? const ContactScreen()
    //     : _chatAndGroupTabScreen();
    return Obx(() => (homeController.onTapOnAddContact.value == true)
        ? const ContactScreen()
        : _chatAndGroupTabScreen());
  }

  tabContainer({required String text, required int index}) => Obx(
        () {
          return GestureDetector(
            onTap: () {
              homeController.innerTabSelectedIndex.value = index;
              homeController.update();
            },
            child: Container(
                height: 3.h,
                width: 21.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.w),
                    color: Colors.white,
                    gradient: LinearGradient(
                        colors: homeController.innerTabSelectedIndex.value ==
                                index
                            ? [ColorConstant.darkRed, ColorConstant.lightRed]
                            : [Colors.white, Colors.white]),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black26, spreadRadius: 1, blurRadius: 6)
                    ]),
                child: Text(
                  text,
                  style: AppStyles.smallerTextStyle.copyWith(
                      color: homeController.innerTabSelectedIndex.value == index
                          ? Colors.white
                          : Colors.grey),
                )),
          );
        },
      );

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
            SharedPrefStrings.isDisplayContactScreenFirstTime, false) ==
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
                        Row(
                          children: [
                            tabContainer(text: 'Chats', index: 0),
                            SizedBox(
                              width: 4.w,
                            ),
                            tabContainer(text: 'Groups', index: 1),
                          ],
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
        // setState(() {
        SharedPrefClass.setBool(
            SharedPrefStrings.isDisplayContactScreenFirstTime, false);
        homeController.onTapOnAddContact.value = true;
        homeController.update();
        // });
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
      //final snackno Bar = SnackBar(content: Text('Access to contact data denied'));
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      openAppSettings();
      // final snackBar =
      //     SnackBar(content: Text('Contact data not available on device'));
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
