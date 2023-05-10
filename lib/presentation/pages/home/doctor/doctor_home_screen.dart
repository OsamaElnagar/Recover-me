// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:recover_me/presentation/components/components.dart';
import 'package:recover_me/presentation/pages/error_occurred/error_occurred.dart';
import 'package:recover_me/presentation/pages/home/doctor/doctor_edit_profile.dart';
import 'package:recover_me/presentation/pages/patient_score/patient_score.dart';
import 'package:recover_me/data/models/patient_login_model.dart';
import 'package:recover_me/data/styles/paddings.dart';
import 'package:recover_me/data/styles/texts.dart';
import 'package:recover_me/domain/bloc/recover/recover_cubit.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:recover_me/presentation/widgets/glassy.dart';
import 'package:recover_me/presentation/widgets/my_background_designs.dart';
import '../../../../../data/models/game_model.dart';
import '../../../../../data/styles/colors.dart';
import '../../../widgets/my_loading.dart';

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
              body: SafeArea(
                child: SmartRefresher(
                  controller: refreshController,
                  header: WaterDropHeader(
                    waterDropColor: RecoverColors.myColor,
                    refresh: const MyLoading(),
                    complete: Container(),
                    completeDuration: Duration.zero,
                  ),
                  onRefresh: () => getData(),
                  child: typeBackground(
                    asset: 'assets/images/rr.jpg',
                    context: context,
                    child: RecoverPaddings.recoverAuthPadding(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 5),
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
                                          MediaQuery.of(context).size.width /
                                              10,
                                      backgroundColor: Colors.white,
                                      backgroundImage:
                                          CachedNetworkImageProvider(
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
                                      startAnimation ? 0 : screenWidth,
                                      0,
                                      0),
                                  child: BuildPatientItem(
                                    patientLoginModel:
                                    cubit.patients[index],
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                            const SizedBox(height: 20),
                          ],
                        ),
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

class BuildPatientItem extends StatelessWidget {
  PatientLoginModel patientLoginModel;

  BuildPatientItem({
    super.key,
    required this.patientLoginModel,
  });

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

    return Container(
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
            backgroundImage: NetworkImage(patientLoginModel.profileImage),
            radius: 30,
          ),
          const SizedBox(width: 20),
          RecoverNormalTexts(
            norText: patientLoginModel.name,
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
                items: [
                  PopupMenuItem(
                    child: InkWell(
                      onTap: () {
                        pint('tapped game');
                        Navigator.pop(context);
                        navigateTo(
                            context,
                            PatientScore(
                              patientLoginModel: patientLoginModel,
                            ));
                      },
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                CachedNetworkImageProvider(games[0].image),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          RecoverHints(hint: games[0].name,color: Colors.white),
                        ],
                      ),
                    ),
                    onTap: () {
                      //navigateTo(context, const PatientScore());
                    },
                  ),
                  PopupMenuItem(
                    child: InkWell(
                      onTap: () {
                        pint('tapped game');
                        Navigator.pop(context);
                        navigateTo(
                            context,
                            PatientScore(
                              patientLoginModel: patientLoginModel,
                            ));
                      },
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                CachedNetworkImageProvider(games[1].image),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          RecoverHints(hint: games[1].name,color: Colors.white,),
                        ],
                      ),
                    ),
                    onTap: () {
                      //navigateTo(context, const PatientScore());
                    },
                  ),
                  PopupMenuItem(
                    child: InkWell(
                      onTap: () {
                        pint('tapped game');
                        Navigator.pop(context);
                        navigateTo(
                            context,
                            PatientScore(
                              patientLoginModel: patientLoginModel,
                            ));
                      },
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                CachedNetworkImageProvider(games[2].image),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          RecoverHints(hint: games[2].name,color: Colors.white),
                        ],
                      ),
                    ),
                    onTap: () {
                      //navigateTo(context, const PatientScore());
                    },
                  ),
                  PopupMenuItem(
                    child: InkWell(
                      onTap: () {
                        pint('tapped game');
                        Navigator.pop(context);
                        navigateTo(
                            context,
                            PatientScore(
                              patientLoginModel: patientLoginModel,
                            ));
                      },
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                CachedNetworkImageProvider(games[3].image),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          RecoverHints(hint: games[3].name,color: Colors.white),
                        ],
                      ),
                    ),
                    onTap: () {
                      //navigateTo(context, const PatientScore());
                    },
                  ),
                ],
              );
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
    );
  }
}
