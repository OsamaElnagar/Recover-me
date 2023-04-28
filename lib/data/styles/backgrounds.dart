import 'package:flutter/cupertino.dart';


class Backgrounds {
  static Widget authBackground() {
    return const Image(
      image: AssetImage('assets/images/f.jpg'),
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
    );
  }
}
