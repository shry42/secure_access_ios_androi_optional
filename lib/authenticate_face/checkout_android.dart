import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;
// import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_face_api/face_api.dart' as regula;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:secure_access/common/utils/custom_snackbar.dart';
import 'package:secure_access/common/utils/extract_face_feature.dart';
import 'package:secure_access/common/utils/screen_size_util.dart';
import 'package:secure_access/common/views/camera_view.dart';
import 'package:secure_access/common/views/custom_button.dart';
// import 'package:secure_access/controllers/app_controller.dart';
import 'package:secure_access/model_face/user_model.dart';
import 'package:secure_access/screens/first_tab_screen%20copy%202.dart';

import 'package:secure_access/screens/identified_checkout_screen.dart';
import 'package:secure_access/utils/toast_notify.dart';

class Checkout_android extends StatefulWidget {
  const Checkout_android({Key? key}) : super(key: key);

  @override
  State<Checkout_android> createState() => _Checkout_androidState();
}

class _Checkout_androidState extends State<Checkout_android> {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableLandmarks: true,
      performanceMode: FaceDetectorMode.accurate,
    ),
  );
  FaceFeatures? _faceFeatures;
  var image1 = regula.MatchFacesImage();
  var image2 = regula.MatchFacesImage();
  dynamic _capturedImage;
  dynamic _capturedDispImg;

  bool _canAuthenticate = false;
  List<dynamic> users = [];
  bool isMatching = false;
  int trialNumber = 4;

  void restartCamera() {
    setState(() {
      _faceFeatures = null;
      isMatching = false;
    });
  }

  @override
  void dispose() {
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initializeUtilContexts(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                CameraView(
                  onImage: (image) {
                    _setImage(image);
                  },
                  onInputImage: (inputImage) async {
                    setState(() => isMatching = true);
                    _faceFeatures =
                        await extractFaceFeatures(inputImage, _faceDetector);
                    setState(() => isMatching = false);
                  },
                ),
                if (_canAuthenticate && _faceFeatures == null)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: CustomButton(
                      text: 'Please Take proper Photo',
                      onTap: () {
                        _canAuthenticate = false;
                        Get.to(() => const Checkout_android());
                      },
                    ),
                  ),
                if (_canAuthenticate && _faceFeatures != null)
                  FutureBuilder<void>(
                    future: _fetchUsersAndMatchFace(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: LoadingAnimationWidget.hexagonDots(
                            color: Colors.lightGreen,
                            size: 120,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future _setImage(Uint8List imageToAuthenticate) async {
    image2.bitmap = base64Encode(imageToAuthenticate);
    _capturedDispImg = image2.bitmap;
    _capturedImage = image2.bitmap;
    image2.imageType = regula.ImageType.PRINTED;

    setState(() {
      _canAuthenticate = true;
    });
  }

  // double compareFaces(FaceFeatures face1, FaceFeatures face2) {
  //   double distEar1 = euclideanDistance(face1.rightEar!, face1.leftEar!);
  //   double distEar2 = euclideanDistance(face2.rightEar!, face2.leftEar!);

  //   double ratioEar = distEar1 / distEar2;

  //   double distEye1 = euclideanDistance(face1.rightEye!, face1.leftEye!);
  //   double distEye2 = euclideanDistance(face2.rightEye!, face2.leftEye!);

  //   double ratioEye = distEye1 / distEye2;

  //   double distCheek1 = euclideanDistance(face1.rightCheek!, face1.leftCheek!);
  //   double distCheek2 = euclideanDistance(face2.rightCheek!, face2.leftCheek!);

  //   double ratioCheek = distCheek1 / distCheek2;

  //   double distMouth1 = euclideanDistance(face1.rightMouth!, face1.leftMouth!);
  //   double distMouth2 = euclideanDistance(face2.rightMouth!, face2.leftMouth!);

  //   double ratioMouth = distMouth1 / distMouth2;

  //   double distNoseToMouth1 =
  //       euclideanDistance(face1.noseBase!, face1.bottomMouth!);
  //   double distNoseToMouth2 =
  //       euclideanDistance(face2.noseBase!, face2.bottomMouth!);

  //   double ratioNoseToMouth = distNoseToMouth1 / distNoseToMouth2;

  //   double ratio =
  //       (ratioEye + ratioEar + ratioCheek + ratioMouth + ratioNoseToMouth) / 5;
  //   log(ratio.toString(), name: "Ratio");

  //   return ratio;
  // }

  double euclideanDistance(Points p1, Points p2) {
    final sqr =
        math.sqrt(math.pow((p1.x! - p2.x!), 2) + math.pow((p1.y! - p2.y!), 2));
    return sqr;
  }

  Future<void> _fetchUsersAndMatchFace() async {
    try {
      // Get the current date and the date two days ago
      DateTime currentDate = DateTime.now();
      DateTime twoDaysAgo = currentDate.subtract(const Duration(days: 1));

      // Format the dates to match the 'updatedOn' field format (e.g., "yyyy-MM-dd")
      String currentDateString = currentDate.toIso8601String().split('T')[0];
      String twoDaysAgoString = twoDaysAgo.toIso8601String().split('T')[0];

      // Query Firestore to get users whose 'updatedOn' field is within the last two days
      final snap = await FirebaseFirestore.instance
          .collection("users")
          .where('updatedOn', isGreaterThanOrEqualTo: twoDaysAgoString)
          .where('updatedOn', isLessThanOrEqualTo: currentDateString)
          .get();

      if (snap.docs.isNotEmpty) {
        users.clear();
        log(snap.docs.length.toString(), name: "Total Registered Users");

        for (var doc in snap.docs) {
          UserModel user = UserModel.fromJson(doc.data());

          users.add(user);
        }

        log(users.length.toString(), name: "Filtered Users");

        await _matchFacesInParallel(users);
      } else {
        toast('Couldn\'t match Face, try again!');
        Get.offAll(() => const FirstTabScreenTablet());
      }
    } catch (e) {
      log("Getting User Error: $e");
      setState(() => isMatching = false);
      CustomSnackBar.errorSnackBar("Something went wrong. Please try again.");
    }
  }

  Future<void> _matchFacesInParallel(List<dynamic> users) async {
    int totalUsers = users.length;
    int batchSize = 5;
    int numBatches = (totalUsers / batchSize).ceil();
    List<Future<void>> futures = [];

    for (int i = 0; i < numBatches; i++) {
      final batch = users.skip(i * batchSize).take(batchSize).toList();
      futures.add(_matchFaces(batch));
    }

    await Future.wait(futures);
  }

  Future<void> _matchFaces(List<dynamic> userBatch) async {
    List<UserModel> matchingUsers = [];

    for (UserModel user in userBatch) {
      image1.bitmap = user.image;
      image1.imageType = regula.ImageType.PRINTED;

      var request = regula.MatchFacesRequest();
      request.images = [image1, image2];
      dynamic value = await regula.FaceSDK.matchFaces(jsonEncode(request));

      var response = regula.MatchFacesResponse.fromJson(json.decode(value));
      dynamic str = await regula.FaceSDK.matchFacesSimilarityThresholdSplit(
          jsonEncode(response!.results), 0.75);

      var split =
          regula.MatchFacesSimilarityThresholdSplit.fromJson(json.decode(str));

      double similarity = split!.matchedFaces.isNotEmpty
          ? (split.matchedFaces[0]!.similarity! * 100)
          : 0;

      if (similarity > 90.00) {
        matchingUsers.add(user);
        break;
      }
    }

    if (matchingUsers.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => IdentifiedCheckoutScreen(
            user: matchingUsers.first,
            dispImg: _capturedDispImg,
          ),
        ),
      );
    } else {
      if (trialNumber == 3 || trialNumber == 4) {
        toast('Couldn\'t match Face');
        Get.offAll(() => const FirstTabScreenTablet());
      }
    }
  }

  void initializeUtilContexts(BuildContext context) {
    ScreenSizeUtil.context = context;
    CustomSnackBar.context = context;
  }
}
