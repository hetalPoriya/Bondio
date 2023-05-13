import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../utils/utils.dart';

class ChatBackground extends StatelessWidget {
  final String? backgroundImage;
  final Widget bodyWidget;
  final Widget? appBarWidget;
  final TextStyle? textStyle;
  final VoidCallback? onBackButtonPressed;
  final Widget? floatingButton;
  final bool? backIcon;
  final VoidCallback? openDrawerOnTap;
  final String? title;

  const ChatBackground(
      {Key? key,
      this.backgroundImage,
      required this.bodyWidget,
      this.appBarWidget,
      this.title,
      this.onBackButtonPressed,
      this.textStyle,
      this.openDrawerOnTap,
      this.floatingButton,
      this.backIcon = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Scaffold(
          drawer: AppWidget.drawerWidget(),
          floatingActionButton: floatingButton,
          body: ListView(
            children: [
              Stack(children: [
                Container(
                  height: 24.h,
                  alignment: Alignment.centerLeft,
                  padding:
                      paddingSymmetric(horizontalPad: 4.w, verticalPad: 00),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            backgroundImage ?? AppAssets.normalBackground),
                        fit: BoxFit.fill),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Visibility(
                            visible: backIcon!,
                            child: AppWidget.backIcon(
                                onTap: onBackButtonPressed ?? () {}),
                          ),
                          GestureDetector(
                              onTap: openDrawerOnTap ??
                                  () => Scaffold.of(context).openDrawer(),
                              child: Image.asset(
                                AppAssets.menu,
                                height: 2.h,
                              )),
                        ],
                      ),
                      appBarWidget ??
                          Text(title.toString(),
                              style: textStyle ?? headerTextStyleWhite),
                      smallerSizedBox
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.h),
                  child: Container(
                    decoration: BoxDecoration(
                      color: ColorConstant.lightGrey,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.w),
                          topRight: Radius.circular(10.w)),
                    ),
                    child: bodyWidget,
                    // child: ListView(
                    //   shrinkWrap: true,
                    //   physics: ClampingScrollPhysics(),
                    //   children: [
                    //     smallSizedBox,
                    //     bodyWidget,
                    //   ],
                    // ),
                  ),
                )
              ]),
            ],
          )),
    ));
  }
}
