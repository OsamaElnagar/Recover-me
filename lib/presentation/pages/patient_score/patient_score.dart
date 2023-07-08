// ignore_for_file: prefer_interpolation_to_compose_strings, deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recover_me/data/models/game_model.dart';
import 'package:recover_me/data/styles/form_fields.dart';
import 'package:recover_me/presentation/components/components.dart';
import 'package:recover_me/presentation/pages/home/doctor/doctor_home_screen.dart';
import 'package:recover_me/presentation/pages/points_line_charts.dart';
import 'package:recover_me/data/models/patient_login_model.dart';
import 'package:recover_me/data/styles/paddings.dart';
import 'package:recover_me/data/styles/texts.dart';
import 'package:recover_me/domain/bloc/recover/recover_cubit.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../data/styles/colors.dart';
import 'package:recover_me/presentation/manager/dateTime_manager.dart'
    as date_util;
import 'package:flutter_svg/flutter_svg.dart';
import '../../../data/data_sources/consts.dart';


class PatientScore extends StatefulWidget {
  const PatientScore(
      {Key? key, required this.patientLoginModel, required this.gameModel})
      : super(key: key);

  final PatientLoginModel patientLoginModel;
  final GameModel gameModel;

  @override
  State<PatientScore> createState() => _PatientScoreState();
}

class _PatientScoreState extends State<PatientScore> {
  final TextEditingController _countryCodeController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  late ScrollController scrollController;
  late ScrollController horizontalScrollController;
  TextEditingController scoreController = TextEditingController();
  TextEditingController sessionController = TextEditingController();
  List<DateTime> currentMonthList = List.empty();
  DateTime currentDateTime = DateTime.now();
  List<String> todos = <String>[];
  TextEditingController controller = TextEditingController();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  final scrollKey = GlobalKey();
  final double _dayItemWidth = 60.0;
  int taskIndex = 0;
  FocusNode scoreNode = FocusNode();
  FocusNode sessionNode = FocusNode();

  void startGraph() {
    Timer(const Duration(seconds: 2), () {
      if (RecoverCubit.get(context).mapData.isEmpty) {
        dialogMessage(
          context: context,
          title: 'Graph setup!',
          content: 'activate this graph (Recommended)',
          actions: [
            OutlinedButton(
              onPressed: () {
                RecoverCubit.get(context).updateScoresMap(
                  gameName: widget.gameModel.name,
                  pLModel: widget.patientLoginModel,
                  score: {'0': '0'},
                  context: context,
                );
                scoreController.clear();
                Navigator.pop(context);
                FocusScope.of(context).unfocus();
              },
              style: OutlinedButton.styleFrom(
                  backgroundColor: RecoverColors.recoverCelestialBlue),
              child: const Text(
                'Yes',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      }
    });
  }

  @override
  void initState() {
    startGraph();
    currentMonthList = date_util.DateUtils.daysInMonth(currentDateTime);
    currentMonthList.sort((a, b) => a.day.compareTo(b.day));
    currentMonthList = currentMonthList.toSet().toList();
    horizontalScrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // Scroll to the current day's position
      final currentDayPosition = (currentDateTime.day - 1) * _dayItemWidth;
      horizontalScrollController.jumpTo(currentDayPosition);
    });

    super.initState();
  }

  void scrollTasks() async {
    final context = scrollKey.currentContext!;
    await Scrollable.ensureVisible(context);
  }

  Widget horizontalCapsuleListView() {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        controller: horizontalScrollController,
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        itemCount: currentMonthList.length,
        itemBuilder: (BuildContext context, int index) {
          return capsuleView(index);
        },
        separatorBuilder: (context, index) {
          return const SizedBox(
            width: 0,
          );
        },
      ),
    );
  }

