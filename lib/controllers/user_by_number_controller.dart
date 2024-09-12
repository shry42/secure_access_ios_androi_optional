import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:secure_access/controllers/app_controller.dart';
import 'package:secure_access/models/user_by_number_model.dart';
import 'package:secure_access/services/api_services.dart';
import 'package:secure_access/utils/toast_notify.dart';

class UserByNumberController extends GetxController {
  var isLoading = false.obs; // Observable to track loading state

  getNamesList(int number) async {
    isLoading.value = true; // Start the loading indicator
    String currentDate = DateTime.now().toIso8601String().split('T')[0];
    List<UserByNumberModel> userListObj = [];
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
      // final userData = data['data'];
      final fullName = data['fullName'];
      final email = data['email'];
      final mobileNo = data['mobileNo'];
      final countryCode = data['countryCode'];
      final firebaseKey = data['firebaseKey'];
      final visitorID = data['id'];

      AppController.setnoName(fullName);
      AppController.setEmail(email);
      AppController.setMobile(mobileNo);
      AppController.setCountryCode(countryCode);
      AppController.setFirebaseKey(firebaseKey);
      AppController.setnoMatched('Yes');
      AppController.setVisitorId(visitorID);

      /*****************************/

      if (firebaseKey != null || firebaseKey != "") {
        AppController.setFirebaseKey(firebaseKey);
        AppController.setnoMatched('Yes');

        // Query Firestore to find the document with the matching firebaseKey
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection("users")
            .where('id', isEqualTo: firebaseKey)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // AppController.setValidKey(1);
          // Assuming firebaseKey is unique and will only return one document
          DocumentSnapshot docSnapshot = querySnapshot.docs.first;
          await docSnapshot.reference.update({'updatedOn': currentDate});
          // print('Updated document with firebaseKey: $firebaseKey');
        } else {
          //   // print('No document found with firebaseKey: $firebaseKey');
          // AppController.setmobNoMatchedButFirebaseKeyExistsButNotInFirestore(1);
          // AppController.setnoMatched('No');
          // AppController.setValidKey(1);
          // AppController.setFaceMatched(0);
          //
          AppController.setnoMatched('');
          AppController.setFaceMatched(0);
          AppController.setValidKey(0);
          AppController.mobNoMatchedButFirebaseKeyNull;
          //
        }
      }

      //***************** */
      if (firebaseKey == "" || firebaseKey == null) {
        AppController.setCallUpadteMethod(1);
        AppController.setMobNoMatchedButFirebaseKeyNull(1);

        //  for UPDATED ON FIELD

        // Query Firestore to find the document with the matching firebaseKey

        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection("users")
            .where('mobNo', isEqualTo: mobileNo)
            .get();
        if (querySnapshot.docs.isNotEmpty) {
          // AppController.setMobNoMatchedButFirebaseKeyNull(1);
          AppController.setnoMatched('Yes');
          AppController.setValidKey(0);
          // Assuming firebaseKey is unique and will only return one document
          DocumentSnapshot docSnapshot = querySnapshot.docs.first;

          String userId =
              docSnapshot.get('id'); // Extract 'id' field from document
          AppController.setFirebaseKey(userId);

          await docSnapshot.reference.update({'updatedOn': currentDate});
          // print('Updated document with firebaseKey: $firebaseKey');
        } else {
          // print('No document found with firebaseKey: $firebaseKey');
          AppController.setnoMatched('');
          AppController.setFaceMatched(0);
          AppController.setValidKey(0);
          AppController.mobNoMatchedButFirebaseKeyNull;
          // AppController.setnoMatched('No');
        }

//
      }

      isLoading.value = false; // Stop the loading indicator
//
      return userListObj;
    } else if (response.statusCode == 400) {
      isLoading.value = false; // Stop the loading indicator

      AppController.setnoMatched('No');
      // AppController.setaccessToken(null);
      // toast('unauthorized');
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // await prefs.remove('token');
    } else if (response.statusCode == 401) {
      isLoading.value = false; // Stop the loading indicator

      AppController.setaccessToken(null);
      toast('Unauthorized');
    }
  }
}
