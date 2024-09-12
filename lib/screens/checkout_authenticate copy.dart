// import 'dart:convert';
// import 'dart:developer';
// import 'dart:math' as math;
// import 'package:audioplayers/audioplayers.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_face_api/face_api.dart' as regula;
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:secure_access/common/utils/custom_snackbar.dart';
// import 'package:secure_access/common/utils/extract_face_feature.dart';
// import 'package:secure_access/common/utils/screen_size_util.dart';
// import 'package:secure_access/common/views/camera_view.dart';
// import 'package:secure_access/common/views/custom_button.dart';
// import 'package:secure_access/model_face/user_model.dart';
// import 'package:secure_access/screens/first_tab_screen%20copy%202.dart';
// import 'package:secure_access/screens/first_tab_screen.dart';
// import 'package:secure_access/screens/identified_checkout_screen.dart';
// import 'package:secure_access/screens/identified_image.dart';
// import 'package:secure_access/screens/provide_phone_number_screen.dart';
// import 'package:secure_access/utils/toast_notify.dart';

// class AuthenticateCheckoutView extends StatefulWidget {
//   const AuthenticateCheckoutView({Key? key}) : super(key: key);

//   @override
//   State<AuthenticateCheckoutView> createState() =>
//       _AuthenticateCheckoutViewState();
// }

