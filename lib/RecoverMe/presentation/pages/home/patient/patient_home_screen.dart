import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:readmore/readmore.dart';
import 'package:recover_me/RecoverMe/presentation/components/components.dart';
import 'package:recover_me/RecoverMe/presentation/pages/home/patient/patient_edit_profile.dart';
import 'package:recover_me/data/models/game_model.dart';
import 'package:recover_me/data/styles/paddings.dart';
import 'package:recover_me/domain/bloc/recover/recover_cubit.dart';
import '../../../../../data/styles/colors.dart';
import '../../../../../data/styles/fonts.dart';
import '../../../../../data/styles/texts.dart';
import '../../../widgets/my_loading.dart';

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({Key? key}) : super(key: key);

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  double screenHeight = 0;
  double screenWidth = 0;
  bool startAnimation = false;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  getData() async {
    setState(() {
      RecoverCubit.get(context).games.clear();
    });
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      RecoverCubit.get(context).getGames();
      RecoverCubit.get(context).getPatientData();
    });
    refreshController.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        startAnimation = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return BlocConsumer<RecoverCubit, RecoverState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = RecoverCubit.get(context);
        var patientLoginModel = cubit.patientLoginModel;
        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: CachedNetworkImageProvider(
                    patientLoginModel!.profileImage,
                  ),
                ),
                const SizedBox(width: 15),
                RecoverNormalTexts(
                  norText: patientLoginModel.name,
                  color: RecoverColors.recoverWhite,
                ),
                const Icon(
                  Icons.verified_rounded,
                  color: RecoverColors.recoverWhite,
                  size: 18.0,
                ),
              ],
            ),
            actions: [
              InkWell(
                onTap: () {
                  navigateTo(context, const PatientEditProfile());
                },
                child: const Padding(
                  padding: EdgeInsets.only(right: 15.0, left: 5.0),
                  child: Icon(
                    Icons.settings,
                    color: RecoverColors.recoverWhite,
                  ),
                ),
              ),
            ],
            backgroundColor: RecoverColors.myColor,
          ),
          body: SafeArea(
            child: SmartRefresher(
              controller: refreshController,
              header: WaterDropHeader(
                waterDropColor:  RecoverColors.myColor,
                refresh: const MyLoading(),
                complete: Container(),
                completeDuration: Duration.zero,
              ),
              onRefresh: () => getData(),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: RecoverPaddings.recoverAuthPadding(
                  child: Column(
                    children: [
                      ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return AnimatedContainer(
                            width: screenWidth,
                            curve: Curves.easeInOut,
                            duration: Duration(
                              milliseconds: 1000 + (index * 500),
                            ),
                            transform: Matrix4.translationValues(
                              startAnimation ? 0 : screenWidth,
                              0,
                              0,
                            ),
                            //height: 200,
                            child: Container(
                              width: screenWidth * .8,
                              //height: 300,
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: RecoverColors.myColor,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: buildGameItem(
                                gameModel: cubit.games[index],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            height: 2,
                            color: Colors.grey[300],
                          );
                        },
                        itemCount: cubit.games.length,
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

Widget buildGameItem({required GameModel gameModel}) {
  return Column(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: CachedNetworkImage(
          width: double.infinity,
          imageUrl: gameModel.image,
          progressIndicatorBuilder: (context, url, progress) => Center(
            child: CircularProgressIndicator(
              value: progress.progress,
            ),
          ),
          fit: BoxFit.fitWidth,
        ),
      ),
      const SizedBox(
        height: 5,
      ),
      RecoverNormalTexts(
        norText: gameModel.name,
        color: RecoverColors.recoverBlack,
      ),
      ReadMoreText(
        gameModel.description,
        moreStyle: RecoverTextStyles.recoverHintMontserrat(
            color: RecoverColors.recoverBlack),
        style: RecoverTextStyles.recoverHintMontserrat(
          color: RecoverColors.myColor,
        ),
      ),
    ],
  );
}

Widget myContainer(Widget child) {
  return Container(
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      border: Border.all(
        color: RecoverColors.myColor,
        width: 2.0,
      ),
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: child,
  );
}
