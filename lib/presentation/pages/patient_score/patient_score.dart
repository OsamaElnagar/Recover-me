import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recover_me/presentation/components/components.dart';
import 'package:recover_me/presentation/pages/home/doctor/doctor_home_screen.dart';
import 'package:recover_me/presentation/pages/points_line_charts.dart';
import 'package:recover_me/data/models/patient_login_model.dart';
import 'package:recover_me/data/styles/paddings.dart';
import 'package:recover_me/data/styles/texts.dart';
import 'package:recover_me/domain/bloc/recover/recover_cubit.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../data/models/score_model.dart';
import '../../../../data/styles/colors.dart';
import 'package:recover_me/presentation/manager/dateTime_manager.dart'
    as date_util;
import 'package:flutter_svg/flutter_svg.dart';

class PatientScore extends StatefulWidget {
  const PatientScore({Key? key, required this.patientLoginModel})
      : super(key: key);

  final PatientLoginModel patientLoginModel;

  @override
  State<PatientScore> createState() => _PatientScoreState();
}

class _PatientScoreState extends State<PatientScore> {
  final TextEditingController _countryCodeController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  late ScrollController scrollController;
  late ScrollController horizontalScrollController;
  List<DateTime> currentMonthList = List.empty();
  DateTime currentDateTime = DateTime.now();
  List<String> todos = <String>[];
  TextEditingController controller = TextEditingController();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final scrollKey = GlobalKey();
  final double _dayItemWidth = 60.0;
  int taskIndex = 0;

  @override
  void initState() {
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
                    child: SizedBox(width: 40, child: SvgPicture.asset('assets/images/whatsapp.svg')),
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
                child: Column(
                  children: [
                    todayView(),
                    const SizedBox(height: 20),
                    horizontalCapsuleListView(),
                    const SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 400,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: RecoverColors.myColor,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: LineChartsWidget(points: scores),
                    ),
                  ],
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
