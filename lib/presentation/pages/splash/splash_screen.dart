import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recover_me/presentation/widgets/animated_text.dart';
import 'package:recover_me/domain/bloc/recover/recover_cubit.dart';
import '../../../../data/styles/colors.dart';
import '../../components/components.dart';



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
    Timer(const Duration(seconds: 8), () {
      navigate2(context, widget.stWidget);
    });
  }

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
                children: [
                  const AnimatedText(),
                  const SizedBox(height: 20),
                  if (loadingDoctorData == true)
                    const CircularProgressIndicator(
                        color: RecoverColors.myColor),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
