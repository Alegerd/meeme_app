import 'dart:io';

import 'package:meeme_app/const/const.dart';
import 'package:meeme_app/viewModels/sliderModel.dart';
import 'package:meeme_app/widgets/sliderTitle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class OnboardingView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnboardingView> {

  // ignore: deprecated_member_use
  List<SliderModel> slides = new List<SliderModel>();
  var currentIndex = 0;
  var pageController = new PageController();

  @override
  void initState() {
    super.initState();
    slides = getSlides();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
          controller: pageController,
          onPageChanged: (val) {
            setState(() {
              currentIndex = val;
            });
          },
          itemCount: slides.length,
          itemBuilder: (context, index){
            return SliderTile(
              imageAssetPath: slides[index].getImageAssetPath(),
              title: slides[index].getTitle(),
              desc: slides[index].getDesc(),
            );
          }),

      bottomSheet: currentIndex != slides.length - 1 ? Container(
        height: Platform.isIOS ? 70 : 60,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
                onTap: () {
                  pageController.animateToPage(slides.length - 1, duration: Duration(milliseconds: 400), curve: Curves.linear);
                },
                child: Text("SKIP")
            ),
            Row(
              children: [
                for(var i = 0; i < slides.length; i++)
                  currentIndex == i
                      ? pageIndexIndicator(true)
                      : pageIndexIndicator(false)
              ],
            ),
            InkWell(
                onTap: () {
                  pageController.animateToPage(currentIndex + 1, duration: Duration(milliseconds: 400), curve: Curves.linear);
                },
                child: Text("NEXT")
            ),
          ],
        ),
      )
          :
      Container(
        alignment: Alignment.center,
        height: Platform.isIOS ? 70 : 60,
        color: AppColors.mainColor,

        child:
        InkWell(
            onTap: singUpPage,
            child: Text("GET STARTED NOW", style: TextStyle(
              color: AppColors.secondColor,
              fontWeight: FontWeight.w600,
            ),)
        ),
      ),
    );
  }

  singUpPage() {
    Navigator.of(context).popAndPushNamed("/SignUp");
  }

  Widget pageIndexIndicator (bool isCurrentPage) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.0),
      height: isCurrentPage ? 10.0 : 6.0,
      width: isCurrentPage ? 10.0 : 6.0,
      decoration: BoxDecoration(
        color: isCurrentPage ? AppColors.mainColor : AppColors.secondColor,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}