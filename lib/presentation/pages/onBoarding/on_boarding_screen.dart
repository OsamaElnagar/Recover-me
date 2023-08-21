import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:recover_me/presentation/pages/home/user_type.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../data/data_sources/consts.dart';
import '../../../../data/models/boardingModel.dart';
import '../../../../data/styles/colors.dart';
import '../../../../domain/bloc/recover/recover_cubit.dart';
import '../../../../domain/entities/cache_helper.dart';
import '../../components/components.dart';
import '../../widgets/build_onBoarding_item.dart';
import '../../widgets/recover_text_button.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen>
    with SingleTickerProviderStateMixin {
  PageController pageController = PageController();

  //late final BoardingModel boardingModel;

  bool canGoBack = false;

  void submit(context, Widget widget) {
    CacheHelper.putData('lastPage', lastPage!).then((value) {
      if (value) {
        if (canGoBack == false) {
          navigate2(
            context,
            widget,
          );
        } else {
          navigateTo(context, widget);
        }
      }
    });
  }

  PaletteGenerator? paletteGenerator;

  void getPaletteColor({BoardingModel? boardingModel}) async {
    paletteGenerator = await PaletteGenerator.fromImageProvider(
        boardingModel != null
            ? AssetImage(boardingModel.image)
            : AssetImage(RecoverCubit.get(context).boarding[0].image));
    setState(() {});
  }

  @override
  void initState() {
    getPaletteColor();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
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
    return BlocConsumer<RecoverCubit, RecoverState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = RecoverCubit.get(context);
        return Scaffold(
          backgroundColor: paletteColor(),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: PageView.builder(
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (index) {
                    if (index == cubit.boarding.length - 1) {
                      setState(() {
                        lastPage = true;
                      });
                    } else {
                      setState(() {
                        lastPage = false;
                      });
                    }
                    getPaletteColor(boardingModel: cubit.boarding[index]);
                  },
                  itemBuilder: (context, index) => OnBoardingBuilder(
                    boardingModel: cubit.boarding[index],
                  ),
                  controller: pageController,
                  itemCount: cubit.boarding.length,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
                child: SmoothPageIndicator(
                  controller: pageController,
                  count: cubit.boarding.length,
                  effect: const ExpandingDotsEffect(
                    dotWidth: 16.0,
                    dotHeight: 16.0,
                    dotColor: Colors.white,
                    activeDotColor: RecoverColors.myColor,
                    radius: 16.0,
                    spacing: 6,
                    expansionFactor: 4.0,
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(
                top: 20.0, bottom: 50, left: 30, right: 30),
            child: lastPage != true
                ? FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: () {
                      pageController.nextPage(
                        duration: const Duration(milliseconds: 700),
                        curve: Curves.ease,
                      );
                    },
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: paletteColor(),
                    ),
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      recoverTextButton(
                          onPressed: () {
                            // Go to Register Screen...
                            canGoBack = true;
                            submit(context, const UserType());
                          },
                          text: 'Get Started',
                          textColor: Colors.white,
                          buttonColor: paletteColor()),
                      // const SizedBox(
                      //   width: 20,
                      // ),
                      // recoverTextButton(
                      //   buttonColor: RecoverColors.recoverWhite,
                      //   onPressed: () {
                      //     canGoBack = true;
                      //     submit(context, const LoginScreen());
                      //   },
                      //   text: 'Sign In',
                      //   textColor: paletteColor(),
                      // ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
