// import 'dart:developer';
// import 'package:bondio/controller/auth_controller.dart';
// import 'package:bondio/route_helper/route_helper.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:google_sign_in/google_sign_in.dart';
//
// class SocialLoginController extends GetxController {
//   AuthController authController = Get.put(AuthController());
//   static final _googleSignIn = GoogleSignIn();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   static Future googleLogOut() => _googleSignIn.disconnect();
//
//   Future<String?> signInWithGoogle() async {
//     try {
//       final GoogleSignInAccount? googleSignInAccount =
//           await _googleSignIn.signIn();
//       final GoogleSignInAuthentication googleSignInAuthentication =
//           await googleSignInAccount!.authentication;
//       final AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleSignInAuthentication.accessToken,
//         idToken: googleSignInAuthentication.idToken,
//       );
//       await _auth.signInWithCredential(credential);
//       // await authController.userExistOrNotApi();
//     } on FirebaseAuthException catch (e) {
//       log(e.message.toString());
//       Fluttertoast.showToast(msg: e.message.toString());
//       throw e;
//     }
//   }
//
//   // signInWithGoogle() async {
//   //   log('Enter');
//   //   SocialLoginController.googleLogOut();
//   //   log('Enter1');
//   //   GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
//   //   GoogleSignInAuthentication googleSignInAuthentication =
//   //       await googleSignInAccount!.authentication;
//   //   AuthCredential credential = GoogleAuthProvider.getCredential(
//   //     accessToken: googleSignInAuthentication.accessToken,
//   //     idToken: googleSignInAuthentication.idToken,
//   //   );
//   //   AuthResult authResult = await _auth.signInWithCredential(credential);
//   //   _user = authResult.user;
//   //   assert(!_user.isAnonymous);
//   //   assert(await _user.getIdToken() != null);
//   //   FirebaseUser currentUser = await _auth.currentUser();
//   //   assert(_user.uid == currentUser.uid);
//   //   model.state = ViewState.Idle;
//   //   print("User Name: ${_user.displayName}");
//   //   print("User Email ${_user.email}");
//   //   // await SocialLoginController.googleLogin().then((user) async {
//   //   //   log('$user');
//   //   //   if (user == null) {
//   //   //     Fluttertoast.showToast(msg: 'SignIn failed');
//   //   //   } else {
//   //   //     GoogleSignInAuthentication auth = await user.authentication;
//   //   //     log(auth.idToken.toString());
//   //   //     log(auth.accessToken.toString());
//   //   //     log(user.email.toString());
//   //   //     log(user.id);
//   //   //     log(user.displayName.toString());
//   //   //     log(user.photoUrl.toString());
//   //   //     log(user.serverAuthCode.toString());
//   //   //     Get.offNamedUntil(RouteHelper.homeScreen, (route) => false);
//   //   //   }
//   //   //});
//   // }
//
//   signInWithFacebook() async {
//     final accessToken = await FacebookAuth.instance.accessToken;
//     log('token $accessToken');
//     final LoginResult result = await FacebookAuth.instance
//         .login(permissions: ['email', 'public_profile']);
//     log('STATUS ${result.status}');
//     if (result.status == LoginStatus.success) {
//       final userInfo = await FacebookAuth.instance.getUserData();
//       log('${userInfo.toString()}');
//       log(userInfo['name']);
//       log(userInfo['id']);
//       authController.facebookToken.value = userInfo['id'];
//       authController.fullNameController.value.text = userInfo['name'];
//       authController.emailController.value.text = userInfo['email'];
//       authController.update();
//
//       await authController.userExistOrNotApi();
//       //Get.offNamedUntil(RouteHelper.homeScreen, (route) => false);
//       // name.text = userInfo["name"];
//       // email.text = userInfo["email"];
//       // provider = "Facebook";
//       // isSocial = true;
//       // setState(() {});
//     } else {
//       log(result.status.toString());
//       log(result.message.toString());
//     }
//
//     //     .then((value) async {
//     //   FacebookAuth.instance.getUserData().then((userData) {
//     //     log(userData);
//     //   });
//     // });
//   }
// //   final user = await SocialLoginController.facebookLogin();
// //   if (user == null) {
// //     Fluttertoast.showToast(msg: 'SignIn failed');
// //   } else {
// //     log(user.accessToken);
// //     log(user.accessToken?.userId);
// //     log(user.accessToken?.token);
// //     log(user.accessToken?.permissions);
// //
// //     Get.offNamedUntil(RouteHelper.homeScreen, (route) => false);
// //   }
// // }
// }

