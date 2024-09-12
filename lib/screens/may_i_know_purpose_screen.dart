import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:secure_access/controllers/app_controller.dart';
import 'package:secure_access/model_face/user_model.dart';
import 'package:secure_access/screens/carrying_asset_screen.dart';
import 'package:secure_access/screens/first_visit_screen.dart';

class MayIKnowYourPurposeScreen extends StatefulWidget {
  const MayIKnowYourPurposeScreen(
      {super.key,
      this.countryCode,
      this.mobileNumber,
      this.meetingFor,
      this.image,
      this.faceFeatures,
      this.firebaseKey,
      this.fullName,
      this.email});

  final String? countryCode;
  final String? mobileNumber;
  final String? fullName;
  final String? email;
  final int? meetingFor;
  final String? image;
  final String? firebaseKey;
  final FaceFeatures? faceFeatures;

  @override
  State<MayIKnowYourPurposeScreen> createState() =>
      _MayIKnowYourPurposeScreenState();
}

class _MayIKnowYourPurposeScreenState extends State<MayIKnowYourPurposeScreen> {
  @override
  Widget build(BuildContext context) {
    // print(widget.countryCode);
    // print(widget.mobileNumber);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                    )),

                // ElevatedButton(
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: const Color.fromARGB(255, 160, 199, 24),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(5),
                //     ),
                //   ),
                //   onPressed: () {
                //     Get.to(const FirstVisitScreen());
                //   },
                //   child: const Text('Next'),
                // ),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              'May I know the purpose of your visit?',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    if (AppController.noMatched == 'No') {
                      AppController.setnoName(null);
                      Get.to(FirstVisitScreen(
                        countryCode: widget.countryCode,
                        mobNo: widget.mobileNumber,
                        purpose: 'Vendor',
                        image: widget.image ?? '',
                        faceFeatures: widget.faceFeatures,
                      ));
                    } else {
                      Get.to(
                        CarryingAssetsScreen(
                          countryCode: widget.countryCode,
                          mobNo: widget.mobileNumber,
                          meetingFor: widget.meetingFor,
                          fullName: AppController.noName,
                          email: AppController.email,
                          purpose: 'Vendor',
                          firebaseKey: widget.firebaseKey,
                          image: widget.image ?? '',
                          faceFeatures: widget.faceFeatures,
                        ),
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        // color: const Color.fromARGB(255, 221, 216, 216),
                        shape: BoxShape.rectangle,
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(
                          10,
                        )),
                    width: 400,
                    height: 60,
                    child: const Center(
                      child: Text(
                        'Vendor',
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    if (AppController.noMatched == 'No') {
                      Get.to(FirstVisitScreen(
                        countryCode: widget.countryCode,
                        mobNo: widget.mobileNumber,
                        purpose: 'Interview',
                        image: widget.image ?? '',
                        faceFeatures: widget.faceFeatures,
                      ));
                    } else {
                      Get.to(CarryingAssetsScreen(
                        countryCode: widget.countryCode,
                        mobNo: widget.mobileNumber,
                        meetingFor: widget.meetingFor,
                        fullName: AppController.noName,
                        email: AppController.email,
                        purpose: 'Interview',
                        firebaseKey: widget.firebaseKey,
                        image: widget.image ?? '',
                        faceFeatures: widget.faceFeatures,
                      ));
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        // color: const Color.fromARGB(255, 221, 216, 216),
                        shape: BoxShape.rectangle,
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(
                          10,
                        )),
                    width: 400,
                    height: 60,
                    child: const Center(
                      child: Text(
                        'Interview Purpose',
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    if (AppController.noMatched == 'No') {
                      Get.to(FirstVisitScreen(
                        countryCode: widget.countryCode,
                        mobNo: widget.mobileNumber,
                        purpose: 'Client/Consultant',
                        image: widget.image ?? '',
                        faceFeatures: widget.faceFeatures,
                      ));
                    } else {
                      Get.to(CarryingAssetsScreen(
                        countryCode: widget.countryCode,
                        mobNo: widget.mobileNumber,
                        meetingFor: widget.meetingFor,
                        fullName: AppController.noName,
                        email: AppController.email,
                        purpose: 'Client/Consultant',
                        firebaseKey: widget.firebaseKey,
                        image: widget.image ?? '',
                        faceFeatures: widget.faceFeatures,
                      ));
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        // color: const Color.fromARGB(255, 221, 216, 216),
                        shape: BoxShape.rectangle,
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(
                          10,
                        )),
                    width: 400,
                    height: 60,
                    child: const Center(
                      child: Text(
                        'Client/Consultant',
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    if (AppController.noMatched == 'No') {
                      Get.to(FirstVisitScreen(
                        countryCode: widget.countryCode,
                        mobNo: widget.mobileNumber,
                        purpose: 'Contract Employees',
                        image: widget.image ?? '',
                        faceFeatures: widget.faceFeatures,
                      ));
                    } else {
                      Get.to(CarryingAssetsScreen(
                        countryCode: widget.countryCode,
                        mobNo: widget.mobileNumber,
                        meetingFor: widget.meetingFor,
                        fullName: AppController.noName,
                        email: AppController.email,
                        purpose: 'Contract Employees',
                        firebaseKey: widget.firebaseKey,
                        image: widget.image ?? '',
                        faceFeatures: widget.faceFeatures,
                      ));
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        // color: const Color.fromARGB(255, 221, 216, 216),
                        shape: BoxShape.rectangle,
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(
                          10,
                        )),
                    width: 400,
                    height: 60,
                    child: const Center(
                      child: Text(
                        'Contract Employees',
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    if (AppController.noMatched == 'No') {
                      Get.to(FirstVisitScreen(
                        countryCode: widget.countryCode,
                        mobNo: widget.mobileNumber,
                        purpose: 'Others',
                        image: widget.image ?? '',
                        faceFeatures: widget.faceFeatures,
                      ));
                    } else {
                      Get.to(CarryingAssetsScreen(
                        countryCode: widget.countryCode,
                        mobNo: widget.mobileNumber,
                        meetingFor: widget.meetingFor,
                        fullName: AppController.noName,
                        email: AppController.email,
                        purpose: 'Others',
                        firebaseKey: widget.firebaseKey,
                        image: widget.image ?? '',
                        faceFeatures: widget.faceFeatures,
                      ));
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        // color: const Color.fromARGB(255, 221, 216, 216),
                        shape: BoxShape.rectangle,
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(
                          10,
                        )),
                    width: 400,
                    height: 60,
                    child: const Center(
                      child: Text(
                        'Others',
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
