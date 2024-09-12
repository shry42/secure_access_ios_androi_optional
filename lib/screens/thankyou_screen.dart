import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:secure_access/controllers/app_controller.dart';
import 'package:secure_access/controllers/final_thankyou_form_controller.dart';
import 'package:secure_access/controllers/update_thankyou_unique_key_visitor.dart';
import 'package:secure_access/model_face/user_model.dart';
import 'package:secure_access/screens/thankyou_final_screen.dart';
import 'package:secure_access/utils/toast_notify.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'dart:ui' as ui;

import 'package:uuid/uuid.dart';

class ThankyouScreen extends StatefulWidget {
  const ThankyouScreen(
      {super.key,
      this.countryCode,
      this.fullName,
      this.email,
      this.purpose,
      this.mobNo,
      this.meetingFor,
      this.toolName,
      this.make,
      this.remark,
      this.quantity,
      this.base64ToolImage,
      this.hasTool,
      this.firebaseKey,
      this.image,
      this.faceFeatures});

  final String? countryCode,
      fullName,
      email,
      purpose,
      mobNo,
      toolName,
      make,
      remark,
      firebaseKey,
      base64ToolImage;
  final int? meetingFor, quantity, hasTool;
  final String? image;
  final FaceFeatures? faceFeatures;

  @override
  State<ThankyouScreen> createState() => _ThankyouScreenState();
}

final TextEditingController signCont = TextEditingController();

class _ThankyouScreenState extends State<ThankyouScreen> {
  final ThankyouFormSubmissionController thanksFormController =
      Get.put(ThankyouFormSubmissionController());
  final UpdateThankuouOfUniqueVisitor utouv =
      Get.put(UpdateThankuouOfUniqueVisitor());

  late String currentTime;
  late String currentDate;
  late String selectedCountryCode;
  late String updatedDate;
  String? userId;

  bool isSignatureEmpty = true; // Track if the signature pad is empty

