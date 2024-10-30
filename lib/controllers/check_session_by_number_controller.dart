import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:secure_access/authenticate_face/authenticate_face_view.dart';
import 'package:secure_access/controllers/app_controller.dart';
import 'package:secure_access/screens/login_screen.dart';
import 'package:secure_access/services/api_services.dart';
import 'package:secure_access/utils/toast_notify.dart';

class CheckSessionByNumberController extends GetxController {
  getNamesList(int number) async {
    http.Response response = await http.get(
      Uri.parse('${ApiService.baseUrl}/api/visitor/getVisitor/$number'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AppController.accessToken}',
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> result = json.decode(response.body);
      Map<String, dynamic> data = result['data'];
      //  destroying the set noname and nomacthed yes
      AppController.setnoName('');
      AppController.setEmail('');
      AppController.setMobile('');
      AppController.setCountryCode('');
      AppController.setUserName('');
      AppController.setFirebaseKey(null);
      AppController.setnoMatched('No');
      AppController.setCallUpadteMethod(0);
      AppController.setValidKey(0);
      AppController.setFaceMatched(0);
      AppController.setDateFromBackend(null);
      AppController.setMobNoMatchedButFirebaseKeyNull(0);
      AppController.setmobNoMatchedButFirebaseKeyExistsButNotInFirestore(0);
      //

      Get.offAll(() => const AuthenticateFaceView());
      // Get.offAll(() => const AuthenticateFaceViewAndroid());
    } else {
      toast("unauthorized");
      Get.offAll(LoginPage());
    }
  }
}
