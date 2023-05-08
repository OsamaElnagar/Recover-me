import 'dart:async';

import 'package:flutter/material.dart';
import 'package:recover_me/data/styles/texts.dart';
import 'package:recover_me/data/styles/colors.dart';
import 'package:recover_me/data/styles/paddings.dart';

class ErrorOccurred extends StatefulWidget {
  const ErrorOccurred({Key? key}) : super(key: key);

  @override
  State<ErrorOccurred> createState() => _ErrorOccurredState();
}

class _ErrorOccurredState extends State<ErrorOccurred> {
  double _progressValue = 0.0;
  int _durationInSeconds = 600;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_durationInSeconds < 1) {
          timer.cancel();
        } else {
          _progressValue = (_durationInSeconds / 600);
          _durationInSeconds--;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RecoverPaddings.recoverAuthPadding(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: RecoverColors.myColor,size: 150,),
            const SizedBox(
              height: 30,
            ),
            Center(
              child: RecoverNormalTexts(
                norText:
                    'An error occurred!\n check your internet connection \n and start the app again \n or clear the cache data.',
                color: RecoverColors.myColor,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            //  CircularProgressIndicator(
            //   color: RecoverColors.myColor,
            //   //value: _progressValue,
            // ),
          ],
        ),
      ),
    );
  }
}
