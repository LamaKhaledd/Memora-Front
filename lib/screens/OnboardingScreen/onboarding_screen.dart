import 'package:flutter/material.dart';
import 'package:memora/constants/app_constants.dart';
import 'package:memora/controllers/onboarding_provider.dart';
import 'package:memora/screens/OnboardingScreen/page_one.dart';
import 'package:memora/screens/OnboardingScreen/page_three.dart';
import 'package:memora/screens/OnboardingScreen/page_two.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController pageController = PageController();

  bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600;

  bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;
  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isMobile(context)) {
      return Scaffold(
        body: Consumer<OnBoardNotifier>(
          builder: (context, onBoardNotifier, child) {
            return Stack(
              children: [
                PageView(
                  physics: onBoardNotifier.isLastPage
                      ? const NeverScrollableScrollPhysics()
                      : const AlwaysScrollableScrollPhysics(),
                  controller: pageController,
                  onPageChanged: (page) {
                    onBoardNotifier.isLastPage = page == 2;
                  },
                  children: const [
                    PageOne(),
                    PageTwo(),
                    PageThree(),
                  ],
                ),
                Positioned(
                    left: 0,
                    right: 0,
                    child: onBoardNotifier.isLastPage
                        ? const SizedBox.shrink()
                        : Center(
                            child: SmoothPageIndicator(
                              controller: pageController,
                              count: 3,
                              effect: WormEffect(
                                  dotHeight: 12,
                                  dotWidth: 12,
                                  spacing: 10,
                                  dotColor:
                                      Color(kDarkGrey.value).withOpacity(0.5),
                                  activeDotColor: Color(kLight.value)),
                            ),
                          ))
              ],
            );
          },
        ),
      );
    } 
    
    
    
    
    else if (isDesktop(context)) {
      
     return const PageThree();

        }

    return Container();
  }
}
