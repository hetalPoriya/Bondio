import 'package:get/get_utils/src/get_utils/get_utils.dart';

class FormValidation {
  static String? Function(String?)? emailValidation({String? value}) =>
      (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter email address';
        } else if (!GetUtils.isEmail(value)) {
          return 'Please enter valid email';
        }
        return null;
      };

  static String? Function(String?)? emptyValidation({String? value}) =>
      (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter valid value';
        }
        return null;
      };

// static String? Function(String?)? passwordValidation({String? value}) =>
//     (value) {
//       if (value == null || value.isEmpty) {
//         return 'Please enter password';
//       }
//       return null;
//     };
//
// static String? Function(String?)? nameValidation({String? value}) => (value) {
//       if (value == null || value.isEmpty) {
//         return 'Please enter your name';
//       }
//       return null;
//     };

  static String? Function(String?)? mobileNumberValidation({String? value}) =>
      (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your mobile number';
        } else if (!GetUtils.isPhoneNumber(value)) {
          return "Mobile number is not valid";
        }
        return null;
      };

// static String? Function(String?)? addressValidation({String? value}) =>
//         (value) {
//       if (value == null || value.isEmpty) {
//         return 'Please enter your address';
//       }
//       return null;
//     };

// static String? Function(String?)? classValidation({String? value}) =>
//     (value) {
//       print('Value $value');
//       if (value == null || value.isEmpty) {
//         return 'Please select any one';
//       }
//       return null;
//     };

  static String? Function(String?)? passwordValidation({String? value}) =>
      (value) {
        RegExp regExp = RegExp(r'^(?=.*?[A-Za-z])(?=.*?[!@#\$&*~]).{8,}$');
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        } else if (!regExp.hasMatch(value)) {
          return 'Password must contain 8 characters:one uppercase, one special character needed.';
        }
        return null;
      };
}
