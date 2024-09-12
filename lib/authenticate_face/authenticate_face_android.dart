import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_face_api/face_api.dart' as regula;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:secure_access/common/utils/custom_snackbar.dart';
import 'package:secure_access/common/utils/extract_face_feature.dart';
import 'package:secure_access/common/utils/screen_size_util.dart';
import 'package:secure_access/common/views/camera_view.dart';
import 'package:secure_access/common/views/custom_button.dart';
import 'package:secure_access/controllers/app_controller.dart';
import 'package:secure_access/model_face/user_model.dart';
import 'package:secure_access/screens/do_you_hv_unique_key%20copy.dart';
import 'package:secure_access/screens/identified_image.dart';

class AuthenticateFaceViewAndroid extends StatefulWidget {
  const AuthenticateFaceViewAndroid({Key? key}) : super(key: key);

  @override
  State<AuthenticateFaceViewAndroid> createState() =>
      _AuthenticateFaceViewAndroidState();
}

class _AuthenticateFaceViewAndroidState
    extends State<AuthenticateFaceViewAndroid> {
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
  Map<String, String> userMap = {}; //this is for updatedOn SO COMMENT

  final TextEditingController _nameController = TextEditingController();
  String _similarity = "";
  bool _canAuthenticate = false;
  List<dynamic> users = [];
  bool userExists = false;
  UserModel? loggingUser;
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
                        Get.to(() => const AuthenticateFaceViewAndroid());
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
    // Decode the image from the bytes
    img.Image? decodedImage = img.decodeImage(imageToAuthenticate);

    if (decodedImage != null) {
      // Resize the image to 450x600
      img.Image resizedImage =
          img.copyResize(decodedImage, width: 150, height: 200);

      // Convert the resized image back to bytes
      Uint8List resizedImageBytes =
          Uint8List.fromList(img.encodeJpg(resizedImage));

      // Convert the resized image bytes to base64
      image2.bitmap = base64Encode(resizedImageBytes);
      _capturedDispImg = image2.bitmap;
      _capturedImage = image2.bitmap;
      image2.imageType = regula.ImageType.PRINTED;

      setState(() {
        _canAuthenticate = true;
      });
    } else {
      CustomSnackBar.errorSnackBar("Failed to decode image.");
    }
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

  // double euclideanDistance(Points p1, Points p2) {
  //   final sqr =
  //       math.sqrt(math.pow((p1.x! - p2.x!), 2) + math.pow((p1.y! - p2.y!), 2));
  //   return sqr;
  // }

  Future<void> _fetchUsersAndMatchFace() async {
    try {
      DateTime endDate = DateTime.now();
      int batchCount = 0;
      bool matchFound = false;

      while (!matchFound && batchCount < 5) {
        // Limit to 10 batches to prevent infinite loop
        DateTime startDate = endDate.subtract(const Duration(days: 2));

        final snap = await FirebaseFirestore.instance
            .collection("users")
            .where('updatedOn',
                isGreaterThanOrEqualTo: startDate.toIso8601String())
            .where('updatedOn', isLessThanOrEqualTo: endDate.toIso8601String())
            .get();

        if (snap.docs.isNotEmpty) {
          users.clear();
          log(snap.docs.length.toString(),
              name: "Total Registered Users in Batch $batchCount");

          const batchSize = 5;
          for (int i = 0; i < snap.docs.length; i += batchSize) {
            final batch = snap.docs.skip(i).take(batchSize);
            for (var doc in batch) {
              UserModel user = UserModel.fromJson(doc.data());
              // DateTime registeredOn = DateTime.parse(user.registeredOn
              //     .toString()); // Assuming UserModel has registeredOn field as String
              // if (registeredOn.isAfter(startDate) &&
              //     registeredOn.isBefore(endDate)) {
              // double similarity =
              //     compareFaces(_faceFeatures!, user.faceFeatures!);
              // if (similarity >= 0.8 && similarity <= 1.5) {

              users.add([user]);
              userMap[user.id.toString()] = doc
                  .id; // Store the document ID in the map using the user ID as the key
              // }
              // }
            }
          }

          log(users.length.toString(),
              name: "Filtered Users in Batch $batchCount");

          matchFound = await _matchFacesInParallel(users);
        } else {
          log("No users found in Batch $batchCount", name: "Fetch Users");
        }

        if (!matchFound) {
          endDate = startDate;
          batchCount++;
        }
      }

      if (!matchFound) {
        AppController.setFaceMatched(0);
        Get.offAll(() => DoYouHaveUniqueKey(
              image: _capturedImage,
              faceFeatures: _faceFeatures,
            ));
      }
    } catch (e) {
      log("Getting User Error: $e");
      setState(() => isMatching = false);
      CustomSnackBar.errorSnackBar("Something went wrong. Please try again.");
    }
  }

  Future<bool> _matchFacesInParallel(List<dynamic> users) async {
    int totalUsers = users.length;
    int batchSize = 5;
    int numBatches = (totalUsers / batchSize).ceil();
    List<Future<bool>> futures = [];

    for (int i = 0; i < numBatches; i++) {
      final batch = users.skip(i * batchSize).take(batchSize).toList();
      futures.add(_matchFaces(batch));
    }

    bool matchFound = false;

    for (var future in futures) {
      if (await future) {
        matchFound = true;
        break;
      }
    }

    return matchFound;
  }

  Future<bool> _matchFaces(List<dynamic> userBatch) async {
    for (List user in userBatch) {
      image1.bitmap = (user.first as UserModel).image;
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
// Retrieve the document ID from the map
        String? documentId =
            userMap[user.first.id ?? '']; //PART OF UPDATED ON FILED

        //
        String currentDate =
            DateTime.now().toIso8601String().split('T')[0]; // Get current date
        await FirebaseFirestore.instance
            .collection("users")
            .doc(documentId)
            .update({'updatedOn': currentDate}); // Update the `updatedOn` field
        // print(documentId);

        //

        AppController.setFaceMatched(1);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => IdentifiedImageScreen(
              user: user.first,
              dispImg: _capturedDispImg,
              faceFeatures: _faceFeatures,
            ),
          ),
        );
        return true;
      }
    }

    return false;
  }

  void initializeUtilContexts(BuildContext context) {
    ScreenSizeUtil.context = context;
    CustomSnackBar.context = context;
  }
}