  createfirebase() async {
    UserModelUpdatedOne user = UserModelUpdatedOne(
        id: widget.firebaseKey ?? userId,
        name: widget.fullName,
        image: widget.image,
        registeredOn: '$currentDate $currentTime',
        faceFeatures: widget.faceFeatures,
        updatedOn: updatedDate,
        mobNo: widget.mobNo ?? AppController.mobile ?? "");
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.firebaseKey)
        .set(user.toJson())
        .catchError((e) {});
  }

  @override
  void initState() {
    // Get the current date
    DateTime now = DateTime.now();
    currentDate =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    // Get the current time in 24-hour format
    currentTime =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    updatedDate = DateTime.now().toIso8601String().split('T')[0];

    // Initialize the selectedCountryCode with the default country code
    selectedCountryCode = '+91'; // You can set it to any default value
    super.initState();
  }

  final GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();

  void _handleClearButtonPressed() {
    signatureGlobalKey.currentState!.clear();
    setState(() {
      isSignatureEmpty = true; // Reset the signature state
    });
  }

  void _handleSaveButtonPressed() async {
    if (isSignatureEmpty) {
      toast('Please sign before saving');
      return;
    }
    final data =
        await signatureGlobalKey.currentState!.toImage(pixelRatio: 3.0);
    final bytes = await data.toByteData(format: ui.ImageByteFormat.png);
    // Convert the image to a base64 string
    final base64Image = base64Encode(bytes!.buffer.asUint8List());
    userId = const Uuid().v1();
    //facematched and uniqueKey
    if (AppController.isValidKey == 1 && AppController.faceMatched == 1) {
      await utouv.upadteFinalUniqueKey(
        base64Image,
        widget.toolName,
        widget.make,
        widget.remark,
        widget.firebaseKey ?? AppController.firebaseKey ?? userId,
        widget.base64ToolImage,
        widget.hasTool.toString(),
        widget.quantity,
        AppController.dateFromBackend ?? currentDate,
      );
    } else if (AppController.faceMatched == 1 &&
        AppController.isValidKey == 0) {
      await thanksFormController.ThankyouFinalForm(
        widget.fullName.toString(),
        widget.email,
        widget.countryCode,
        widget.mobNo,
        'company',
        widget.purpose,
        'description',
        currentDate,
        currentTime,
        base64Image,
        widget.toolName,
        widget.make,
        widget.remark,
        widget.base64ToolImage,
        widget.meetingFor!.toInt(),
        widget.hasTool.toString(),
        widget.quantity,
        widget.firebaseKey ?? AppController.firebaseKey,
      );
    } else if (AppController.noMatched == 'Yes') {
      await thanksFormController.ThankyouFinalForm(
        widget.fullName.toString(),
        widget.email,
        widget.countryCode,
        widget.mobNo,
        'company',
        widget.purpose,
        'description',
        currentDate,
        currentTime,
        base64Image,
        widget.toolName,
        widget.make,
        widget.remark,
        widget.base64ToolImage,
        widget.meetingFor!.toInt(),
        widget.hasTool.toString(),
        widget.quantity,
        widget.firebaseKey ?? AppController.firebaseKey ?? userId,
      );
    } else if (AppController.faceMatched == 0 &&
        AppController.isValidKey == 1) {
      await utouv
          .upadteFinalUniqueKey(
              base64Image,
              widget.toolName,
              widget.make,
              widget.remark,
              widget.firebaseKey ?? AppController.firebaseKey ?? userId,
              widget.base64ToolImage,
              widget.hasTool.toString(),
              widget.quantity,
              AppController.dateFromBackend ?? currentDate)
          .then(createfirebase());
      // createfirebase()async{UserModel user = UserModel(
      //   id: widget.firebaseKey ?? userId,
      //   name: widget.fullName,
      //   image: widget.image,
      //   registeredOn: '$currentDate $currentTime',
      //   faceFeatures: widget.faceFeatures,
      // );
      // await FirebaseFirestore.instance
      //     .collection("users")
      //     .doc(widget.firebaseKey)
      //     .set(user.toJson())
      //     .catchError((e) {});
      // }
    } else if (AppController.faceMatched == 0 &&
        AppController.isValidKey == 0) {
      await thanksFormController.ThankyouFinalForm(
        widget.fullName.toString(),
        widget.email,
        widget.countryCode,
        widget.mobNo,
        'company',
        widget.purpose,
        'description',
        currentDate,
        currentTime,
        base64Image,
        widget.toolName,
        widget.make,
        widget.remark,
        widget.base64ToolImage,
        widget.meetingFor!.toInt(),
        widget.hasTool.toString(),
        widget.quantity,
        widget.firebaseKey ?? AppController.firebaseKey ?? userId,
      ).then(createfirebase());
      // UserModel user = UserModel(
      //   id: widget.firebaseKey ?? userId,
      //   name: widget.fullName,
      //   image: widget.image,
      //   registeredOn: '$currentDate $currentTime',
      //   // registeredOn: '',
      //   faceFeatures: widget.faceFeatures,
      // );
      // await FirebaseFirestore.instance
      //     .collection("users")
      //     .doc(widget.firebaseKey ?? userId)
      //     .set(user.toJson())
      //     .catchError((e) {});
    }

    if (AppController.accessToken == null) {
      AppController.setnoMatched('No');
      Get.offAll(const ThankyouFinalScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
          onTap: () {
            Get.back();
          },
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Thankyou!',
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'One last thing before you come in. Please sign this NDA',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    '1. I may be given access to confidential information belonging to the Gegagdyne Energy through my relationship with Company or as a result of my access to Compnay\'s premises',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    '2. I understand and acknowledge that Compnay\'s trade secrets consist of information and materials that are valuable and not generally known by Compnay\'s competitors, including:',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    '(a) Any and all information concerning Compnay\'s current, future or proposed products, including, but not limited to, computer code,drawings, specificatons, notebook entries, technical notes and graphs, computer printouts, technical memoranda and correspondence, product development agreements and related agreements. ',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    '(b) Information and materials relating to Compnay\'s purchasing, accounting and marketing; including, but not limited to, marketing plans, sales data, unpublished promotional material, cost and pricing information and customer lists',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    '(c) Information of the type described above which Company obtained from another party and which Company treats as confidential, whether or not owned or developed by Company.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    '3. I agree that the Confidential Information is to be considered confidential and proprietary to the Company, and I shall hold the same in confidence. I shall not disclose, duplicate, copy, reproduce, transmit, disseminate, or otherwise use (including by not limited to, reducing to any electronic form or storing it in a database or other electronic media) in any manner whatsoever thin Confidential Information',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey)),
                          child: SfSignaturePad(
                            key: signatureGlobalKey,
                            backgroundColor: Colors.white,
                            strokeColor: Colors.black,
                            minimumStrokeWidth: 1.0,
                            maximumStrokeWidth: 4.0,
                            onDrawStart: () {
                              setState(() {
                                isSignatureEmpty =
                                    false; // Mark signature as not empty
                              });
                              return false; // Explicitly ending the function, indicating it returns void
                            },
                          ))),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: _handleSaveButtonPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSignatureEmpty
                              ? const Color.fromARGB(2, 192, 198, 199)
                              : const Color.fromARGB(255, 150, 199,
                                  24), // Change color based on signature state
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15), // Increase padding for larger size
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(5), // Border radius of 5
                          ),
                          minimumSize: const Size(
                              100, 50), // Minimum size for the button
                        ),
                        child: const Text(
                          'Save',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _handleClearButtonPressed,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15), // Increase padding for larger size
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(5), // Border radius of 5
                          ),
                          minimumSize: const Size(
                              100, 50), // Minimum size for the button
                        ),
                        child: const Text(
                          'Clear',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Obx(() {
            bool isLoading =
                thanksFormController.isLoading.value || utouv.isLoading.value;
            return isLoading
                ? Container(
                    color: Colors.black
                        .withOpacity(0.5), // Semi-transparent background
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 20),
                          Text(
                            "Hold on while we process",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
