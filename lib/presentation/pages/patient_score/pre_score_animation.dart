import 'dart:async';
import 'package:flutter/material.dart';
import 'package:recover_me/data/models/patient_login_model.dart';
import 'package:recover_me/presentation/pages/patient_score/patient_score.dart';
import 'package:rive/rive.dart' as rive;
import '../../components/components.dart';

class PreScoreAnimation extends StatefulWidget {
  PatientLoginModel patientLoginModel;

  PreScoreAnimation({super.key, required this.patientLoginModel});

  @override
  State<PreScoreAnimation> createState() => _PreScoreAnimationState();
}

class _PreScoreAnimationState extends State<PreScoreAnimation> {
  void startScoreSplash() {
    Timer(const Duration(seconds: 5), () {
      navigate2(
          context, PatientScore(patientLoginModel: widget.patientLoginModel));
    });
  }

  @override
  void initState() {
    startScoreSplash();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black,
              Color(0xff08090F),
              Color(0xff111521),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: const Center(
          child: rive.RiveAnimation.asset('assets/animations/water-chart.riv'),
        ),
      ),
    );
  }
}
