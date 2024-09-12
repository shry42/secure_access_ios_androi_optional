import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:secure_access/controllers/app_controller.dart';
import 'package:secure_access/screens/login_screen.dart';
import 'package:secure_access/services/api_services.dart';
import 'package:secure_access/utils/toast_notify.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UniqueKeyController extends GetxController {
  var isLoading = false.obs; // Observable to track loading state
  String currentDate =
      DateTime.now().toIso8601String().split('T')[0]; // for updateOn field

  getUniqueVistorByUniqueKey(dynamic uniqueKey, mobileNo) async {
    isLoading.value = true; // Start the loading indicator
    http.Response response = await http.post(
      Uri.parse('${ApiService.baseUrl}/api/visitor/getVisitorData'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AppController.accessToken}',
      },
      body: json.encode({"uniqueKey": uniqueKey, "mobileNo": mobileNo}),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> result = json.decode(response.body);
      Map<String, dynamic> data = result['data'];

      final uniqueVistorId = data['id'];
      final fullName = data['fullName'];
      final email = data['email'];
      final mobileNo = data['mobileNo'];
      final countryCode = data['countryCode'];
      final firebaseKey =
          data['firebaseKey'] ?? AppController.firebaseKey; //*******/
      final dateFromBackend = data['visitDate'];

      AppController.setDateFromBackend(dateFromBackend);
      AppController.setnoName(fullName);
      AppController.setEmail(email);
      AppController.setMobile(mobileNo);
      AppController.setCountryCode(countryCode);
      if (firebaseKey == "" || firebaseKey == null) {
        AppController.setFirebaseKey(null);
      } else {
        AppController.setFirebaseKey(firebaseKey);
        AppController.setFaceMatched(1);
      }
      AppController.setVisitorId(uniqueVistorId);
      AppController.setCallUpadteMethod(1);
      AppController.setValidKey(1);

//  for UPDATED ON FIELD

      // Query Firestore to find the document with the matching firebaseKey

      if (AppController.faceMatched == 0) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection("users")
            .where('mobNo', isEqualTo: mobileNo)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          AppController.setFaceMatched(1);
          // Assuming firebaseKey is unique and will only return one document
          DocumentSnapshot docSnapshot = querySnapshot.docs.first;

          String userId =
              docSnapshot.get('id'); // Extract 'id' field from document
          AppController.setFirebaseKey(userId);

          await docSnapshot.reference.update({'updatedOn': currentDate});
          // print('Updated document with firebaseKey: $firebaseKey');
        } else {
          // print('No document found with firebaseKey: $firebaseKey');
          AppController.setFaceMatched(0);
        }
      }

      ///
      isLoading.value = false; // Stop the loading indicator
    } else {
      isLoading.value = false; // Stop the loading indicator
      Map<String, dynamic> result = json.decode(response.body);
      String title = result['title'];
      String message = result['message'];
      AppController.setmessage(message);
      if (title == 'Validation Failed') {
        Get.defaultDialog(
          barrierDismissible: false,
          title: "Error",
          middleText: message,
          textConfirm: "OK",
          confirmTextColor: Colors.white,
          onConfirm: () {
            // Get.offAll(const FirstTabScreen());
            Get.back();
          },
        );
      } else {
        isLoading.value = false; // Stop the loading indicator
        Get.defaultDialog(
          barrierDismissible: false,
          title: title,
          middleText: message,
          textConfirm: "OK",
          confirmTextColor: Colors.white,
          onConfirm: () async {
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
            AppController.setnoMatched('No');
            AppController.setaccessToken(null);
            toast('unauthorized');
            AppController.setnoMatched('No');
            AppController.setCallUpadteMethod(0);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove('token');
            Get.offAll(LoginPage());
          },
        );
      }
    }
  }
}
