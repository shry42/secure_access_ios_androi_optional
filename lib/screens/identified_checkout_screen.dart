import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:secure_access/controllers/app_controller.dart';
import 'package:secure_access/controllers/checkout_controller.dart';
import 'package:secure_access/controllers/user_by_firebase_id_controller.dart';
import 'package:secure_access/model_face/user_model.dart';
import 'package:secure_access/screens/first_tab_screen%20copy%202.dart';
import 'package:secure_access/utils/toast_notify.dart';

class IdentifiedCheckoutScreen extends StatefulWidget {
  final UserModel user;
  final dynamic dispImg;
  const IdentifiedCheckoutScreen(
      {super.key, required this.user, required this.dispImg});

  @override
  State<IdentifiedCheckoutScreen> createState() =>
      _IdentifiedCheckoutScreenState();
}

class _IdentifiedCheckoutScreenState extends State<IdentifiedCheckoutScreen> {
  dynamic image;
  final UserByFirebaseIdController ubfic = UserByFirebaseIdController();
  final CheckoutController cc = CheckoutController();
  @override
  void initState() {
    String base64String = widget.dispImg; // Replace with your base64 string
    Uint8List bytes = base64Decode(base64String);
    image = Image.memory(bytes);
    super.initState();
  }

  // Method to capitalize the first letter of each word
  String _capitalizeWords(String text) {
    if (text.isEmpty) return text;
    return text
        .split(' ')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1)}'
            : '')
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              height: 560,
              width: 500,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 100, width: 100, child: image),
                  const SizedBox(
                    height: 22,
                  ),
                  const Text(
                    'We recognise you from your \n      last visit!',
                    style: TextStyle(fontSize: 22),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    textAlign: TextAlign.center,
                    'Hello ${_capitalizeWords(widget.user.name.toString())}\nDo you want to checkout?',
                    style: const TextStyle(
                        fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(160, 50),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          onPressed: () {
                            toast('Chckout cancelled');
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
                            Get.offAll(const FirstTabScreenTablet());
                          },
                          child: const Text(
                            'No',
                            style: TextStyle(
                                color: Color.fromARGB(255, 152, 225, 50),
                                fontSize: 18),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(160, 50),
                            backgroundColor:
                                const Color.fromARGB(255, 152, 225, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          onPressed: () async {
                            await ubfic.getNamesList('${widget.user.id}');
                            await cc.checkout(AppController.visitorId);
                            // toast('Checkout successful');
                            // Get.offAll(const FirstTabScreen());

                            // toast('Your Checkin is not yet approved');
                            // Get.offAll(const FirstTabScreen());
                          },
                          child: const Text(
                            'Yes',
                            style: TextStyle(
                                color: Color.fromARGB(255, 249, 249, 249),
                                fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
