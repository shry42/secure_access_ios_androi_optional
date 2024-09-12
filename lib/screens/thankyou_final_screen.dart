import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:secure_access/screens/first_tab_screen%20copy%202.dart';

class ThankyouFinalScreen extends StatefulWidget {
  const ThankyouFinalScreen({super.key});

  @override
  State<ThankyouFinalScreen> createState() => _ThankyouFinalScreenState();
}

class _ThankyouFinalScreenState extends State<ThankyouFinalScreen> {
  // declare confettiController;
  late ConfettiController _centerController;

  @override
  void initState() {
    // initialize confettiController
    _centerController =
        ConfettiController(duration: const Duration(seconds: 10));
    _centerController.play();
    Future.delayed(const Duration(seconds: 5), () {
      Get.offAll(const FirstTabScreenTablet());
    });
  }

  @override
  void dispose() {
    // dispose the controller
    _centerController.dispose();
    super.dispose();
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(2, 192, 198, 199),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () async {
                      Get.offAll(const FirstTabScreenTablet());
                    },
                    child: const Text(
                      'Close',
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
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Spacer(),
            Image.asset('assets/images/thankyou.png', height: 110),
            const Text(
              'Thank You!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold),
            ),
            // Text('We\'ve let ${AppController.whomToMeetName} know you are here')
            const Center(
              child: Text(
                'We\'ve successfully recorded your entry',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22),
              ),
            ),

//
            const SizedBox(height: 200),
            Stack(
              children: <Widget>[
                // align the confetti on the screenscreen
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ConfettiWidget(
                    shouldLoop: false,
                    confettiController: _centerController,
                    blastDirection: 3 * pi / 2, // blast direction from below
                    minBlastForce: 10,
                    maxBlastForce: 20,
                    emissionFrequency: 0,
                    // 10 paticles will pop-up at a time
                    numberOfParticles: 20,
                    // particles will pop-up
                    gravity: 0.05,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 80),
            // const Spacer(),
            const Text(
              '🎉',
              style: TextStyle(fontSize: 25),
            ),
            const Text(
              'Have a great day at',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text('Gegadyne Energy',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ]),
        ));
  }
}
