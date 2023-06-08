import 'package:bondio/screens/about_us.dart';
import 'package:bondio/screens/auth/auth.dart';
import 'package:bondio/screens/chat/chat.dart';
import 'package:bondio/screens/dashboard.dart';
import 'package:bondio/screens/home_screen.dart';
import 'package:bondio/screens/host_event/add_event.dart';
import 'package:bondio/screens/instagram_login.dart';
import 'package:bondio/screens/profile_page.dart';
import 'package:get/get.dart';
import '../screens/reward_and_share/reward_and_share.dart';

class RouteHelper {
  static String splashScreen = '/splashScreen';
  static String introScreen = '/introScreen';
  static String dashBoard = '/dashBoard';
  static String loginPage = '/loginPage';
  static String signUpPage = '/signUpPage';
  static String inviteCodeSignUp = '/inviteCodeSignUp';
  static String socialSignUpPage = '/socialSignUpPage';
  static String verifyEmail = '/verifyEmail';
  static String newPassword = '/newPassword';
  static String homeScreen = '/homeScreen';
  static String inviteFriend = '/inviteFriend';
  static String sendEmail = '/sendEmail';
  static String rewardsScreen = '/rewardsScreen';

  static String chatList = '/chatList';
  static String chatProfilePage = '/chatProfilePage';
  static String chatMainPage = '/chatMainPage';
  static String contactScreen = '/contactScreen';
  static String groupChatList = '/groupChatList';
  static String groupChatPage = '/groupChatPage';
  static String chatPage = '/chatPage';
  static String createGroup = '/createGroup';
  static String selectGroupMember = '/selectGroupMember';
  static String addParticipant = '/addParticipant';
  static String removeParticipant = '/removeParticipant';
  static String forgotPassword = '/forgotPassword';
  static String profilePage = '/profilePage';
  static String aboutUs = '/aboutUs';
  static String instagramLogin = '/instagramLogin';
  static String addEvent = '/addEvent';

  //pages
  static List<GetPage> getPages = [
    GetPage(name: splashScreen, page: () => const SplashScreen()),
    GetPage(name: introScreen, page: () => const IntroScreen()),
    GetPage(name: dashBoard, page: () => DashBoard()),
    GetPage(name: loginPage, page: () => const LoginPage()),
    GetPage(name: signUpPage, page: () => const SignUpPage()),
    GetPage(name: newPassword, page: () => NewPassword()),
    GetPage(name: inviteCodeSignUp, page: () => const InviteCodeSignUp()),
    GetPage(name: socialSignUpPage, page: () => const SocialLoginScreen()),
    GetPage(name: verifyEmail, page: () => const VerifyEmail()),

    GetPage(name: forgotPassword, page: () => const ForgotPassword()),
    GetPage(name: homeScreen, page: () => const HomeScreen()),
    GetPage(name: inviteFriend, page: () => InviteFriend()),
    GetPage(name: rewardsScreen, page: () => const RewardsScreen()),
    //  GetPage(name: chatList, page: () => ChatList()),
    GetPage(name: chatMainPage, page: () => const ChatMainPage()),
    GetPage(name: chatPage, page: () => const ChatPage()),
    GetPage(name: chatProfilePage, page: () => const ChatProfilePage()),
    GetPage(name: groupChatList, page: () => const GroupChatList()),
    GetPage(name: groupChatPage, page: () => const GroupChatPage()),
    GetPage(name: contactScreen, page: () => const ContactScreen()),

    GetPage(name: profilePage, page: () => const ProfilePage()),
    GetPage(name: aboutUs, page: () => const AboutUs()),
    GetPage(name: selectGroupMember, page: () => const SelectGroupMember()),
    GetPage(name: addParticipant, page: () => const AddParticipant()),
    GetPage(name: removeParticipant, page: () => const RemoveParticipant()),
    GetPage(name: createGroup, page: () => CreateGroup()),
    GetPage(name: instagramLogin, page: () => InstagramLogin()),
    GetPage(name: addEvent, page: () => AddEvent()),
  ];
}
