import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:recover_me/presentation/components/components.dart';
import 'package:recover_me/presentation/pages/auth/register/doctor_register_screen.dart';
import 'package:recover_me/presentation/pages/auth/register/patient_register_screen.dart';
import 'package:recover_me/data/data_sources/consts.dart';
import 'package:recover_me/data/styles/texts.dart';
import 'package:recover_me/domain/entities/cache_helper.dart';
import '../../widgets/glassy.dart';
import '../../widgets/my_background_designs.dart';

class UserType extends StatefulWidget {
  const UserType({Key? key}) : super(key: key);

  @override
  State<UserType> createState() => _UserTypeState();
}

class _UserTypeState extends State<UserType> {
  final types = [
    'assets/images/patient.jpg',
    'assets/images/doctor_avatar.jpg',
  ];
  PaletteGenerator? paletteGenerator;

  void getPaletteColor() async {
    paletteGenerator =
        await PaletteGenerator.fromImageProvider(AssetImage(types[0]));
    setState(() {});
  }

  @override
  void initState() {
    getPaletteColor();
    super.initState();
  }

  Color paletteColor() {
    return paletteGenerator != null
        ? paletteGenerator!.dominantColor != null
            ? paletteGenerator!.dominantColor!.color
            : Colors.white
        : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: typeBackground(
          asset: 'assets/images/type_background.jpg',
          context: context,
          child:  SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                // mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(height: 0),
                  glassyContainer(
                    child: RecoverHeadlines(
                      headline: 'Are you a professional or patient?',
                      //color: RecoverColors.myColor,
                    ),
                  ),
                  buildUserType(
                      onTap: () {
                        setState(() {
                          isPatient = true;
                        });
                        CacheHelper.saveData(
                            key: 'isPatient', value: isPatient);
                        navigateTo(context, const PatientRegisterScreen());
                      },
                      image: types[0],
                      //color: Colors.brown,
                      type: 'Patient'),
                  const SizedBox(height: 10),
                  buildUserType(
                      onTap: () {
                        setState(() {
                          isPatient = false;
                        });
                        CacheHelper.saveData(
                            key: 'isPatient', value: isPatient);
                        navigateTo(context, const DoctorRegisterScreen());
                      },
                      image: types[1],
                      //color: RecoverColors.myColor,
                      type: 'Professional'),
                ],
              ),
            ),
          ),
        ),
    );
  }

  Widget buildUserType({
    required String image,
    required String type,
    Color? color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 100,
            backgroundImage: AssetImage(image),
          ),
          const SizedBox(height: 10),
          glassyContainer(
            child: RecoverNormalTexts(
              norText: type,
              color: color,
            ),
          ),
        ],
      ),
    );
  }


}
