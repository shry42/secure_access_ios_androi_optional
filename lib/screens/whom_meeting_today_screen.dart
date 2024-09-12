import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:secure_access/controllers/app_controller.dart';
import 'package:secure_access/controllers/usernames_whom_to_meet_controller.dart';
import 'package:secure_access/model_face/user_model.dart';
import 'package:secure_access/screens/carrying_asset_screen.dart';
import 'package:secure_access/screens/may_i_know_purpose_screen.dart';

class WhomMeetingTodayScreen extends StatefulWidget {
  const WhomMeetingTodayScreen(
      {super.key,
      this.countryCode,
      this.fullName,
      this.email,
      this.purpose,
      this.mobNo,
      this.firebaseKey,
      this.faceFeatures,
      this.image});

  final String? countryCode, fullName, email, purpose, mobNo, firebaseKey;
  final FaceFeatures? faceFeatures;
  final String? image;

  // final String? mobNo;
  // final String? purpose;

  @override
  State<WhomMeetingTodayScreen> createState() => _WhomMeetingTodayScreenState();
}

class _WhomMeetingTodayScreenState extends State<WhomMeetingTodayScreen> {
  final UserNamesWhomToMeetController unwtmc = UserNamesWhomToMeetController();
  final _formKey = GlobalKey<FormState>();

  List<dynamic> namesList = [];

  bool isButtonGreen = false; // Track if the "Next" button should be green

  int? nameId;

  void getListNames() async {
    namesList = await unwtmc.getNamesList();
    setState(() {});
  }

  @override
  void initState() {
    getListNames();
    // setState(() {
    //   namesList = unwtmc.getNamesList();
    // });
    super.initState();
  }

  // List namesList = ['rohan', 'sangam', 'shravan'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: const Icon(
                        Icons.arrow_back_ios,
                      )),
                  // const SizedBox(
                  //   width: 220,
                  // ),
                  // Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isButtonGreen
                          ? const Color.fromARGB(255, 96, 201, 67)
                          : const Color.fromARGB(2, 192, 198,
                              199), // Change button color based on selection
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (AppController.noMatched == 'No') {
                          AppController.setFirebaseKey(null);
                          Get.to(CarryingAssetsScreen(
                            countryCode: widget.countryCode,
                            fullName: widget.fullName,
                            email: widget.email,
                            mobNo: widget.mobNo,
                            purpose: widget.purpose,
                            meetingFor: nameId,
                            image: widget.image,
                            faceFeatures: widget.faceFeatures,
                            firebaseKey: widget.firebaseKey,
                          ));
                        } else {
                          Get.to(
                            MayIKnowYourPurposeScreen(
                              fullName: widget.fullName,
                              email: widget.email,
                              countryCode: AppController.countryCode,
                              mobileNumber: AppController.mobile,
                              meetingFor: nameId,
                              image: widget.image,
                              faceFeatures: widget.faceFeatures,
                              firebaseKey: widget.firebaseKey,
                            ),
                          );
                        }
                      }
                    },
                    child: const Text(
                      'Next',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                AppController.noName != null
                    ? 'Hello ${AppController.noName}! Who are you meeting today?'
                    : 'Great! Who are you meeting today?',
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 25),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: DropdownButtonFormField<int>(
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a name';
                    }
                  },
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    // focusColor: Colors.transparent,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          color:
                              Colors.black12), // Set the focused border color
                    ),
                    labelText: 'Select Name',
                    labelStyle: const TextStyle(color: Colors.black),
                  ),
                  // value: widget.reportingManagerId,
                  items: namesList
                      .map((names) => DropdownMenuItem<int>(
                            value: names.id,
                            child: Text('${names.firstName} ${names.lastName}'),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      nameId = value;
                      isButtonGreen = nameId !=
                          null; // Update the button state based on selection
                    });
                  },
                ),
              ),
              const SizedBox(height: 15),
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
              // )
            ],
          ),
        ),
      ),
    );
  }
}
