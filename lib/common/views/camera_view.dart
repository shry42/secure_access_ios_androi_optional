import 'dart:async';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:secure_access/common/utils/extensions/size_extension.dart';
import 'package:secure_access/common/utils/extract_face_feature.dart';
import 'package:secure_access/constants/theme.dart';
import 'package:secure_access/model_face/user_model.dart';

class CameraView extends StatefulWidget {
  const CameraView(
      {Key? key, required this.onImage, required this.onInputImage})
      : super(key: key);

  final Function(Uint8List image) onImage;
  final Function(InputImage inputImage) onInputImage;

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  CameraController? _cameraController;
  late Future<void> _initializeControllerFuture;
  bool _isCameraInitialized = false;
  int _countdown = 3;
  Timer? _timer;
  Uint8List? _capturedImage;
  bool _isImageCaptured = false;
   final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableLandmarks: true,
      performanceMode: FaceDetectorMode.accurate,
    ),
  );
  FaceFeatures? _faceFeatures;

  @override
  void initState() {
    super.initState();
    // _requestPermissionsAndInitializeCamera();
    _initializeCamera();
  }

  Future<void> _requestPermissionsAndInitializeCamera() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      _initializeCamera();
    } else {
      // Handle the case where the user denied the permission
      print('Camera permission denied');
    }
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
    );

    _cameraController = CameraController(
      camera,
      ResolutionPreset.high,
    );

    _initializeControllerFuture = _cameraController!.initialize();
    await _initializeControllerFuture;

    setState(() {
      _isCameraInitialized = true;
    });

    _startImageCaptureTimer();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isCameraInitialized
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     Icon(
              //       Icons.camera_alt_outlined,
              //       color: primaryWhite,
              //       size: 0.038.sh,
              //     ),
              //   ],
              // ),
              // SizedBox(height: 0.025.sh),
              Stack(
                alignment: Alignment.center,
                children: [
                  _isImageCaptured && _capturedImage != null
                      ? Image.memory(
                          _capturedImage!,
                          width: 0.8.sh, // Adjust the width as needed
                          height: 0.6.sh, // Adjust the height as needed
                          fit: BoxFit.cover,
                        )
                      : SizedBox(
                          width: 0.8.sh, // Adjust the width as needed
                          height: 0.6.sh, // Adjust the height as needed
                          child: CameraPreview(_cameraController!),
                        ),
                  if (_countdown > 0)
                    Text(
                      '$_countdown',
                      style: const TextStyle(
                        fontSize: 48,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ],
          )
        : const Center(
            child: CircularProgressIndicator(
            color: Colors.lightGreenAccent,
          ));
  }

  Future<void> _startImageCaptureTimer() async {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 1) {
          _countdown--;
        } else {
          _countdown = 0;
          _timer?.cancel();
          _captureImage();
        }
      });
    });
  }

  Future<void> _captureImage() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      try {
        final image = await _cameraController!.takePicture();
        final imageBytes = await image.readAsBytes();
        widget.onImage(imageBytes);

        final inputImage = InputImage.fromFilePath(image.path);
        widget.onInputImage(inputImage);

        setState(() {
          _capturedImage = imageBytes;
          _isImageCaptured = true;
        });
      } catch (e) {
        print('Error capturing image: $e');
      }
    }

    // Future<void> _processImage(InputImage inputImage) async {
    
    // await extractFaceFeatures(inputImage, _faceDetector);
     
    // }
   

  }
}
