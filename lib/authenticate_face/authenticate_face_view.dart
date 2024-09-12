import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_face_api/face_api.dart' as regula;
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:secure_access/common/utils/custom_snackbar.dart';
import 'package:secure_access/common/utils/extract_face_feature.dart';
import 'package:secure_access/common/utils/screen_size_util.dart';
import 'package:secure_access/common/views/custom_button.dart';
import 'package:secure_access/controllers/app_controller.dart';
import 'package:secure_access/model_face/user_model.dart';
import 'package:secure_access/screens/do_you_hv_unique_key%20copy.dart';
import 'package:secure_access/screens/first_tab_screen%20copy%202.dart';
import 'package:secure_access/screens/identified_image.dart';
import 'package:image/image.dart' as imglib;

class AuthenticateFaceView extends StatefulWidget {
  const AuthenticateFaceView({Key? key}) : super(key: key);

  @override
  State<AuthenticateFaceView> createState() => _AuthenticateFaceViewState();
}

class _AuthenticateFaceViewState extends State<AuthenticateFaceView> {
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

  final ImagePicker _imagePicker = ImagePicker();

  final TextEditingController _nameController = TextEditingController();
  bool _canAuthenticate = false;
  List<dynamic> users = [];
  Map<String, String> userMap = {}; //this is for updatedOn SO COMMENT
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
        // imageQuality: 50,
        source: source,
        preferredCameraDevice: CameraDevice.front);
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
    initializeUtilContexts(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: GestureDetector(
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 40,
          ),
          onTap: () {
            Get.offAll(const FirstTabScreenTablet());
          },
        ),
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
                        Get.to(() => const AuthenticateFaceView());
                      },
                    ),
                  ),
                if (_canAuthenticate && _faceFeatures != null)
                  FutureBuilder<void>(
                    future: _fetchUsersAndMatchFaceWithTimeout(),
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
    final pickedFile = await _imagePicker.pickImage(source: source);
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
      quality: 55,
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

  Future<void> _fetchUsersAndMatchFaceWithTimeout() async {
    try {
      await Future.any([
        _fetchUsersAndMatchFace(),
        Future.delayed(const Duration(seconds: 10), () {
          if (!matchFound) {
            AppController.setFaceMatched(0);
            Get.offAll(() => DoYouHaveUniqueKey(
                  image: _capturedDispImg,
                  faceFeatures: _faceFeatures,
                ));
          }
        })
      ]);
    } catch (e) {
      log("Getting User Error: $e");
      setState(() => isMatching = false);
      CustomSnackBar.errorSnackBar("Something went wrong. Please try again.");
    }
  }

  Future<void> _fetchUsersAndMatchFace() async {
    try {
      DateTime endDate = DateTime.now();
      DateTime startDate = endDate.subtract(const Duration(days: 31));
      int batchCount = 0;
      print(startDate);
      print(endDate);

      while (!matchFound && batchCount < 10) {
        // final snap = await FirebaseFirestore.instance
        //     .collection("users")
        //     .where('registeredOn',
        //         isGreaterThanOrEqualTo: startDate.toIso8601String())
        //     .where('registeredOn',
        //         isLessThanOrEqualTo: endDate.toIso8601String())
        //     .get();

        //FOR UPDATED ONE
        ///////
        final snap = await FirebaseFirestore.instance
            .collection("users")
            .where('updatedOn',
                isGreaterThanOrEqualTo: startDate.toIso8601String())
            .where('updatedOn', isLessThanOrEqualTo: endDate.toIso8601String())
            .get();
        ///////

        if (snap.docs.isNotEmpty) {
          users.clear();
          log(snap.docs.length.toString(),
              name: "Total Registered Users in Batch $batchCount");

          const batchSize = 5;
          for (int i = 0; i < snap.docs.length; i += batchSize) {
            final batch = snap.docs.skip(i).take(batchSize);
            for (var doc in batch) {
              UserModel user = UserModel.fromJson(doc.data());
              //
              userMap[user.id.toString()] = doc
                  .id; // Store the document ID in the map using the user ID as the key
              //
              users.add([user]);
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
        matchFound = true;
        AppController.setFaceMatched(0);
        Get.offAll(() => DoYouHaveUniqueKey(
              image: _capturedDispImg,
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

// Retrieve the document ID from the map
      String? documentId =
          userMap[user.first.id ?? '']; //PART OF UPDATED ON FILED

      if (similarity > 90.00) {
        //
        String currentDate =
            DateTime.now().toIso8601String().split('T')[0]; // Get current date
        await FirebaseFirestore.instance
            .collection("users")
            .doc(documentId)
            .update({'updatedOn': currentDate}); // Update the `updatedOn` field
        // print(documentId);

        //

        matchFound = true;
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
