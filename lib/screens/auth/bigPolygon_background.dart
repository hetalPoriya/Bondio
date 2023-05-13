// import 'package:bondio/responsive.dart';
// import 'package:bondio/screens/widgets.dart';
// import 'package:bondio/utils/utils.dart';
// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';
//
// class BigPolygonBackground extends StatelessWidget {
//   final Widget widget;
//   final Widget? aboveText;
//   final bool? showingBackIconOrNot;
//
//   const BigPolygonBackground(
//       {Key? key,
//       required this.widget,
//       this.aboveText,
//       this.showingBackIconOrNot = true})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: SingleChildScrollView(
//           child: SizedBox(
//               height: MediaQuery.of(context).size.height -
//                   MediaQuery.of(context).viewPadding.top,
//               child: OrientationBuilder(
//                 builder: ((context, orientation) {
//                   return ListView(
//                     children: [
//                       Container(
//                         padding: paddingSymmetric(
//                             horizontalPad: displayWidth(context) * .04,
//                             verticalPad: 0.0),
//                         height: orientation == Orientation.portrait
//                             ? displayHeight(context) * .40
//                             : displayHeight(context) * .90,
//                         width: MediaQuery.of(context).size.width,
//                         decoration: BoxDecoration(
//                             image: DecorationImage(
//                           image: AssetImage(
//                             AppAssets.bigPolygon,
//                           ),
//                           fit: BoxFit.fill,
//                         )),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Visibility(
//                                 visible: showingBackIconOrNot!,
//                                 child: backIcon()),
//                             aboveText ??
//                                 Align(
//                                   alignment: Alignment.centerLeft,
//                                   child: Image.asset(
//                                     AppAssets.bondioText,
//                                     width: displayWidth(context) * .50,
//                                   ),
//                                 ),
//                             SizedBox(
//                               height: orientation == Orientation.portrait
//                                   ? displayHeight(context) * .10
//                                   : displayHeight(context) * .25,
//                             )
//                           ],
//                         ),
//                       ),
//                       widget,
//                     ],
//                   );
//                 }),
//               )),
//         ),
//       ),
//     );
//   }
// }
import 'package:bondio/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class BigPolygonBackground extends StatelessWidget {
  final Widget widget;
  final Widget? aboveText;
  final bool? showingBackIconOrNot;

  const BigPolygonBackground(
      {Key? key,
      required this.widget,
      this.aboveText,
      this.showingBackIconOrNot = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          // height: MediaQuery.of(context).size.height,
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).viewPadding.top,
          child: ListView(
            shrinkWrap: true,
            children: [
              Container(
                padding: paddingSymmetric(horizontalPad: 4.w, verticalPad: 0.0),
                height: 38.h,
                // width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage(
                    AppAssets.bigPolygon,
                  ),
                  fit: BoxFit.fill,
                )),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    smallerSizedBox,
                    showingBackIconOrNot == true
                        ? AppWidget.backIcon(onTap: () => Get.back())
                        : mediumSizedBox,
                    smallerSizedBox,
                    aboveText ??
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Image.asset(
                            AppAssets.bondioText,
                            width: 50.w,
                          ),
                        ),
                    largeSizedBox,
                    largeSizedBox,
                  ],
                ),
              ),
              widget
            ],
          ),
        ),
      ),
    );
  }
}
