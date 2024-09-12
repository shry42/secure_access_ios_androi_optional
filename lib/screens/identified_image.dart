import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:secure_access/controllers/app_controller.dart';
import 'package:secure_access/controllers/user_by_firebase_id_controller.dart';
import 'package:secure_access/model_face/user_model.dart';
import 'package:secure_access/screens/do_you_hv_unique_key%20copy.dart';

class IdentifiedImageScreen extends StatefulWidget {
  final UserModel user;
  final dynamic dispImg;
  final FaceFeatures? faceFeatures;
  const IdentifiedImageScreen(
      {super.key,
      required this.user,
      required this.dispImg,
      this.faceFeatures});

  @override
  State<IdentifiedImageScreen> createState() => _IdentifiedImageScreenState();
}

class _IdentifiedImageScreenState extends State<IdentifiedImageScreen> {
  dynamic image;
  final UserByFirebaseIdController ubfic = UserByFirebaseIdController();
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
    // print("${AppController.accessToken}");
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
              height: 440,
              width: 430,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 100, width: 100, child: image),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    'We recognise you from your \n      last visit!',
                    style: TextStyle(fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 14),
                  Center(
                    child: Text(
                      'Are you ${_capitalizeWords(widget.user.name.toString())}?',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 25),
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
                            // Get.offAll(
                            //     ProvidePhoneNumberScreen(
                            //       firebaseKey: '${widget.user.id}',
                            //       faceFeatures: widget.faceFeatures,
                            //       image: widget.dispImg,
                            //     ),
                            //     transition: Transition.rightToLeft,
                            //     duration: const Duration(milliseconds: 500));
                            Get.offAll(
                              // ProvidePhoneNumberScreen(
                              //   firebaseKey: '${widget.user.id}',
                              // ),
                              const DoYouHaveUniqueKey(),
                              transition: Transition.rightToLeft,
                              duration: const Duration(milliseconds: 500),
                            );
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
                            Get.offAll(
                              DoYouHaveUniqueKey(
                                faceFeatures: widget.faceFeatures,
                                image: widget.dispImg,
                                firebaseKey: AppController.firebaseKey,
                              ),
                              transition: Transition.rightToLeft,
                              duration: const Duration(milliseconds: 500),
                            );
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
