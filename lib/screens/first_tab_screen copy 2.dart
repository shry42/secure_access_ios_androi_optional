import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:secure_access/authenticate_face/authenticate_face_view.dart';
import 'package:secure_access/common/utils/custom_snackbar.dart';
import 'package:secure_access/common/utils/screen_size_util.dart';
import 'package:secure_access/controllers/app_controller.dart';
import 'package:secure_access/controllers/check_session_by_number_controller.dart';
import 'package:secure_access/controllers/checkout_session_by_controller.dart';
import 'package:secure_access/screens/checkout_authenticate.dart';

class FirstTabScreenTablet extends StatefulWidget {
  const FirstTabScreenTablet({super.key});

  @override
  State<FirstTabScreenTablet> createState() => _FirstTabScreenTabletState();
}

class _FirstTabScreenTabletState extends State<FirstTabScreenTablet> {
  final CheckSessionByNumberController UserByNumberCont =
      Get.put(CheckSessionByNumberController());

  final CheckoutSessionByController UserByNumberContro =
      Get.put(CheckoutSessionByController());

  @override
  Widget build(BuildContext context) {
    initializeUtilContexts(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        // physics: const NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const SizedBox(height: 42),
            // Image.asset(
            //   "assets/images/gegadyne_logo.jpg",
            //   height: 210,
            // ),
            // const SizedBox(
            //   height: 30,
            // ),
            // const Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     Text(
            //       'வரவேற்பு',
            //       style: TextStyle(
            //         fontSize: 28,
            //       ),
            //     ),
            //     SizedBox(
            //       width: 25,
            //     )
            //   ],
            // ),
            // const SizedBox(height: 10),
            // const Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     SizedBox(
            //       width: 350,
            //     ),
            //     Text(
            //       'स्वागत है',
            //       style: TextStyle(
            //         fontSize: 28,
            //       ),
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 10),
            // const Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     SizedBox(
            //       width: 25,
            //     ),
            //     Text('Wollenna',
            //         style: TextStyle(
            //           fontSize: 20,
            //         )),
            //   ],
            // ),
            // const SizedBox(height: 10),
            // Center(
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Image.asset(
            //         'assets/images/hi.png',
            //         height: 100,
            //       ),
            //       const Text(
            //         'Welcome',
            //         style: TextStyle(fontSize: 75, color: Colors.black),
            //       ),
            //     ],
            //   ),
            // ),
            // const SizedBox(height: 18),
            // const Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     SizedBox(
            //       width: 30,
            //     ),
            //     Text(
            //       'Failte',
            //       style: TextStyle(
            //         fontSize: 28,
            //       ),
            //     ),
            //     SizedBox(
            //       width: 440,
            //     ),
            //     Text(
            //       'Добродошли',
            //       style: TextStyle(fontSize: 38),
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 20),
            // const Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     SizedBox(
            //       width: 110,
            //     ),
            //     Text(
            //       'Boolkhent!',
            //       style: TextStyle(fontSize: 32),
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 7),
            // const Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     SizedBox(
            //       width: 300,
            //     ),
            //     Text(
            //       'Bienvenida',
            //       style: TextStyle(fontSize: 24),
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 20),
            // const Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     SizedBox(
            //       width: 100,
            //     ),
            //     Text(
            //       'ಸ್ವಾಗತ',
            //       style: TextStyle(fontSize: 28),
            //     ),
            //     SizedBox(
            //       width: 450,
            //     ),
            //     Text(
            //       '歡迎',
            //       style: TextStyle(fontSize: 28),
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 25),
            // const Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     SizedBox(
            //       width: 460,
            //     ),
            //     Text(
            //       'ようこそ',
            //       style: TextStyle(fontSize: 28),
            //     ),
            //   ],
            // ),

            // //  below bar button starts

            // const SizedBox(
            //   height: 169,
            // ),
            Image.asset(
              "assets/images/welcome.png",
              height: 1000,
              width: 1500,
            ),
            Stack(children: [
              Container(
                height: 80,
                color: Colors.green,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 21),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // GestureDetector(
                          //   onTap: () async {
                          //     SharedPreferences prefs =
                          //         await SharedPreferences.getInstance();
                          //     await prefs.remove('token'); // for logout
                          //     AppController.setnoName('');
                          //     AppController.setEmail('');
                          //     AppController.setMobile('');
                          //     AppController.setCountryCode('');
                          //     AppController.setUserName('');
                          //     AppController.setFirebaseKey(null);
                          //     AppController.setnoMatched('No');
                          //     AppController.setCallUpadteMethod(0);
                          //     AppController.setValidKey(0);
                          //     AppController.setFaceMatched(0);
                          //     AppController.setDateFromBackend(null);
                          //     Get.offAll(LoginPage());
                          //   },
                          //   child: Container(
                          //     padding: const EdgeInsets.all(
                          //         8.0), // Space between icon and border
                          //     decoration: BoxDecoration(
                          //       shape: BoxShape.circle, // Circular shape
                          //       border: Border.all(
                          //         color: Colors.white, // Border color
                          //         width: 2.0, // Border width
                          //       ),
                          //     ),
                          //     child: const Icon(
                          //       Icons.power_settings_new,
                          //       color: Colors.white, // Icon color
                          //       size: 30.0, // Icon size
                          //     ),
                          //   ),
                          // ),
                          const Spacer(),
                          const Icon(
                            Icons.logout,
                            color: Colors.white,
                            size: 35,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: () async {
                              await UserByNumberContro.getNamesList(9892813430);
                              // Get.to(const Checkout_android());
                            },
                            child: const Text(
                              'Checkout',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                bottom: 12,
                left: 310,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize: const Size(200, 60)),
                  onPressed: () async {
                    await UserByNumberCont.getNamesList(9892813430);
                  },
                  child: const Text(
                    'Tap to Check In',
                    style: TextStyle(
                        color: Color.fromARGB(255, 12, 44, 13),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  void initializeUtilContexts(BuildContext context) {
    ScreenSizeUtil.context = context;
    CustomSnackBar.context = context;
  }
}
