// authentication_controller.dart

import 'package:get/get.dart';
import 'package:secure_access/model_face/user_model.dart';

class AuthenticationController extends GetxController {
  var isMatching = false.obs;
  var loggingUser = UserModel().obs;
  var trialNumber = 0.obs;

  void setMatchingUsers(List<UserModel> matchingUsers) {
    if (matchingUsers.isNotEmpty) {
      loggingUser.value = matchingUsers.first;
      isMatching.value = false;
      trialNumber.value = 1;
    }
  }
}