// class _AuthenticateCheckoutViewState extends State<AuthenticateCheckoutView> {
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   final FaceDetector _faceDetector = FaceDetector(
//     options: FaceDetectorOptions(
//       enableLandmarks: true,
//       performanceMode: FaceDetectorMode.accurate,
//     ),
//   );
//   FaceFeatures? _faceFeatures;
//   var image1 = regula.MatchFacesImage();
//   var image2 = regula.MatchFacesImage();
//   dynamic _capturedImage;
//   dynamic _capturedDispImg;

//   bool _canAuthenticate = false;
//   List<dynamic> users = [];
//   bool userExists = false;
//   UserModel? loggingUser;
//   bool isMatching = false;
//   int trialNumber = 4;

//   void restartCamera() {
//     setState(() {
//       _faceFeatures = null;
//       isMatching = false;
//     });
//   }

//   @override
//   void dispose() {
//     _faceDetector.close();
//     _audioPlayer.dispose();
//     super.dispose();
//   }

//   get _playScanningAudio => _audioPlayer
//     ..setReleaseMode(ReleaseMode.loop)
//     ..play(AssetSource("scan_beep.wav"));

//   get _playFailedAudio => _audioPlayer
//     ..stop()
//     ..setReleaseMode(ReleaseMode.release)
//     ..play(AssetSource("failed.mp3"));

//   @override
//   Widget build(BuildContext context) {
//     initializeUtilContexts(context);
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       // appBar: AppBar(
//       //   centerTitle: true,
//       //   backgroundColor: appBarColor,
//       //   title: const Text("Authenticate Face"),
//       //   elevation: 0,
//       // ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Stack(
//               children: [
//                 CameraView(
//                   onImage: (image) {
//                     _setImage(image);
//                   },
//                   onInputImage: (inputImage) async {
//                     setState(() => isMatching = true);
//                     _faceFeatures =
//                         await extractFaceFeatures(inputImage, _faceDetector);
//                     setState(() => isMatching = false);
//                   },
//                 ),
//                 // if (isMatching)
//                 //   const Align(
//                 //     alignment: Alignment.center,
//                 //     child: AnimatedView(),
//                 //   ),
//                 //
//                 if (_canAuthenticate && _faceFeatures == null)
//                   Align(
//                     alignment: Alignment.bottomCenter,
//                     child: CustomButton(
//                       text: 'Please Take proper Photo',
//                       onTap: () {
//                         // setState(() {});
//                         _canAuthenticate = false;

//                         Get.to(() => const AuthenticateCheckoutView());
//                       },
//                     ),
//                   ),

//                 //

//                 if (_canAuthenticate && _faceFeatures != null)
//                   FutureBuilder<void>(
//                     future: _fetchUsersAndMatchFace(),
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return Center(
//                           child: LoadingAnimationWidget.hexagonDots(
//                             color: Colors.lightGreen,
//                             size: 120,
//                           ),
//                         );
//                       } else if (snapshot.hasError) {
//                         return Text('Error: ${snapshot.error}');
//                       } else {
//                         return const SizedBox.shrink();
//                       }
//                     },
//                   ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future _setImage(Uint8List imageToAuthenticate) async {
//     image2.bitmap = base64Encode(imageToAuthenticate);
//     _capturedDispImg = image2.bitmap;
//     _capturedImage = image2.bitmap;
//     image2.imageType = regula.ImageType.PRINTED;

//     setState(() {
//       _canAuthenticate = true;
//     });
//   }

//   double compareFaces(FaceFeatures face1, FaceFeatures face2) {
//     double distEar1 = euclideanDistance(face1.rightEar!, face1.leftEar!);
//     double distEar2 = euclideanDistance(face2.rightEar!, face2.leftEar!);

//     double ratioEar = distEar1 / distEar2;

//     double distEye1 = euclideanDistance(face1.rightEye!, face1.leftEye!);
//     double distEye2 = euclideanDistance(face2.rightEye!, face2.leftEye!);

//     double ratioEye = distEye1 / distEye2;

//     double distCheek1 = euclideanDistance(face1.rightCheek!, face1.leftCheek!);
//     double distCheek2 = euclideanDistance(face2.rightCheek!, face2.leftCheek!);

//     double ratioCheek = distCheek1 / distCheek2;

//     double distMouth1 = euclideanDistance(face1.rightMouth!, face1.leftMouth!);
//     double distMouth2 = euclideanDistance(face2.rightMouth!, face2.leftMouth!);

//     double ratioMouth = distMouth1 / distMouth2;

//     double distNoseToMouth1 =
//         euclideanDistance(face1.noseBase!, face1.bottomMouth!);
//     double distNoseToMouth2 =
//         euclideanDistance(face2.noseBase!, face2.bottomMouth!);

//     double ratioNoseToMouth = distNoseToMouth1 / distNoseToMouth2;

//     double ratio =
//         (ratioEye + ratioEar + ratioCheek + ratioMouth + ratioNoseToMouth) / 5;
//     log(ratio.toString(), name: "Ratio");

//     return ratio;
//   }

//   double euclideanDistance(Points p1, Points p2) {
//     final sqr =
//         math.sqrt(math.pow((p1.x! - p2.x!), 2) + math.pow((p1.y! - p2.y!), 2));
//     return sqr;
//   }

//   Future<void> _fetchUsersAndMatchFace() async {
//     try {
//       final snap = await FirebaseFirestore.instance.collection("users").get();
//       if (snap.docs.isNotEmpty) {
//         users.clear();
//         log(snap.docs.length.toString(), name: "Total Registered Users");
//         for (var doc in snap.docs) {
//           UserModel user = UserModel.fromJson(doc.data());
//           double similarity = compareFaces(_faceFeatures!, user.faceFeatures!);
//           if (similarity >= 0.8 && similarity <= 1.5) {
//             users.add([user, similarity]);
//           }
//         }
//         log(users.length.toString(), name: "Filtered Users");
//         // setState(() {
//         //   users.sort((a, b) => (((a.last as double) - 1).abs())
//         //       .compareTo(((b.last as double) - 1).abs()));
//         // });

//         await _matchFaces();
//       } else {
//         // _showFailureDialog(
//         //   title: "No Users Registered",
//         //   description:
//         //       "Make sure users are registered first before Authenticating.",
//         // );
//         // Get.offAll(EnterDetailsView(
//         //   image: _capturedImage,
//         //   faceFeatures: _faceFeatures,
//         // ));
//         toast('Couldn\'t match Face try again!');
//         Get.offAll(() => const FirstTabScreenTablet());
//       }
//     } catch (e) {
//       log("Getting User Error: $e");
//       setState(() => isMatching = false);
//       CustomSnackBar.errorSnackBar("Something went wrong. Please try again.");
//     }
//   }

//   Future<void> _matchFaces() async {
//     List<UserModel> matchingUsers = [];

//     for (List user in users) {
//       image1.bitmap = (user.first as UserModel).image;
//       image1.imageType = regula.ImageType.PRINTED;

//       var request = regula.MatchFacesRequest();
//       request.images = [image1, image2];
//       dynamic value = await regula.FaceSDK.matchFaces(jsonEncode(request));

//       var response = regula.MatchFacesResponse.fromJson(json.decode(value));
//       dynamic str = await regula.FaceSDK.matchFacesSimilarityThresholdSplit(
//           jsonEncode(response!.results), 0.75);

//       var split =
//           regula.MatchFacesSimilarityThresholdSplit.fromJson(json.decode(str));

//       double similarity = split!.matchedFaces.isNotEmpty
//           ? (split.matchedFaces[0]!.similarity! * 100)
//           : 0;

//       if (similarity > 90.00) {
//         matchingUsers.add(user.first);
//       }
//     }

//     // Update state based on matching results
//     if (matchingUsers.isNotEmpty) {
//       Navigator.of(context).push(
//         //For tab screen
//         MaterialPageRoute(
//           builder: (context) => IdentifiedCheckoutScreen(
//             user: matchingUsers.first,
//             dispImg: _capturedDispImg,
//           ),
//         ),
//       );
//     } else {
//       // Handle no match case
//       if (trialNumber == 3) {
//         toast('Couldn\'t match Face');
//         Get.offAll(() => const FirstTabScreenTablet());
//       } else if (trialNumber == 4) {
//         toast('Couldn\'t match Face');
//         Get.offAll(() => const FirstTabScreenTablet());
//       }
//     }
//   }

//   void initializeUtilContexts(BuildContext context) {
//     ScreenSizeUtil.context = context;
//     CustomSnackBar.context = context;
//   }
// }
