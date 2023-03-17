import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:english_quotes/package/quotes/quote.dart';
import 'package:english_quotes/package/quotes/quote_model.dart';
import 'package:english_quotes/pages/all_word_page_v2.dart';
import 'package:english_quotes/pages/all_words_page.dart';
import 'package:english_quotes/pages/control_page.dart';
import 'package:english_quotes/pages/fav_words.dart';
import 'package:english_quotes/values/share_keys.dart';
import 'package:english_quotes/widgets/app_button.dart';
import 'package:english_words/english_words.dart';
import 'package:english_quotes/models/english_today.dart';
import 'package:english_quotes/values/app_assets.dart';
import 'package:english_quotes/values/app_colors.dart';
import 'package:english_quotes/values/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  late PageController _pageController;

  List<EnglishToday> words = [];
  List<EnglishToday> allWords = [];

  String headerQuote = Quotes().getRandom().content!;

  List<int> fixedListRandom({int len = 1, int max = 120, int min = 1}) {
    //neu cac gia tri bi loi thi se tra ve mang rong
    if (len > max || len < min) {
      return [];
    }

    List<int> newList = [];

    Random random = Random();

    int count = 1;
    //tao list co do lon = len
    while (count <= len) {
      int val = random.nextInt(max);
      if (newList.contains(val)) {
        //lay gia tri index ngau nhien khong trung lap
        continue;
      } else {
        newList.add(val);
        count++;
      }
    }
    return newList;
  }

  getAllWords() async {
    List<String> newList = [];
    int len = nouns.length;
    for (var i = 0; i < len; i++) {
      newList.add(nouns[i]);
    }
    setState(() {
      allWords = newList.map((e) => getQuote(e)).toList();
    });
  }

  updateFavorite() async {
    for (var i = 0; i < words.length; i++) {
      for (var j = 0; j < allWords.length; j++) {
        if (allWords[j].noun == words[i].noun) {
          allWords[j].isFavorite = words[i].isFavorite;
          print("update fav");
          continue;
        }
      }
    }
  }

  getEnglishToday() async {
    print('before');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('after');
    int len = prefs.getInt(ShareKeys.counter) ??
        5; // lay gia tri counter tu control page
    List<String> newList = [];
    List<int> rans = fixedListRandom(len: len, max: allWords.length);
    rans.forEach((index) {
      //duyet tung index, sau do lay noun tu lib roi add vao newlist
      newList.add(allWords[index].noun!);
    });
    print('has data');
    setState(() {
      updateFavorite();
      print('rendered');
      words = newList.map((e) => getQuote(e)).toList();
    });
  }

  EnglishToday getQuote(String noun) {
    Quote? quote;
    quote = Quotes().getByWord(noun);
    return EnglishToday(
      noun: noun,
      quote: quote?.content,
      id: quote?.id,
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _pageController = PageController(viewportFraction: 0.9);
    getAllWords();
    getEnglishToday();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
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
          onTap: () {
            _scaffoldKey.currentState?.openDrawer();
          },
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
                  '"$headerQuote"',
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
                  itemCount: words.length > 5
                      ? 6
                      : words
                          .length, //set dieu kien de chi hien 1 blank pageview
                  itemBuilder: (context, index) {
                    String letter = (words[index].noun ?? ' ');
                    String firstLetter = letter.substring(0, 1);
                    String restLetter = letter.substring(1, letter.length);
                    String quoteDefault =
                        'The best and most beautiful things in the world cannot be seen or even touched - they must be felt with the heart.';
                    String quote = words[index].quote != null
                        ? words[index].quote!
                        : quoteDefault;

                    ///return card
                    /// with animation change page
                    return AnimatedContainer(
                      duration: const Duration(microseconds: 1000),
                      curve: Curves.decelerate,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Material(
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                          color: AppColors.primaryColor,
                          elevation: 4,
                          child: index >=
                                  5 //set dieu kien de render pageview showmore
                              ? InkWell(
                                  onTap: () async {
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                //AllWordsPage(words: words)
                                                AllWordsPageVer2(
                                                    words: words)));
                                    setState(() {
                                      updateFavorite();
                                    });
                                  },
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(24)),
                                  splashColor: AppColors.lightBlue,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: Center(
                                      child: AutoSizeText(
                                        'Tap for show more...',
                                        style: AppStyles.h3.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            shadows: [
                                              BoxShadow(
                                                color: Colors.black38,
                                                offset: Offset(3, 4),
                                                blurRadius: 6,
                                              )
                                            ]),
                                        minFontSize: 12,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                )
                              : InkWell(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(24)),
                                  onDoubleTap: () {
                                    setState(() {
                                      words[index].isFavorite =
                                          !words[index].isFavorite;
                                    });
                                  },
                                  splashColor: AppColors.lightBlue,
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    // decoration: BoxDecoration(
                                    //     // color: AppColors.primaryColor,
                                    //     // borderRadius:
                                    //     //     BorderRadius.all(Radius.circular(24)),
                                    //     boxShadow: [
                                    //       BoxShadow(
                                    //         color: Colors.black26,
                                    //         offset: Offset(3, 5),
                                    //         blurRadius: 6,
                                    //       )
                                    //     ]),

                                    ///content of pageviews
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            alignment: Alignment.centerRight,
                                            child: Image.asset(
                                              AppAssets.heart,
                                              color: words[index].isFavorite
                                                  ? Colors.red
                                                  : Colors.white,
                                            )),
                                        AutoSizeText.rich(
                                          maxLines:
                                              1, //gioi han khong cho chu xuong dong
                                          overflow: TextOverflow
                                              .ellipsis, //hieu ung gioi han chu
                                          textAlign: TextAlign.start,
                                          TextSpan(
                                              text: firstLetter,
                                              style: TextStyle(
                                                  fontFamily: fontFamily.Inter,
                                                  fontSize: 100,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
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
                                                        fontFamily:
                                                            fontFamily.Inter,
                                                        fontSize: 64,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        shadows: [
                                                          BoxShadow(
                                                            color: Colors
                                                                .transparent,
                                                          )
                                                        ]))
                                              ]),
                                        ),
                                        Padding(
                                            padding:
                                                const EdgeInsets.only(top: 30),
                                            child: AutoSizeText(
                                              '"$quote"',
                                              maxFontSize: 26,
                                              style: AppStyles.h4.copyWith(
                                                  color: AppColors.blackGrey,
                                                  letterSpacing: 1.2),
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    );
                  }),
            ),

            /// Render Indicator
            // Show more
            // _currentIndex >= 5
            //     ? buildShowmore():
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: SizedBox(
                height: size.height * 1 / 11,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: words.length > 5 ? 5 : words.length,
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
          setState(() {
            getEnglishToday();
          });
        },
        child: Image.asset(
          AppAssets.reload,
          scale: 1,
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: AppColors.lightBlue,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 26, horizontal: 24),
                child: Text(
                  'Your mind',
                  style: (AppStyles.h3.copyWith(color: AppColors.textColor)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: AppButton(
                    label: 'Favorites',
                    onTap: () async {
                      updateFavorite();
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => FavoriteWords(
                                    allWords: allWords,
                                    words: words,
                                  )));
                      setState(() {
                        updateFavorite();
                      });
                    }),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: AppButton(
                    label: 'Your Control',
                    onTap: () async {
                      await Navigator.push(context,
                          MaterialPageRoute(builder: (_) => ControlPage()));

                      ///Auto reload when changed number of words
                      setState(() {
                        getEnglishToday();
                      });
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildIndicator(bool isActive, Size size) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.decelerate,
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

  // Widget buildShowmore() {
  //   return Container(
  //     alignment: Alignment.centerLeft,
  //     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  //     child: Material(
  //         color: AppColors.primaryColor,
  //         elevation: 4,
  //         borderRadius: BorderRadius.circular(16),
  //         child: InkWell(
  //           splashColor: AppColors.lightBlue,
  //           borderRadius: BorderRadius.circular(16),
  //           onTap: () {
  //             print('show more');
  //             Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                     builder: (_) => AllWordsPage(words: words)));
  //           },
  //           child: Container(
  //             padding: EdgeInsets.all(16),
  //             child: Text(
  //               'Show More',
  //               style: AppStyles.h5,
  //             ),
  //           ),
  //         )),
  //   );
  // }
}
