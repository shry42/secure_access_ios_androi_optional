import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:secure_access/controllers/app_controller.dart';
import 'package:secure_access/controllers/unique_key_visitor%20copy.dart';
import 'package:secure_access/model_face/user_model.dart';
import 'package:secure_access/screens/carrying_asset_screen.dart';
import 'package:secure_access/screens/first_tab_screen%20copy%202.dart';
import 'package:secure_access/screens/provide_phone_number_screen.dart';
import 'package:secure_access/screens/whom_meeting_today_screen.dart';

class DoYouHaveUniqueKey extends StatefulWidget {
  const DoYouHaveUniqueKey(
      {super.key,
      this.countryCode,
      this.fullName,
      this.email,
      this.purpose,
      this.mobNo,
      this.meetingFor,
      this.firebaseKey,
      this.image,
      this.faceFeatures});

  final String? countryCode, fullName, email, purpose, mobNo, firebaseKey;
  final int? meetingFor;
  final String? image;
  final FaceFeatures? faceFeatures;

  @override
  State<DoYouHaveUniqueKey> createState() => _DoYouHaveUniqueKeyState();
}

class _DoYouHaveUniqueKeyState extends State<DoYouHaveUniqueKey> {
  final TextEditingController uniqueKeyController = TextEditingController();
  final TextEditingController mobileControlller = TextEditingController();
  final UniqueKeyController ukc = Get.put(UniqueKeyController());
  final _formKey = GlobalKey<FormState>();
  bool isButtonGreen = false; // Track if the submit button should be green
  bool isYes = false;

  late String selectedCountryCode;

  final String? toolName = '';
  final String? make = '';
  final String? quantity = '';
  final String? remark = '';
  int? hasTool = 0;

  late XFile? selectedImage;
  bool displayImage = false;
  String? base64ImageTool;
  Uint8List? bytes;
  late String currentTime;
  late String currentDate;

  @override
  void initState() {
    super.initState();

    // Convert the image to bytes if provided
    if (widget.image != null) {
      bytes = base64Decode(widget.image!);
    }

    // Get the current date
    DateTime now = DateTime.now();
    currentDate =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    // Get the current time in 24-hour format
    currentTime =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    // Listen to changes in text fields
    uniqueKeyController.addListener(_validateFields);
    mobileControlller.addListener(_validateFields);
  }

  // Method to validate unique key and mobile number fields
  void _validateFields() {
    setState(() {
      isButtonGreen = uniqueKeyController.text.isNotEmpty &&
          mobileControlller.text.length == 10;
    });
  }

  @override
  void dispose() {
    uniqueKeyController.dispose();
    mobileControlller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          child: const Icon(
            Icons.arrow_back_ios_new,
            size: 30,
          ),
          onTap: () {
            Get.offAll(const FirstTabScreenTablet());
          },
        ),
        title: const Icon(Icons.key),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  'Do you have unique key?',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          minimumSize: const Size(150, 60),
                        ),
                        onPressed: () {
                          setState(() {
                            hasTool = 1;
                            isYes = true;
                          });
                        },
                        child: const Text(
                          'Yes',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 70),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          minimumSize: const Size(150, 60),
                        ),
                        onPressed: () {
                          if (AppController.noMatched == 'Yes') {
                            Get.to(
                              WhomMeetingTodayScreen(
                                countryCode: AppController.countryCode,
                                email: AppController.email,
                                mobNo: AppController.mobile,
                                image: widget.image,
                                faceFeatures: widget.faceFeatures,
                                firebaseKey: AppController.firebaseKey,
                              ),
                            );
                          } else {
                            Get.to(ProvidePhoneNumberScreen(
                              image: widget.image,
                              faceFeatures: widget.faceFeatures,
                            ));
                          }
                        },
                        child: const Text(
                          'No',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Image.asset(
                //   'assets/images/gegadyne_logo.jpg',
                //   height: 400,
                // ),

                if (isYes == false)
                  const Text(
                    'Note : Please check your email for unique key',
                    style: TextStyle(),
                  ),

                if (isYes == true)
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 40),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: uniqueKeyController,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              labelText: '    Unique Key',
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter Unique key";
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: mobileControlller,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              labelText: '    Mobile Number',
                            ),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(10),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter mobile number";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 50),
                        Obx(() {
                          // Show loading spinner while the controller is processing data
                          return ukc.isLoading.value
                              ? Center(
                                  child: LoadingAnimationWidget.hexagonDots(
                                    color: Colors.lightGreen,
                                    size: 50,
                                  ),
                                )
                              : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(200, 60),
                                    backgroundColor: isButtonGreen
                                        ? const Color.fromARGB(255, 96, 201, 67)
                                        : const Color.fromARGB(255, 222, 218,
                                            218), // Change button color based on validation
                                  ),
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      await ukc.getUniqueVistorByUniqueKey(
                                          uniqueKeyController.text,
                                          mobileControlller.text);
                                      if (AppController.isValidKey == 1) {
                                        Get.to(CarryingAssetsScreen(
                                          countryCode:
                                              AppController.countryCode,
                                          fullName: AppController.noName,
                                          email: AppController.email,
                                          mobNo: AppController.mobile,
                                          image: widget.image,
                                          faceFeatures: widget.faceFeatures,
                                          firebaseKey:
                                              AppController.firebaseKey,
                                        ));
                                      } else {
                                        return;
                                      }
                                    }
                                  },
                                  child: const Text(
                                    'Submit',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 25),
                                  ),
                                );
                        }),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
