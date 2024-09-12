import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:secure_access/controllers/app_controller.dart';
import 'package:secure_access/screens/login_screen.dart';
import 'package:secure_access/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserByFirebaseIdController extends GetxController {
  getNamesList(String firebaseId) async {
    // List<UserByNumberModel> userListObj = [];
    http.Response response = await http.get(
      Uri.parse(
          '${ApiService.baseUrl}/api/visitor/getVisitorByFirebaseId/$firebaseId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AppController.accessToken}',
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> result = json.decode(response.body);
      Map<String, dynamic> data = result['data'];
      // final userData = data['data'];
      final visitorId = data['id'];
      final visitorInviteStatus = data['visitorInviteStatus'];
      final fullName = data['fullName'];
      final email = data['email'];
      final mobileNo = data['mobileNo'];
      final countryCode = data['countryCode'];
      final firebaseKey = data['firebaseKey'];

      AppController.setVisitorId(visitorId);
      AppController.setVisitorInviteStatus(visitorInviteStatus);
      AppController.setnoName(fullName);
      AppController.setEmail(email);
      AppController.setMobile(mobileNo);
      AppController.setCountryCode(countryCode);
      AppController.setFirebaseKey(firebaseKey);

      AppController.setnoMatched('Yes'); //IMP

      //

      // String currentDate = DateTime.now().toIso8601String().split('T')[0];

      // // Query Firestore to find the document with the matching firebaseKey
      // QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      //     .collection("users")
      //     .where('id', isEqualTo: firebaseKey)
      //     .get();

      // if (querySnapshot.docs.isNotEmpty) {
      //   // Assuming firebaseKey is unique and will only return one document
      //   DocumentSnapshot docSnapshot = querySnapshot.docs.first;
      //   await docSnapshot.reference.update({'mobNo': mobileNo});
      //   // print('Updated document with firebaseKey: $firebaseKey');
      // } else {
      //   // print('No document found with firebaseKey: $firebaseKey');
      // }
//
    } else if (response.statusCode == 401) {
      Map<String, dynamic> result = json.decode(response.body);
      bool? status = result['status'];
      String message = result['message'];
      Get.defaultDialog(
        barrierDismissible: false,
        title: "Error",
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
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.remove('token');
          Get.offAll(LoginPage());
        },
      );
    } else {
      return;
    }
  }
}
