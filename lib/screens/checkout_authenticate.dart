import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_face_api/face_api.dart' as regula;
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:image/image.dart' as imglib;
import 'package:secure_access/common/utils/custom_snackbar.dart';
import 'package:secure_access/common/utils/extract_face_feature.dart';
import 'package:secure_access/common/views/custom_button.dart';
import 'package:secure_access/controllers/app_controller.dart';
import 'package:secure_access/model_face/user_model.dart';
import 'package:secure_access/screens/first_tab_screen%20copy%202.dart';
import 'package:secure_access/screens/identified_checkout_screen.dart';
import 'package:secure_access/utils/toast_notify.dart';

class AuthenticateCheckoutView extends StatefulWidget {
  const AuthenticateCheckoutView({Key? key}) : super(key: key);

  @override
  State<AuthenticateCheckoutView> createState() =>
      _AuthenticateCheckoutViewState();
}

class _AuthenticateCheckoutViewState extends State<AuthenticateCheckoutView> {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableLandmarks: true,
      performanceMode: FaceDetectorMode.accurate,
    ),
  );
  FaceFeatures? _faceFeatures;
  var image1 = regula.MatchFacesImage();
  var image2 = regula.MatchFacesImage();
  dynamic? _capturedImage;
  dynamic? _capturedDispImg;

  final ImagePicker _imagePicker = ImagePicker();

  final TextEditingController _nameController = TextEditingController();
  String _similarity = "";
  bool _canAuthenticate = false;
  List<UserModel> users = [];
  bool userExists = false;
  UserModel? loggingUser;
  bool isMatching = false;
  bool matchFound = false;
  int trialNumber = 4;

  void restartCamera() {
    setState(() {
      _faceFeatures = null;
      isMatching = false;
    });
  }

  Future<void> getImage(ImageSource source) async {
    setState(() {
      _capturedImage = null;
      _capturedDispImg = null;
    });
    final pickedFile = await _imagePicker.pickImage(
        source: source, preferredCameraDevice: CameraDevice.front);
    if (pickedFile != null) {
      setState(() {
        _capturedImage = pickedFile;
      });
      _processFile(pickedFile.path);
    }
  }

  @override
  void dispose() {
    _faceDetector.close();
    super.dispose();
  }

  @override
  void initState() {
    getImage(ImageSource.camera);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: [],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                if (_capturedImage == null)
                  GestureDetector(
                    onTap: () => _getImage(ImageSource.camera),
                    child: const Center(
                      child: Icon(
                        Icons.camera_alt,
                        size: 100,
                        color: Colors.grey,
                      ),
                    ),
                  )
                else
                  Image.file(File(_capturedImage!.path)),
                if (_canAuthenticate && _faceFeatures == null)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: CustomButton(
                      text: 'Please Take proper Photo',
                      onTap: () {
                        _canAuthenticate = false;
                        Get.to(() => const AuthenticateCheckoutView());
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

  Future<void> _getImage(ImageSource source) async {
    setState(() {
      _capturedImage = null;
      _capturedDispImg = null;
    });
    final pickedFile = await _imagePicker.pickImage(
      source: source,
      preferredCameraDevice: CameraDevice.front,
      imageQuality: 40,
    );
    if (pickedFile != null) {
      setState(() {
        _capturedImage = pickedFile;
      });
      _processFile(pickedFile.path);
    }
  }

  Future<void> _processFile(String path) async {
    final imageBytes = await File(path).readAsBytes();

    // Compress and resize imageBytes
    Uint8List compressedImage = await FlutterImageCompress.compressWithList(
      quality: 35,
      imageBytes,
      minHeight: 150,
      minWidth: 200,
    );

    // Convert compressed image to base64
    String base64Image = base64Encode(compressedImage);
    image2.bitmap = base64Image;
    _capturedDispImg = base64Image;

    setState(() {
      _canAuthenticate = true;
    });

    final inputImage = InputImage.fromFilePath(path);
    setState(() => isMatching = true);
    _faceFeatures = await extractFaceFeatures(inputImage, _faceDetector);
    setState(() => isMatching = false);
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
      // Get the current date and the date two days ago
      DateTime currentDate = DateTime.now();
      DateTime twoDaysAgo = currentDate.subtract(const Duration(days: 2));

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

  Future<void> _matchFacesInParallel(List<UserModel> users) async {
    int totalUsers = users.length;
    int batchSize = 5;
    int numBatches = (totalUsers / batchSize).ceil();
    List<Future<bool>> futures = [];

    for (int i = 0; i < numBatches; i++) {
      final batch = users.skip(i * batchSize).take(batchSize).toList();
      futures.add(_matchFaces(batch));
    }

    for (var future in futures) {
      if (await future) {
        return;
      }
    }

    if (!matchFound) {
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
      toast('Couldn\'t match Face, try again!');
      Get.offAll(() => const FirstTabScreenTablet());
    }
  }

  Future<bool> _matchFaces(List<UserModel> userBatch) async {
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

      if (similarity > 75) {
        matchFound = true;
        Get.offAll(
          () => IdentifiedCheckoutScreen(
            user: user,
            dispImg: _capturedDispImg,
          ),
        );
        return true;
      }
    }
    return false;
  }
}
