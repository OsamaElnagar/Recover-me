import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
class ImageColors extends StatefulWidget {
  const ImageColors({Key? key}) : super(key: key);

  @override
  State<ImageColors> createState() => _ImageColorsState();
}

class _ImageColorsState extends State<ImageColors> {

  PaletteGenerator? paletteGenerator;
  Color defaultColor = Colors.white;

  
  void generatePaletteColor()async {

  }
  
  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(

      backgroundColor: defaultColor,
    );
  }
}
