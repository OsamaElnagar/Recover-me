import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recover_me/presentation/widgets/animated_text.dart';
import 'package:recover_me/domain/bloc/recover/recover_cubit.dart';
import '../../components/components.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class AppSplashScreen extends StatefulWidget {
  const AppSplashScreen({Key? key, required this.stWidget}) : super(key: key);
  final Widget stWidget;

  @override
  State<AppSplashScreen> createState() => _AppSplashScreenState();
}

class _AppSplashScreenState extends State<AppSplashScreen> {
  RecoverState? recoverState;
  bool loadingDoctorData = false;

  void startSplash() {
    Timer(const Duration(seconds: 5), () {
      navigate2(context, widget.stWidget);
    });
  }
  final spinKit = SpinKitFadingCircle(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: index.isEven ? Colors.red : Colors.green,
        ),
      );
    },
  );
  @override
  void initState() {
    startSplash();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RecoverCubit, RecoverState>(
      listener: (context, state) {
        recoverState = state;
      },
      builder: (context, state) {
        return Material(
          color: Colors.white,
          child: SafeArea(
            child: Container(
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:  [
                  const AnimatedText(),
                  const SizedBox(height: 20),
                  spinKit,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
