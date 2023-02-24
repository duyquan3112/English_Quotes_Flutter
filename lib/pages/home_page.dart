import 'dart:math';


import 'package:english_words/english_words.dart';
import 'package:english_quotes/models/english_today.dart';
import 'package:english_quotes/values/app_assets.dart';
import 'package:english_quotes/values/app_colors.dart';
import 'package:english_quotes/values/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  late PageController _pageController;

  List<EnglishToday> words = [];
  
  List<int> fixedListRandom({int len = 1, int max = 120, int min = 1}){
    if (len > max || len < min) {
      return [];
    }

    List<int> newList = [];

    Random random = Random();

    int count = 1;
    while(count <= len){
      int val = random.nextInt(max);
      if (newList.contains(val)){
        continue;
      } else {
        newList.add(val);
        count++;
      }
    }
    return newList;
  }

  getEnglishToday(){
    List<String> newList = [];
    List<int> rans = fixedListRandom(len: 5, max: nouns.length);
    rans.forEach((index) {
      newList.add(nouns[index]);
     });
     words = newList.map((e) => EnglishToday(
      noun: e,
     )).toList();
  }


  @override
  void initState() {
    _pageController = PageController(viewportFraction: 0.9);
    getEnglishToday();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.lightBlue,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.lightBlue,
        title: Text(
          'English Today',
          style:
              AppStyles.h3.copyWith(color: AppColors.textColor, fontSize: 40),
        ),
        leading: InkWell(
          onTap: () {},
          child: Image.asset(
            AppAssets.menu,
            scale: 1,
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 26),
                width: double.infinity,
                height: size.height * 1 / 10,
                alignment: Alignment.centerLeft,
                child: Text(
                  '"Insanity is doing the same thing, over and over again, but expecting different results."',
                  style: AppStyles.h5.copyWith(color: AppColors.blackGrey),
                )),
            Container(
              //padding: const EdgeInsets.all(6),
              height: size.height * 2 / 3,
              child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemCount: words.length,
                  itemBuilder: (context, index) {

                    String letter = (words[index].noun ?? ' ');
                    String firstLetter = letter.substring(0, 1);
                    String restLetter = letter.substring(1, letter.length);

                    return Padding(
                      padding: const EdgeInsets.all(8),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(24)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                offset: Offset(3, 5),
                                blurRadius: 6,
                              )
                            ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                alignment: Alignment.centerRight,
                                child: Image.asset(
                                  AppAssets.heart,
                                  color: Colors.white,
                                )),
                            RichText(
                              maxLines: 1, //gioi han khong cho chu xuong dong
                              overflow:
                                  TextOverflow.ellipsis, //hieu ung gioi han chu
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                  text: firstLetter,
                                  style: TextStyle(
                                      fontFamily: fontFamily.Inter,
                                      fontSize: 100,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        BoxShadow(
                                          color: Colors.black38,
                                          offset: Offset(3, 6),
                                          blurRadius: 6,
                                        )
                                      ]),
                                  children: [
                                    TextSpan(
                                        text: restLetter,
                                        style: TextStyle(
                                            fontFamily: fontFamily.Inter,
                                            fontSize: 64,
                                            fontWeight: FontWeight.normal,
                                            shadows: [
                                              BoxShadow(
                                                color: Colors.transparent,
                                              )
                                            ]))
                                  ]),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(top: 30),
                                child: Text(
                                  '"The best and most beautiful things in the world cannot be seen or even touched - they must be felt with the heart."',
                                  style: AppStyles.h4.copyWith(
                                      color: AppColors.blackGrey,
                                      letterSpacing: 1.2),
                                ))
                          ],
                        ),
                      ),
                    );
                  }),
            ),

            /// Render Indicator

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: SizedBox(
                height: size.height * 1 / 11,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: words.length,
                      itemBuilder: (context, index) {
                        return buildIndicator(index == _currentIndex, size);
                      }),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: () {
          print('clicked');
        },
        child: Image.asset(
          AppAssets.reload,
          scale: 1,
        ),
      ),
    );
  }

  Widget buildIndicator(bool isActive, Size size) {
    return Container(
      margin: const EdgeInsets.all(16),
      width: isActive ? size.width * 1 / 5 : 24,
      decoration: BoxDecoration(
          color: isActive ? AppColors.lightBlue : AppColors.lightGrey,
          borderRadius: BorderRadius.all((Radius.circular(14))),
          boxShadow: [
            BoxShadow(
                color: Colors.black38, offset: Offset(2, 3), blurRadius: 3)
          ]),
    );
  }
}
