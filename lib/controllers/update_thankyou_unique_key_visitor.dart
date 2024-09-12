import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:secure_access/controllers/app_controller.dart';
import 'package:secure_access/screens/first_tab_screen%20copy%202.dart';
import 'package:secure_access/screens/login_screen.dart';
import 'package:secure_access/screens/thankyou_final_screen.dart';
import 'package:secure_access/services/api_services.dart';
import 'package:secure_access/utils/toast_notify.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateThankuouOfUniqueVisitor extends GetxController {
  var isLoading = false.obs; // Observable to track loading state

  Future upadteFinalUniqueKey(String? ndaSignature, toolName, make, remark,
      firebaseKey, toolPic, dynamic hasTool, quantity, dateFromBackend) async {
    isLoading.value = true; // Start loading

    http.Response response = await http.put(
      Uri.parse('${ApiService.baseUrl}/api/visitor/updateInvite'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AppController.accessToken}',
      },
      body: json.encode({
        "visitId": AppController.visitorId,
        "hasTool": hasTool,
        "firebaseKey": firebaseKey,
        "ndaSignature": ndaSignature,
        "visitDate": dateFromBackend,
        "toolDetails": {
          "toolName": toolName,
          "make": make,
          "quantity": quantity,
          "remark": remark,
          "toolPic": toolPic,
        }
      }),
    );

    isLoading.value = false; // Stop loading

    if (response.statusCode == 200) {
      Map<String, dynamic> result = json.decode(response.body);
      bool? status = result['status'];
      String message = result['message'];
      AppController.setFirebaseKey('');
      AppController.setnoName('');
      AppController.setEmail('');
      AppController.setCallUpadteMethod(0);
      AppController.setValidKey(0);
      AppController.setFaceMatched(0);
      AppController.setnoMatched('No');
      AppController.setDateFromBackend(null);

      Get.offAll(const ThankyouFinalScreen());
    } else if (response.statusCode == 401) {
      AppController.setnoMatched('No');
      AppController.setFirebaseKey(null);
      AppController.setnoName('');
      AppController.setEmail('');
      AppController.setCallUpadteMethod(0);
      AppController.setValidKey(0);
      AppController.setFaceMatched(0);
      AppController.setnoMatched('No');
      AppController.setaccessToken(null);
      AppController.setDateFromBackend(null);
      toast('unauthorized');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      Get.offAll(LoginPage());
    } else {
      Map<String, dynamic> result = json.decode(response.body);
      bool? status = result['status'];
      String message = result['message'];
      Get.defaultDialog(
        barrierDismissible: false,
        title: "Error",
        middleText: message,
        textConfirm: "OK",
        confirmTextColor: Colors.white,
        onConfirm: () {
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
          // Get.back();
          Get.offAll(const FirstTabScreenTablet());
        },
      );
    }
  }
}
