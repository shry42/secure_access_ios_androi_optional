import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:secure_access/controllers/app_controller.dart';
import 'package:secure_access/controllers/user_by_number_controller.dart';
import 'package:secure_access/model_face/user_model.dart';
import 'package:secure_access/screens/carrying_asset_screen.dart';
import 'package:secure_access/screens/first_tab_screen%20copy%202.dart';
import 'package:secure_access/screens/login_screen.dart';
import 'package:secure_access/screens/may_i_know_purpose_screen.dart';
import 'package:secure_access/screens/whom_meeting_today_screen.dart';
import 'package:secure_access/utils/toast_notify.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProvidePhoneNumberScreen extends StatefulWidget {
  const ProvidePhoneNumberScreen(
      {super.key, this.image, this.faceFeatures, this.firebaseKey});
  final String? image;
  final String? firebaseKey;

  final FaceFeatures? faceFeatures;

  @override
  State<ProvidePhoneNumberScreen> createState() =>
      _ProvidePhoneNumberScreenState();
}

class _ProvidePhoneNumberScreenState extends State<ProvidePhoneNumberScreen> {
  late String currentTime;
  late String currentDate;
  late String selectedCountryCode;

  final TextEditingController _phoneController = TextEditingController();

  final UserByNumberController ubnc = Get.put(UserByNumberController());

  bool isButtonGreen = false; // To track if the "Next" button should be green

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Get the current date
    DateTime now = DateTime.now();
    currentDate =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    // Get the current time in 24-hour format
    currentTime =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    // Initialize the selectedCountryCode with the default country code
    selectedCountryCode = '+91'; // You can set it to any default value
  }

  @override
  Widget build(BuildContext context) {
    // print(currentDate);
    // print(currentTime);
    return WillPopScope(
      onWillPop: () async {
        return await Get.defaultDialog(
          backgroundColor: Colors.white,
          title: "Exit?",
          middleText: "Go back to HomeScreen",
          textConfirm: 'Yes',
          textCancel: 'No',
          onConfirm: () {
            Get.offAll(const FirstTabScreenTablet());
          },
          onCancel: () {
            Get.back(result: false);
          },
        );
      },
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: () {
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
                            Get.offAll(const FirstTabScreenTablet());
                          },
                          child: const Icon(
                            Icons.arrow_back_ios,
                          )),
                      const SizedBox(
                        width: 220,
                      ),
                      Obx(() {
                        // Show loading spinner while the controller is processing data
                        return ubnc.isLoading.value
                            ? Center(
                                child: LoadingAnimationWidget.hexagonDots(
                                  color: Colors.lightGreen,
                                  size: 30,
                                ),
                              )
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isButtonGreen
                                      ? const Color.fromARGB(255, 96, 201, 67)
                                      : const Color.fromARGB(2, 192, 198, 199),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                onPressed: () async {
                                  // Get.to(const FirstVisitScreen());
                                  if (_formKey.currentState!.validate()) {
                                    AppController.setnoMatched(null);
                                    AppController.setMobile(
                                        _phoneController.text.toString());
                                    await ubnc.getNamesList(
                                        int.parse(_phoneController.text));

                                    /***newly added below*/
                                    if (AppController.noMatched == 'No' &&
                                        AppController
                                                .mobNoMatchedButFirebaseKeyNull ==
                                            1) {
                                      Get.to(CarryingAssetsScreen(
                                        countryCode: AppController.countryCode,
                                        fullName: AppController.noName,
                                        email: AppController.email,
                                        mobNo: AppController.mobile,
                                        image: widget.image,
                                        faceFeatures: widget.faceFeatures,
                                        firebaseKey: AppController.firebaseKey,
                                      ));
                                      /***newly added above*/
                                    } else if (AppController
                                            .mobNoMatchedButFirebaseKeyExistsButNotInFirestore ==
                                        1) {
                                      Get.to(CarryingAssetsScreen(
                                        countryCode: AppController.countryCode,
                                        fullName: AppController.noName,
                                        email: AppController.email,
                                        mobNo: AppController.mobile,
                                        image: widget.image,
                                        faceFeatures: widget.faceFeatures,
                                        firebaseKey: AppController.firebaseKey,
                                      ));
                                    } else if (AppController.noMatched ==
                                        'No') {
                                      Get.to(MayIKnowYourPurposeScreen(
                                        countryCode: selectedCountryCode,
                                        mobileNumber: _phoneController.text,
                                        image: widget.image ?? '',
                                        faceFeatures: widget.faceFeatures,
                                      ));
                                    } else if (AppController.accessToken ==
                                        null) {
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
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      await prefs.remove('token');
                                      Get.offAll(LoginPage());
                                    } else {
                                      // String userId = Uuid().v1();
                                      if (AppController
                                              .mobNoMatchedButFirebaseKeyNull ==
                                          1) {
                                        ///when unique code is sent then firebase is null
                                        Get.to(WhomMeetingTodayScreen(
                                          fullName: AppController.noName,
                                          email: AppController.email,
                                          image: widget.image ?? '',
                                          faceFeatures: widget.faceFeatures,
                                          // firebaseKey: userId
                                        ));
                                      }
                                      Get.to(WhomMeetingTodayScreen(
                                        fullName: AppController.noName,
                                        email: AppController.email,
                                        image: widget.image ?? '',
                                        faceFeatures: widget.faceFeatures,
                                        firebaseKey: AppController.firebaseKey,
                                      ));
                                    }
                                  }
                                },
                                child: const Text(
                                  'Next',
                                  style: TextStyle(color: Colors.black),
                                ),
                              );
                      }),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Please provide your phone number',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 400,
                        height: 100,
                        child: IntlPhoneField(
                          validator: (Value) {
                            if (Value == null) {
                              return 'Please enter Mobile Number';
                            }
                          },
                          controller: _phoneController,
                          flagsButtonPadding: const EdgeInsets.all(20),
                          dropdownIconPosition: IconPosition.trailing,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(8),
                            labelText: 'Phone Number',
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          initialCountryCode: 'IN',
                          onChanged: (phone) {
                            // Update the selectedCountryCode when the country code changes
                            selectedCountryCode = phone.countryCode!;
                            setState(() {
                              isButtonGreen = phone.completeNumber.length >=
                                  13; // Update the button state based on validation
                            });
                          },
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 25),
                  // const Text(
                  //   'if your visit is scheduled, Scan your QR Code',
                  //   textAlign: TextAlign.center,
                  // ),
                  // const SizedBox(height: 15),
                  // CircleAvatar(
                  //   backgroundColor: Colors.grey,
                  //   radius: 32,
                  //   child: CircleAvatar(
                  //     backgroundColor: Colors.white,
                  //     radius: 31,
                  //     child: Image.asset(
                  //       'assets/images/qr.png',
                  //       height: 32,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
