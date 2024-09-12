import 'dart:convert';
import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:secure_access/model_face/user_model.dart';
import 'package:secure_access/screens/thankyou_screen.dart';
import 'package:secure_access/utils/toast_notify.dart';
// import 'package:secure_access/utils/toast_notify.dart';

class CarryingAssetsScreen extends StatefulWidget {
  const CarryingAssetsScreen(
      {super.key,
      this.countryCode,
      this.fullName,
      this.email,
      this.purpose,
      this.mobNo,
      this.meetingFor,
      this.firebaseKey,
      this.image,
      this.faceFeatures});

  final String? countryCode, fullName, email, purpose, mobNo, firebaseKey;
  final int? meetingFor;
  final String? image;
  final FaceFeatures? faceFeatures;

  @override
  State<CarryingAssetsScreen> createState() => _CarryingAssetsScreenState();
}

class _CarryingAssetsScreenState extends State<CarryingAssetsScreen> {
  final TextEditingController toolNameController = TextEditingController();
  final TextEditingController makeController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController remarkController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isYes = false;
  bool isButtonGreen = false; // Track if the "Next" button should be green

  // late String currentTime;
  // late String currentDate;
  late String selectedCountryCode;

  final String? toolName = '';
  final String? make = '';
  final String? quantity = '';
  final String? remark = '';
  int? hasTool = 0;

  XFile? selectedImage;
  bool displayImage = false;
  String? base64ImageTool;
  Uint8List? bytes;
  String? userId;
  String? currentTime;
  String? currentDate;
  @override
  void initState() {
    super.initState();

    String base64String =
        widget.image.toString(); // Replace with your base64 string
    bytes = base64Decode(base64String);
    // Get the current date
    DateTime now = DateTime.now();
    currentDate =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    // Get the current time in 24-hour format
    currentTime =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    super.initState();
  }

  void checkValidation() {
    setState(() {
      isButtonGreen = _formKey.currentState?.validate() == true &&
          selectedImage !=
              null; // Check if all fields are valid and image is selected
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(currentDate);
    // print(currentTime);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                    )),
                const SizedBox(
                  width: 650,
                ),
                if (isYes == true)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isButtonGreen
                          ? const Color.fromARGB(255, 96, 201, 67)
                          : const Color.fromARGB(2, 192, 198,
                              199), // Change button color based on validation

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (selectedImage == null) {
                          toast('please take a photo of the tool');
                        } else {
                          Get.to(
                            ThankyouScreen(
                              countryCode: widget.countryCode,
                              fullName: widget.fullName,
                              email: widget.email,
                              mobNo: widget.mobNo,
                              purpose: widget.purpose,
                              meetingFor: widget.meetingFor,
                              hasTool: hasTool,
                              toolName: toolNameController.text,
                              make: makeController.text,
                              remark: remarkController.text,
                              firebaseKey: widget.firebaseKey,
                              quantity: int.parse(quantityController.text),
                              base64ToolImage: base64ImageTool,
                              faceFeatures: widget.faceFeatures,
                              image: widget.image,
                            ),
                          );
                        }
                      } else {
                        toast('please fill all required fileds');
                      }
                    },
                    child: const Text(
                      'Next',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Are you carrying anything like a laptop/tablet etc?',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              // const SizedBox(height: 25),

              Padding(
                padding: const EdgeInsets.all(40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        minimumSize: Size(150, 80),
                      ),
                      onPressed: () {
                        setState(() {
                          hasTool = 1;
                          isYes = true;
                        });
                      },
                      child: const Text(
                        'Yes',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                    const SizedBox(width: 50),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          minimumSize: Size(150, 80)),
                      onPressed: () {
                        setState(() {
                          isYes = false;
                        });
                        Get.to(
                          ThankyouScreen(
                            countryCode: widget.countryCode,
                            fullName: widget.fullName,
                            email: widget.email,
                            mobNo: widget.mobNo,
                            firebaseKey: widget.firebaseKey,
                            purpose: widget.purpose,
                            meetingFor: widget.meetingFor,
                            hasTool: 0,
                            faceFeatures: widget.faceFeatures,
                            // toolName: toolNameController.text,
                            // make: makeController.text,
                            // remark: remarkController.text,
                            // quantity: int.parse(quantityController.text),
                            // base64ToolImage: base64ImageTool,
                            image: widget.image,
                          ),
                        );
                      },
                      child: const Text(
                        'No',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),

              if (isYes == true)
                SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 4),
                          child: TextFormField(
                            // controller: emailController,
                            controller: toolNameController,
                            // initialValue: widget.firstName,
                            onChanged: (value) {
                              checkValidation(); // Check validation on change
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              labelText: '    Tool name',
                              // hintText: 'username',
                            ),

                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter tool name';
                              }
                              if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                                return 'Tool name can only contain alphabets and spaces';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 4),
                          child: TextFormField(
                            // controller: emailController,
                            controller: makeController,
                            // initialValue: widget.firstName,
                            onChanged: (value) {
                              checkValidation(); // Check validation on change
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              labelText: '    Make',
                              // hintText: 'username',
                            ),

                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter make name';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 4),
                          child: TextFormField(
                            keyboardType: TextInputType.number,

                            // controller: emailController,
                            controller: quantityController,
                            // initialValue: widget.firstName,
                            onChanged: (value) {
                              checkValidation(); // Check validation on change
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              labelText: '    Quantity',
                              // hintText: 'username',
                            ),

                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter quantity';
                              }
                              if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                                return 'Quantity can only contain numbers';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 4),
                          child: TextFormField(
                            // controller: emailController,
                            controller: remarkController,
                            // initialValue: widget.firstName,
                            onChanged: (value) {
                              checkValidation(); // Check validation on change
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              labelText: '    Remark',
                              // hintText: 'username',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter remark';
                              }
                              if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                                return 'Remark can only contain alphabets and spaces';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 4),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                minimumSize: Size(120, 60)),
                            onPressed: () async {
                              // final PermissionStatus permission =
                              //     await Permission.camera.status;

                              // if (permission.isGranted) {
                              final ImagePicker _picker = ImagePicker();
                              selectedImage = (await _picker.pickImage(
                                  source: ImageSource.camera,
                                  preferredCameraDevice: CameraDevice.front,
                                  imageQuality: 10))!;

                              if (selectedImage != null) {
                                // Convert the selected image to a base64 string
                                List<int> imageBytes =
                                    File(selectedImage!.path).readAsBytesSync();
                                base64ImageTool = base64Encode(imageBytes);

                                // Handle the selected image here
                                displayImage = true;
                                setState(() {
                                  checkValidation(); // Check validation after image is taken
                                });
                              }
                            },
                            child: const Text(
                              'Take photo of asset',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        if (displayImage == true)
                          Container(
                            height: 200,
                            width: 200,
                            child: Image.file(File(selectedImage!.path)),
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
