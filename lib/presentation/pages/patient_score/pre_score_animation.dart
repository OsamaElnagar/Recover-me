// ignore_for_file: must_be_immutable

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:recover_me/data/models/patient_login_model.dart';
import 'package:recover_me/domain/bloc/recover/recover_cubit.dart';
import 'package:recover_me/presentation/pages/patient_score/patient_score.dart';
import 'package:rive/rive.dart' as rive;
import '../../../data/models/game_model.dart';
import '../../components/components.dart';

class PreScoreAnimation extends StatefulWidget {
  PatientLoginModel patientLoginModel;
  final GameModel gameModel;

  PreScoreAnimation(
      {super.key, required this.patientLoginModel, required this.gameModel});

  @override
  State<PreScoreAnimation> createState() => _PreScoreAnimationState();
}

class _PreScoreAnimationState extends State<PreScoreAnimation> {
  void startScoreSplash() {
    Timer(const Duration(seconds: 5), () {
      RecoverCubit.get(context).getScoresMap(
        gameName: widget.gameModel.name,
        pLModel: widget.patientLoginModel,
      );
      navigate2(
          context,
          PatientScore(
            patientLoginModel: widget.patientLoginModel,
            gameModel: widget.gameModel,
          ));
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
