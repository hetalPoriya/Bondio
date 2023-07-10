import 'dart:developer';
import 'package:bondio/controller/controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:linkedin_login/linkedin_login.dart';
import 'package:twitter_login/twitter_login.dart';

class SocialLoginController extends GetxController {
  AuthController authController = Get.put(AuthController());
  Rx<TextEditingController> instagramName = TextEditingController().obs;

  signInWithGoogle() async {
    authController.isLoading(true);
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    try {
      GoogleSignInAccount? userData = await googleSignIn.signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await userData?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      authController.fullNameController.value.text =
          userData?.displayName ?? '';
      authController.emailController.value.text = userData?.email ?? '';
      authController.imageController.value.text = userData?.photoUrl ?? '';
      authController.googleToken.value = userData?.id ?? '';
      authController.update();
      // Once signed in, return the UserCredential
      await FirebaseAuth.instance.signInWithCredential(credential);

      await authController.userExistOrNotApi(
          tokenType: 'google_token', token: userData?.id ?? '');
      authController.isLoading(false);
    } catch (e) {
      authController.isLoading(false);
      Fluttertoast.showToast(msg: e.toString());
    } finally {
      authController.isLoading(false);
    }
  }

  signInWithFacebook() async {
    authController.isLoading(true);
    await FacebookAuth.instance.logOut();

    final LoginResult result = await FacebookAuth.instance
        .login(permissions: ['email', 'public_profile']);

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(result.accessToken!.token);

    // Once signed in, return the UserCredential
    FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);

    if (result.status == LoginStatus.success) {
      try {
        final userInfo = await FacebookAuth.instance.getUserData();

        authController.fullNameController.value.text = userInfo['name'] ?? '';
        authController.emailController.value.text = userInfo['email'] ?? '';
        authController.imageController.value.text =
            userInfo['picture']['data']['url'] ?? ' ';
        authController.facebookToken.value = userInfo['id'] ?? '';
        authController.update();

        await authController.userExistOrNotApi(
            tokenType: 'facebook_token', token: userInfo['id']);

        authController.isLoading(false);
      } catch (e) {
        authController.isLoading(false);
        log(e.toString());
      }
    } else {
      authController.isLoading(false);
      Fluttertoast.showToast(msg: 'Something went wrong!');
      log(result.message.toString());
    }
  }

  signInWithLinkedIn() async {
    String redirectUrl = 'https://www.linkedin.com/oauth/v2/authentication';
    String clientId = '77qs3v01ir4zv2';
    String clientSecret = '5ZzZmoAjn3KtZblB';

    Get.to(() => SafeArea(
          child: Obx(
            () => Stack(
              children: [
                LinkedInUserWidget(
                  destroySession: true,
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
                    authController.isLoading(false);
                  },
                  onGetUserProfile:
                      (final UserSucceededAction linkedInUser) async {
                    authController.fullNameController.value.text =
                        linkedInUser.user.firstName?.localized?.label ?? '';
                    authController.emailController.value.text = linkedInUser
                            .user
                            .email
                            ?.elements
                            ?.first
                            .handleDeep
                            ?.emailAddress ??
                        '';
                    authController.imageController.value.text = linkedInUser
                            .user
                            .profilePicture
                            ?.displayImageContent
                            ?.elements
                            ?.first
                            .identifiers
                            ?.first
                            .identifier ??
                        '';
                    authController.linkedinToken.value =
                        linkedInUser.user.userId ?? '';
                    authController.update();
                    await authController.userExistOrNotApi(
                        tokenType: 'linkedin_token',
                        token: linkedInUser.user.userId ?? '');
                  },
                ),
                if (authController.isLoading.value == true)
                  AppWidget.containerIndicator()
              ],
            ),
          ),
        ));
  }

  signInWithInstagram({required String userName, required String id}) async {
    authController.isLoading(true);

    authController.fullNameController.value.text = userName;
    authController.emailController.value.text = '';
    authController.imageController.value.clear();
    authController.instagramToken.value = id;
    await authController.userExistOrNotApi(
        tokenType: 'instagram_token', token: id);
  }

  signInWithTwitter() async {
    authController.isLoading(true);

    // Create a TwitterLogin instance
    final twitterLogin = TwitterLogin(
        apiKey: 'SwlcrcbUOO94Z1HcJX7TT349G',
        apiSecretKey: 'ETfzGMFvO9hO7GudMUzXTZsBNjwUxIL546oNNpNUzxNU5g1WyV',
        redirectURI: 'flutter-twitter-login://');

    // Trigger the sign-in flow
    final authResult = await twitterLogin.login();

    try {
      // Create a credential from the access token
      final twitterAuthCredential = TwitterAuthProvider.credential(
        accessToken: authResult.authToken!,
        secret: authResult.authTokenSecret!,
      );

      // Once signed in, return the UserCredential
      await FirebaseAuth.instance
          .signInWithCredential(twitterAuthCredential)
          .then((value) async {
        authController.fullNameController.value.text =
            value.additionalUserInfo?.username ?? '';
        authController.emailController.value.text = value.user?.email ?? '';
        authController.imageController.value.text = value.user?.photoURL ?? '';
        authController.twitterToken.value = value.user?.uid ?? '';
        authController.update();
        await authController.userExistOrNotApi(
            tokenType: 'twitter_token', token: value.user?.uid ?? '');
      });

      authController.isLoading(false);
    } catch (e) {
      authController.isLoading(false);
    }
  }

  signInWithOutlook() async {
    authController.isLoading(true);

    await FirebaseAuth.instance.signOut();
    try {
      final microsoftProvider = MicrosoftAuthProvider();

      await FirebaseAuth.instance
          .signInWithProvider(microsoftProvider)
          .then((value) async {
        authController.fullNameController.value.text =
            value.additionalUserInfo?.profile?['givenName'] ?? '';
        authController.emailController.value.text = value.user?.email ?? '';
        authController.imageController.value.text = value.user?.photoURL ?? '';
        authController.outlookToken.value = value.user?.uid.toString() ?? '';
        authController.update();

        await authController.userExistOrNotApi(
            tokenType: 'outlook_token',
            token: value.user?.uid.toString() ?? '');
      });

      //var provider = auth.signInWithProvider(OAuthProvider('microsoft.com'));

      authController.isLoading(false);
    } catch (e) {
      authController.isLoading(false);
    }
  }
}