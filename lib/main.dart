import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recover_me/data/styles/colors.dart';
import 'package:recover_me/presentation/pages/home/user_type.dart';
import 'package:recover_me/presentation/pages/home/doctor/doctor_home_screen.dart';
import 'package:recover_me/presentation/pages/home/patient/patient_home_screen.dart';
import 'package:recover_me/presentation/pages/splash/splash_screen.dart';
import 'package:recover_me/domain/entities/blocObserver.dart';
import 'presentation/pages/onBoarding/on_boarding_screen.dart';
import 'data/data_sources/consts.dart';
import 'domain/bloc/recover/recover_cubit.dart';
import 'domain/entities/cache_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.init();
  Bloc.observer = MyBlocObserver();
  bool? lastPage = CacheHelper.getData('lastPage');
  uId = CacheHelper.getData('uid');
  isPatient = CacheHelper.getData('isPatient');
  final Widget stWidget;
  if (lastPage != null) {
    if (uId != null) {
      if (isPatient == true) {
        stWidget = const PatientHomeScreen();
      } else {
        stWidget = const DoctorHomeScreen();
      }
    } else {
      stWidget = const UserType();
    }
  } else {
    stWidget = const OnBoardingScreen();
  }
  runApp(MyApp(
    stWidget: stWidget,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.stWidget});

  final Widget stWidget;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: RecoverColors.myColor,
      ),
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            return RecoverCubit(RecoverInitial())
              ..getDoctorData()
              ..getPatientData()
              ..getPatients()
              ..getGames()
            ..getDoctors();
          },
        ),
        // BlocProvider(
        //   create: (context) {
        //     return UpdateProfileCubit()..getPatientModel();
        //   },
        // ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.blue,
        ),
        home: AppSplashScreen(
          stWidget: stWidget,
        ),
      ),
    );
  }
}