import 'dart:developer';

import 'package:bondio/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_insta/flutter_insta.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:linkedin_login/linkedin_login.dart';

class SocialLoginController extends GetxController {
  AuthController authController = Get.put(AuthController());

  Future signInWithGoogle() async {
    authController.isLoading(true);
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    try {
      GoogleSignInAccount? userData = await googleSignIn.signIn();

      log("userData ${userData}");
      log("userData ${userData?.email}");
      log("userData ${userData?.displayName}");

      authController.googleToken.value = userData!.id.toString();
      authController.fullNameController.value.text =
          userData.displayName.toString();
      authController.emailController.value.text = userData.email.toString();
      authController.update();
      await authController.userExistOrNotApi();
      authController.isLoading(false);
    } catch (e) {
      authController.isLoading(false);
      Fluttertoast.showToast(msg: '${e.toString()}');
    } finally {
      authController.isLoading(false);
    }
  }

  signInWithFacebook() async {
    await FacebookAuth.instance.logOut().then((value) async {
      final LoginResult result = await FacebookAuth.instance
          .login(permissions: ['email', 'public_profile']);

      log('STATUS ${result.status}');

      if (result.status == LoginStatus.success) {
        try {
          final userInfo = await FacebookAuth.instance.getUserData();
          log('UserInfo $userInfo');
          log(userInfo['name']);
          log(userInfo['id']);
          authController.facebookToken.value = userInfo['id'];
          authController.fullNameController.value.text = userInfo['name'];
          authController.emailController.value.text = userInfo['email'];
          authController.update();
          await authController.userExistOrNotApi();
        } catch (e) {
          log(e.toString());
          Fluttertoast.showToast(msg: '${e.toString()}');
        }
      } else {
        log(result.status.toString());
        log(result.message.toString());
      }
    });
  }

  signInWithLinkedIn() async {
    String redirectUrl = 'https://api.linkedin.com/v2/me';
    String clientId = '77qs3v01ir4zv2';
    String clientSecret = '5ZzZmoAjn3KtZblB';
    log('Call');

    Get.to(() => SafeArea(
          child: LinkedInUserWidget(
            redirectUrl: redirectUrl,
            clientId: clientId,
            clientSecret: clientSecret,
            projection: const [
              ProjectionParameters.id,
              ProjectionParameters.localizedFirstName,
              ProjectionParameters.localizedLastName,
              ProjectionParameters.firstName,
              ProjectionParameters.lastName,
              ProjectionParameters.profilePicture,
            ],
            onError: (final UserFailedAction e) {
              print('Error: ${e.toString()}');
              print('Error: ${e.stackTrace.toString()}');
            },
            onGetUserProfile: (final UserSucceededAction linkedInUser) {
              print(
                'Access token ${linkedInUser.user.token.accessToken}',
              );

              print('User id: ${linkedInUser.user.userId}');
            },
          ),
        ));
    // return LinkedInUserWidget(
    //   redirectUrl: redirectUrl,
    //   clientId:clientId,
    //   clientSecret: clientSecret,
    //   onGetUserProfile: (UserSucceededAction linkedInUser) {
    //     log('Access token ${linkedInUser.user.token.accessToken}');
    //     log('First name: ${linkedInUser.user.firstName?.localized?.label}');
    //     log('Last name: ${linkedInUser.user.lastName?.localized?.label}');
    //   },
    //   onError: (UserFailedAction e) {
    //     log('Error: ${e.toString()}');
    //   },
    // );
  }

  signInWithInstagram({required String userName}) async {
    FlutterInsta flutterInsta = FlutterInsta();
//get data from api

    await flutterInsta.getProfileData('poriya_149_');
    log(flutterInsta.username);
    log(flutterInsta.followers.toString());
    log(flutterInsta.following);
    log(flutterInsta.bio);
    log(flutterInsta.imgurl);
  }
}
