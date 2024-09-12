import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:secure_access/controllers/app_controller.dart';
import 'package:secure_access/services/api_services.dart';
import 'package:secure_access/utils/toast_notify.dart';

class OTPController extends GetxController {
  RxString employeeId = ''.obs;
  RxBool isOtpSent = false.obs; // To manage OTP field visibility
  RxBool loading = false.obs; // To manage the loading state
  RxString buttonText = 'Get OTP'.obs; // To manage button text

  // Function to send OTP based on employee ID
  Future<void> sendLoginOtp() async {
    loading.value = true; // Show loading message
    try {
      http.Response response = await http.post(
        Uri.parse('${ApiService.baseUrl}/api/auth/sendLoginOtp'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "employeeId": employeeId.value,
        }),
      );

      loading.value = false; // Hide loading message

      Map<String, dynamic> result = jsonDecode(response.body);
      String message = result['message'];

      if (response.statusCode == 200 && result['status'] == true) {
        // OTP sent successfully
        toast(message); // Show toast with API-provided message
        isOtpSent.value = true;
        buttonText.value = 'Login'; // Change button text to Login
        AppController.setmessage(null);
      } else {
        // OTP sending failed, use the message from the response
        AppController.setmessage(message);
        isOtpSent.value = false; // Ensure OTP field is hidden if OTP fails
        buttonText.value = 'Get OTP'; // Keep button text as Get OTP
        showDialog(
          context: Get.context!,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(message),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      loading.value = false; // Hide loading message on error
      buttonText.value = 'Get OTP'; // Reset button text
      toast('An error occurred. Please try again.');
    }
  }

  // Function to resend OTP (reuse the existing sendLoginOtp function)
  void resendOtp() {
    sendLoginOtp();
  }
}
