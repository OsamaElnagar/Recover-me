// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';


class AnimatedText extends StatefulWidget {
  const AnimatedText({super.key});

  @override
  _AnimatedTextState createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        return Column(
          children: [
            Opacity(
              opacity: _animation.value,
              child: Container(
                width: MediaQuery.of(context).size.width * .8,
                decoration: const BoxDecoration(),
                child: const Image(
                  image: AssetImage(
                    'assets/images/logo.png',
                  ),
                ),
              ),
            ),

            // Opacity(
            //   opacity: _animation.value,
            //   child: SizedBox(width: MediaQuery.of(context).size.width*.8,child: appLogo()),
            // ),
            // const SizedBox(height: 10),
            // Opacity(
            //   opacity: _animation.value,
            //   child: Text(
            //     'R e c o v e r  M e  i s  h e r e .'.toUpperCase(),
            //     style: const TextStyle(fontSize: 24.0),
            //   ),
            // ),
          ],
        );
      },
    );
  }
}
