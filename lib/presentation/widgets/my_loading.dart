import 'package:flutter/material.dart';
import 'package:recover_me/data/styles/colors.dart';

class MyLoading extends StatelessWidget {
  const MyLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          color: RecoverColors.myColor,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade700),
        ),
      ),
    );
  }
}