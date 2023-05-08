import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:readmore/readmore.dart';
import 'package:recover_me/presentation/components/components.dart';
import 'package:recover_me/presentation/pages/home/patient/patient_edit_profile.dart';
import 'package:recover_me/presentation/widgets/build_game_item.dart';
import 'package:recover_me/data/models/game_model.dart';
import 'package:recover_me/data/styles/paddings.dart';
import 'package:recover_me/domain/bloc/recover/recover_cubit.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
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
    getPaletteColor();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        startAnimation = true;
      });
    });
  }

  PageController pageController = PageController();
  PaletteGenerator? paletteGenerator;

  void getPaletteColor({GameModel? gameModel}) async {
    paletteGenerator = await PaletteGenerator.fromImageProvider(
        gameModel != null
            ? NetworkImage(gameModel.image)
            : NetworkImage(RecoverCubit.get(context).games[0].image));
    setState(() {});
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
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return BlocConsumer<RecoverCubit, RecoverState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = RecoverCubit.get(context);
        var patientLoginModel = cubit.patientLoginModel;
        return Scaffold(
          backgroundColor: paletteColor(),
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
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: RecoverPaddings.recoverAuthPadding(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const SizedBox(height: 5),
                      RecoverHeadlines(
                        headline: 'Recover sphere profile',
                        color: RecoverColors.myColor,
                        fs: 20,
                      ),
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: () {

                          navigateTo(context, const PatientEditProfile());
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RecoverHeadlines(
                                    headline: 'Patient:',
                                    color: RecoverColors.myColor,
                                    fs: 20,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  RecoverNormalTexts(
                                    norText: patientLoginModel!.name,
                                    color: RecoverColors.myColor,
                                    fs: 16.0,
                                    maxLines: 1,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  RecoverHints(
                                    hint: patientLoginModel.disability ?? '',
                                    color: RecoverColors.myColor,
                                    fs: 15.0,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                              const Spacer(),
                              CircleAvatar(
                                radius: MediaQuery.of(context).size.width / 10,
                                backgroundColor: Colors.white,
                                backgroundImage: CachedNetworkImageProvider(
                                  patientLoginModel.profileImage,
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
                      const SizedBox(height: 20),
                      RecoverHeadlines(
                        headline: 'Recover sphere games',
                        color: RecoverColors.myColor,
                        fs: 20,
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 15.0),
                            child: SmoothPageIndicator(
                              controller: pageController,
                              count: cubit.games.length,
                              effect: const ExpandingDotsEffect(
                                dotWidth: 16.0,
                                dotHeight: 16.0,
                                dotColor: Colors.grey,
                                activeDotColor: RecoverColors.myColor,
                                radius: 16.0,
                                spacing: 6,
                                expansionFactor: 4.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: PageView.builder(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          controller: pageController,
                          onPageChanged: (value) {
                            setState(() {
                              getPaletteColor(gameModel: cubit.games[value]);
                            });
                          },
                          itemBuilder: (context, index) {
                            return GameItemBuilder(
                              gameModel: cubit.games[index],
                            );
                          },
                          itemCount: cubit.games.length,
                        ),
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

Widget myContainer({required Widget child}) {
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