  Widget capsuleView(int index) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
        child: GestureDetector(
            onTap: () {
              setState(() {
                currentDateTime = currentMonthList[index];
              });
            },
            child: Container(
              width: _dayItemWidth,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: (currentMonthList[index].day == currentDateTime.day)
                    ? RecoverColors.myColor
                    : Colors.white,
                border: Border.all(
                  color: RecoverColors.myColor,
                  width: 2, //width of border
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      currentMonthList[index].day.toString(),
                      style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: (currentMonthList[index].day !=
                                  currentDateTime.day)
                              ? RecoverColors.myColor
                              : Colors.white),
                    ),
                    Text(
                      date_util.DateUtils
                          .weekdays[currentMonthList[index].weekday - 1],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color:
                            (currentMonthList[index].day != currentDateTime.day)
                                ? Colors.blue[200]
                                : Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            )));
  }

  Widget todayView() {
    return Text(
      '${date_util.DateUtils.weekdaysFullName[currentDateTime.weekday - 1]}, ${currentDateTime.day} ' +
          date_util.DateUtils.months[currentDateTime.month - 1],
      style: TextStyle(
          color: Colors.blue[200], fontWeight: FontWeight.w700, fontSize: 16),
    );
  }


  @override
  void dispose() {
    _countryCodeController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  bool isPureNumber(String input) {
    // Regular expression pattern to match only digits
    RegExp regex = RegExp(r'^\d+$');

    // Check if the input matches the pattern
    return regex.hasMatch(input);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RecoverCubit, RecoverState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = RecoverCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            leading: InkWell(
              onTap: () => navigate2(context, const DoctorHomeScreen()),
              child: const Icon(
                Icons.arrow_back,
              ),
            ),
            title: Row(
              children: [
                CircleAvatar(
                  backgroundImage:
                      NetworkImage(widget.patientLoginModel.profileImage),
                ),
                const SizedBox(width: 5),
                RecoverNormalTexts(
                  norText: widget.patientLoginModel.name,
                  color: RecoverColors.recoverWhite,
                  fs: 14.0,
                ),
                const Icon(
                  Icons.verified_rounded,
                  color: RecoverColors.recoverWhite,
                  size: 18.0,
                ),
              ],
            ),
            actions: [
              Center(
                child: InkWell(
                  onTap: () async {
                    //openWhatsAppChat(phoneNumber: '+201033275832');
                    await launch(
                        'https://wa.me/${widget.patientLoginModel.phone}');
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 14.0),
                    child: SizedBox(
                        width: 40,
                        child: SvgPicture.asset('assets/images/whatsapp.svg')),
                  ),
                ),
              ),
            ],
            backgroundColor: RecoverColors.myColor,
          ),
          body: SafeArea(
            child: RecoverPaddings.recoverAuthPadding(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: GestureDetector(
                  onTap: () => unFocusNodes([scoreNode, sessionNode]),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          RecoverNormalTexts(
                            norText: widget.gameModel.name,
                            color: RecoverColors.myColor,
                          ),
                          const Spacer(),
                          todayView(),
                        ],
                      ),
                      const SizedBox(height: 20),
                      horizontalCapsuleListView(),
                      const SizedBox(height: 20),
                      const LineChartsWidget(),
                      Form(
                        key: formKey,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12.0, bottom: 5),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            // height: 50,
                            child: Center(
                              child: Column(
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: RecoverTextFormField(
                                      focusNode: scoreNode,
                                      hintText: 'new score?',
                                      controller: scoreController,
                                      keyboardType: TextInputType.number,
                                      height: 50.0,
                                      textInputAction: TextInputAction.next,
                                      validator: (String? input) {
                                        if (!isPureNumber(input!)) {
                                          return 'Please enter a pure number.';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  recoverSpacer(height: 5.0),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: RecoverTextFormField(
                                      focusNode: sessionNode,
                                      hintText: 'session number?',
                                      controller: sessionController,
                                      keyboardType: TextInputType.number,
                                      height: 50.0,
                                      textInputAction: TextInputAction.send,
                                      validator: (String? input) {
                                        if (!isPureNumber(input!)) {
                                          return 'Please enter a pure number.';
                                        }
                                        return null;
                                      },
                                      onFieldSubmitted: (String value) {
                                       if (formKey.currentState!.validate()) {
                                         Map sessionScore = {
                                           sessionController.text:
                                           scoreController.text
                                         };
                                         dialogMessage(
                                           context: context,
                                           title: 'New score',
                                           content:
                                           'Put ${scoreController.text} as new score?',
                                           actions: [
                                             OutlinedButton(
                                               onPressed: () {
                                                 Navigator.pop(context);
                                               },
                                               style: OutlinedButton.styleFrom(
                                                   backgroundColor:
                                                   Colors.white),
                                               child: const Text('No'),
                                             ),
                                             OutlinedButton(
                                               onPressed: () async {
                                                 Future.wait(
                                                   [
                                                     cubit.updateScoresMap(
                                                       context: context,
                                                       gameName:
                                                       widget.gameModel.name,
                                                       pLModel: widget
                                                           .patientLoginModel,
                                                       score: sessionScore,
                                                     ),
                                                     cubit.getScoresMap(
                                                       gameName:
                                                       widget.gameModel.name,
                                                       pLModel: widget
                                                           .patientLoginModel,
                                                     ),
                                                   ],
                                                 );
                                                 if (cubit.isCritical) {
                                                   dialogMessage(
                                                       context: context,
                                                       title: urgentAlert,
                                                       content:
                                                       urgentAlertContent,
                                                       actions: []);
                                                 }
                                                 scoreController.clear();
                                                 sessionController.clear();
                                                 Navigator.pop(context);
                                                 FocusScope.of(context)
                                                     .unfocus();
                                               },
                                               style: OutlinedButton.styleFrom(
                                                   backgroundColor:
                                                   RecoverColors.myColor),
                                               child: const Text(
                                                 'Yes',
                                                 style: TextStyle(
                                                     color: Colors.white),
                                               ),
                                             ),
                                           ],
                                         );
                                       }
                                      },
                                    ),
                                  ),
                                  recoverSpacer(height: 5.0),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (state is RecoverUpdateScoresLoadingState)
                        const LinearProgressIndicator(
                          color: RecoverColors.myColor,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

//  Future openWhatsAppChat({required String phoneNumber}) async {
//    final whatsappUrl = "https://wa.me/$phoneNumber";
//    final whatsappUrl1 =
//        "whatsapp://send?phone=$phoneNumber&text=${Uri.encodeComponent('Hi')}";
//    if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
//      await launchUrl(Uri.parse(whatsappUrl));
//    } else {
//      throw 'Could not launch $whatsappUrl';
//    }
//  }
//
//  void launchee() {
//    var whatsappUrl =
//        "whatsapp://send?phone=${_countryCodeController.text + _phoneController.text}";
//
//    var whatsappUrlWithMessage =
//        "whatsapp://send?phone=${_countryCodeController.text + _phoneController.text}"
//        "&text=${Uri.encodeComponent(_messageController.text)}";
//  }
//
// // import 'package:url_launcher/url_launcher.dart';
//
//  void openWhatsApp({required String phone, required String message}) async {
//    String url = "whatsapp://send?phone=$phone&text=${Uri.encodeFull(message)}";
//    if (await canLaunch(url)) {
//      await launch(url);
//    } else {
//      throw 'Could not launch $url';
//    }
//  }
