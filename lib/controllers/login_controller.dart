import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:secure_access/controllers/app_controller.dart';
import 'package:secure_access/models/login_user_model.dart';
import 'package:secure_access/screens/first_tab_screen%20copy%202.dart';
import 'package:secure_access/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class loginController extends GetxController {
  RxString email = ''.obs;
  RxString otp = ''.obs;
  String token = "";
  String role = "";
  UserDetails? user;
  int? isManager;

  // List<HRLoginDeptDetListModel> deptList = [];

  Future<void> loginUser() async {
    // throw Exception();
    http.Response response = await http.post(
      Uri.parse('${ApiService.baseUrl}/api/auth/otpLogin'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "employeeId": email.value,
        "otp": otp.value,
      }),
    );
    if (response.statusCode != 200) {
      Map<String, dynamic> result = jsonDecode(response.body);
      String title = result['title'];
      String message = result['message'];
      AppController.setmessage(message);
      Get.defaultDialog(
          title: title,
          middleText: message,
          onConfirm: () {
            Get.back();
          });
    }
    if (response.statusCode == 200) {
      Map<String, dynamic> result = json.decode(response.body);
      //
      user = UserDetails.fromJson(result['userDetails']);
      AppController.setmessage(null);
      token = result['token'];
      int? mainUid = user!.id;
      role = user!.role!;
      isManager = user!.isManager;
      AppController.setisManager(user!.isManager);
      AppController.setisVerified(user!.isVerified);
      AppController.setUserName('${user!.firstName} ${user!.lastName}');
      AppController.setEmail(user!.email);
      AppController.setMobile(user!.mobileNo);
      String? roles = user!.role;
      AppController.setMainUid(mainUid);
      AppController.setRole(roles);
      // print('******$token');
      AppController.setaccessToken(token);
      // Store token in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      Get.offAll(const FirstTabScreenTablet(),
          transition: Transition.rightToLeft);
    }
  }
}
