// ignore_for_file: must_be_immutable
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:recover_me/presentation/components/components.dart';
import 'package:recover_me/presentation/pages/error_occurred/error_occurred.dart';
import 'package:recover_me/presentation/pages/home/doctor/doctor_edit_profile.dart';
import 'package:recover_me/data/models/patient_login_model.dart';
import 'package:recover_me/data/styles/paddings.dart';
import 'package:recover_me/data/styles/texts.dart';
import 'package:recover_me/domain/bloc/recover/recover_cubit.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:recover_me/presentation/widgets/glassy.dart';
import 'package:recover_me/presentation/widgets/my_background_designs.dart';
import '../../../../../data/models/game_model.dart';
import '../../../../../data/styles/colors.dart';
import '../../patient_score/pre_score_animation.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({Key? key}) : super(key: key);

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  late Offset tapXY;
  RenderBox? overlay;
  double screenHeight = 0;
  double screenWidth = 0;
  bool startAnimation = false;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        startAnimation = true;
      });
    });
  }

  getData() async {
    setState(() {
      RecoverCubit.get(context).patients.clear();
    });
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      RecoverCubit.get(context).getDoctorData();
      RecoverCubit.get(context).getPatients();
    });
    refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    overlay = Overlay.of(context).context.findRenderObject() as RenderBox?;
    return BlocConsumer<RecoverCubit, RecoverState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = RecoverCubit.get(context);
        var dLModel = cubit.doctorLoginModel;
        return ConditionalBuilder(
          condition: dLModel != null,
          builder: (context) {
            return Scaffold(
              body: GestureDetector(

                child: typeBackground(
                  asset: 'assets/images/blue_gradient.jpg',
                  context: context,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: RecoverPaddings.recoverAuthPadding(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 15),
                          glassyContainer(
                            child: RecoverHeadlines(
                              headline: 'Recover sphere profile',
                              color: RecoverColors.recoverWhite,
                              fs: 20,
                            ),
                          ),
                          const SizedBox(height: 20),
                          InkWell(
                            onTap: () {
                              navigateTo(context, const DoctorEditProfile());
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: RecoverColors.myColor,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RecoverHeadlines(
                                        headline: 'Doctor:',
                                        color: RecoverColors.recoverWhite,
                                        fs: 20,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      RecoverNormalTexts(
                                        norText: dLModel!.name!,
                                        color: RecoverColors.recoverWhite,
                                        fs: 16.0,
                                        maxLines: 1,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      RecoverHints(
                                        hint: dLModel.prof ?? '',
                                        color: RecoverColors.recoverWhite,
                                        fs: 15.0,
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  CircleAvatar(
                                    radius:
                                        MediaQuery.of(context).size.width / 10,
                                    backgroundColor: Colors.white,
                                    backgroundImage: CachedNetworkImageProvider(
                                      dLModel.profileImage!,
                                    ),
                                    // child: CachedNetworkImage(
                                    //   imageUrl: dLModel.profileImage!,
                                    //   progressIndicatorBuilder:
                                    //       (context, url, progress) => Center(
                                    //     child: CircularProgressIndicator(
                                    //       value: progress.progress,
                                    //     ),
                                    //   ),
                                    //   fit: BoxFit.cover,
                                    // ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 50),
                          glassyContainer(
                            child: RecoverHeadlines(
                              headline: 'Recover sphere patients',
                              color: RecoverColors.recoverWhite,
                              fs: 20,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return AnimatedContainer(
                                width: screenWidth,
                                curve: Curves.easeInOut,
                                duration: Duration(
                                    milliseconds: 1000 + (index * 500)),
                                transform: Matrix4.translationValues(
                                    startAnimation ? 0 : screenWidth, 0, 0),
                                child: BuildPatientItem(
                                  patientLoginModel: cubit.patients[index],
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return recoverDivider(
                                height: 10.0,
                              );
                            },
                            itemCount: cubit.patients.length,
                          ),
                          if (cubit.patients.length == 0)
                            Center(
                              child: SizedBox(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.hourglass_empty,
                                      size: 150,
                                      color: RecoverColors.myColor,
                                    ),
                                    RecoverHints(
                                      hint:
                                          'It seems that no patients has registered yet!\n Try to invite some.',
                                      color: RecoverColors.myColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          const SizedBox(height: 0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          fallback: (context) {
            return const ErrorOccurred();
          },
        );
      },
    );
  }
}

class BuildPatientItem extends StatefulWidget {
  PatientLoginModel patientLoginModel;

  BuildPatientItem({
    super.key,
    required this.patientLoginModel,
  });

  @override
  State<BuildPatientItem> createState() => _BuildPatientItemState();
}

class _BuildPatientItemState extends State<BuildPatientItem> {
  RelativeRect get relRectSize =>
      RelativeRect.fromSize(tapXY & const Size(40, 40), overlay!.size);

  void getPosition(TapDownDetails detail) {
    tapXY = detail.globalPosition;
  }

  late Offset tapXY;

  RenderBox? overlay;

  @override
  Widget build(BuildContext context) {
    overlay = Overlay.of(context).context.findRenderObject() as RenderBox?;

    return GestureDetector(
      onTap: () {

        RecoverCubit.get(context).getScoresMap(gameName: 'Piano game', pLModel: widget.patientLoginModel);
      //   String? chooseGame = 'Piano game';
      //   dialogMessage(
      //   context: context,
      //   title: 'Check case',
      //   content: SizedBox(
      //     height: 80,
      //     child: Column(
      //       children: [
      //         const Text('check for decrease in scores'),
      //         Center(
      //           child: DropdownButton<String>(
      //             dropdownColor: RecoverColors.myColor,
      //             underline: const SizedBox(),
      //             value: chooseGame,
      //             style: RecoverTextStyles.recoverRegularMontserrat(
      //               color: Colors.white,
      //               fs: 12.0,
      //             ),
      //
      //             onChanged: (String? value) {
      //              setState(() {
      //                chooseGame = value;
      //              });
      //             },
      //             items: RecoverCubit.get(context)
      //                 .gamesName
      //                 .map<DropdownMenuItem<String>>((String value) {
      //               return DropdownMenuItem<String>(
      //                 value: value,
      //                 child: Text(value),
      //               );
      //             }).toList(),
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      //   actions: [
      //     OutlinedButton(
      //       onPressed: () {},
      //       style: OutlinedButton.styleFrom(backgroundColor: Colors.red),
      //       child: const Text('Yes'),
      //     ),
      //   ],
      // );
      },
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(
            color: RecoverColors.myColor,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.patientLoginModel.profileImage),
              radius: 30,
            ),
            const SizedBox(width: 20),
            RecoverNormalTexts(
              norText: widget.patientLoginModel.name,
              color: RecoverColors.recoverWhite,
            ),
            const Spacer(),
            InkWell(
              onTapDown: getPosition,
              onTap: () {
                showMenu(
                    color: RecoverColors.myColor,
                    context: context,
                    position: relRectSize,
                    items: games
                        .map((game) => PopupMenuItem(
                              child: InkWell(
                                onTap: () {
                                  pint('tapped game');
                                  Navigator.pop(context);
                                  navigateTo(
                                    context,
                                    PreScoreAnimation(
                                      patientLoginModel: widget.patientLoginModel,
                                      gameModel: game,
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                              game.image),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    RecoverHints(
                                        hint: game.name, color: Colors.white),
                                  ],
                                ),
                              ),
                            ))
                        .toList());
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.arrow_drop_down_circle_rounded,
                  color: RecoverColors.recoverWhite,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
