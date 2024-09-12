import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:secure_access/controllers/app_controller.dart';
import 'package:secure_access/models/visitor_user_model.dart';
import 'package:secure_access/services/api_services.dart';

class GetAllVisitorsController extends GetxController {
  getAllVistorsList(String date) async {
    List<VistorUserModel> userListObj = [];

    http.Response response = await http.get(
      Uri.parse('${ApiService.baseUrl}/api/visitor/getVisitors/$date'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AppController.accessToken}',
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> result = json.decode(response.body);
      List<dynamic> data = result['data'];
      userListObj = data.map((e) => VistorUserModel.fromJson(e)).toList();
      return userListObj;
    }
  }
}
