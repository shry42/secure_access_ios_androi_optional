import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure_access/controllers/get_otp_controller.dart';
import 'package:secure_access/controllers/login_controller.dart'; // Import loginController
import 'package:secure_access/custom_painter/custom_painter_login.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final OTPController otpController = Get.put(OTPController());
  final loginController loginCtrl =
      Get.put(loginController()); // Instantiate loginController
  TextEditingController emailController = TextEditingController();
  TextEditingController otpControllerText = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned(
              right: 40,
              top: 290,
              width: 80,
              height: 150,
              child: FadeInUp(
                from: 120,
                duration: const Duration(seconds: 1),
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/playstore.png'),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 400,
                    child: CustomPaint(
                      painter: RPSCustomPainter(),
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            left: 30,
                            width: 80,
                            height: 200,
                            child: FadeInUp(
                              duration: const Duration(seconds: 1),
                              child: Container(
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image:
                                        AssetImage('assets/images/light-1.png'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 140,
                            width: 80,
                            height: 150,
                            child: FadeInUp(
                              duration: const Duration(milliseconds: 1200),
                              child: Container(
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image:
                                        AssetImage('assets/images/light-2.png'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 40,
                            top: 40,
                            width: 80,
                            height: 150,
                            child: FadeInUp(
                              duration: const Duration(milliseconds: 1300),
                              child: Container(
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image:
                                        AssetImage('assets/images/clock.png'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            child: FadeInUp(
                              duration: const Duration(milliseconds: 1600),
                              child: Container(
                                margin: const EdgeInsets.only(top: 50),
                                child: const Center(
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          FadeInUp(
                            duration: const Duration(milliseconds: 1800),
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: const Color.fromRGBO(188, 190, 230, 1),
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromRGBO(143, 148, 251, .2),
                                    blurRadius: 20.0,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller: emailController,
                                      onChanged: (value) {
                                        otpController.employeeId.value = value;
                                        loginCtrl.email.value = value;
                                      },
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Employee Id",
                                        hintStyle: TextStyle(
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter a valid Employee Id';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Obx(() {
                            if (otpController.loading.value) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.lightGreenAccent,
                                ),
                              );
                            } else if (otpController.isOtpSent.value) {
                              return FadeInUp(
                                duration: const Duration(milliseconds: 1800),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: const Color.fromRGBO(
                                              188, 190, 230, 1),
                                        ),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color.fromRGBO(
                                                143, 148, 251, .2),
                                            blurRadius: 20.0,
                                            offset: Offset(0, 10),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            padding: const EdgeInsets.all(8.0),
                                            child: TextFormField(
                                              controller: otpControllerText,
                                              onChanged: (value) {
                                                loginCtrl.otp.value = value;
                                              },
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: "Enter OTP",
                                                hintStyle: TextStyle(
                                                  color: Colors.grey[700],
                                                ),
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter the OTP';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Obx(() {
                                      if (otpController.isOtpSent.value) {
                                        return TextButton(
                                          onPressed: () {
                                            otpController.resendOtp();
                                            otpControllerText.clear();
                                          },
                                          child: const Text(
                                            "Resend OTP",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 127, 213, 130),
                                                decoration:
                                                    TextDecoration.underline,
                                                fontSize: 25),
                                          ),
                                        );
                                      } else {
                                        return Container();
                                      }
                                    }),
                                  ],
                                ),
                              );
                            } else {
                              return Container();
                            }
                          }),
                          const SizedBox(
                            height: 30,
                          ),
                          FadeInUp(
                            duration: const Duration(milliseconds: 1900),
                            child: Shimmer(
                              child: GestureDetector(
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    if (otpController.isOtpSent.value) {
                                      // If OTP is sent and button says 'Login', perform login
                                      loginCtrl.loginUser();
                                    } else {
                                      // Else, send OTP
                                      otpController.sendLoginOtp();
                                    }
                                  }
                                },
                                child: Obx(() => Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color.fromARGB(255, 117, 198, 25),
                                            Color.fromARGB(255, 165, 240, 79),
                                          ],
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          otpController.buttonText.value,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
