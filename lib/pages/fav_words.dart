import 'package:auto_size_text/auto_size_text.dart';
import 'package:english_quotes/models/english_today.dart';
import 'package:english_quotes/package/quotes/quote.dart';
import 'package:english_quotes/package/quotes/quote_model.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../values/app_assets.dart';
import '../values/app_colors.dart';
import '../values/app_styles.dart';

class FavoriteWords extends StatefulWidget {
  final List<EnglishToday> allWords;
  final List<EnglishToday> words;

  const FavoriteWords({super.key, required this.allWords, required this.words});

  @override
  State<FavoriteWords> createState() => _FavoriteWordsState();
}

class _FavoriteWordsState extends State<FavoriteWords> {
  List<EnglishToday> favWords = [];
  reUpdateFav() {
    for (var i = 0; i < widget.words.length; i++) {
      for (var j = 0; j < favWords.length; j++) {
        if (favWords[j].noun == widget.words[i].noun) {
          widget.words[i].isFavorite = favWords[j].isFavorite;
          print("reupdate fav");
          continue;
        }
      }
    }
  }

  getFavWords() {
    print(widget.allWords.length);
    for (var i = 0; i < widget.allWords.length; i++) {
      if (widget.allWords[i].isFavorite) {
        print(widget.allWords[i].noun);
        favWords.add(widget.allWords[i]);
      }
    }
  }

  @override
  void initState() {
    getFavWords();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: ListView.builder(
              itemCount: favWords.length,
              itemBuilder: ((context, index) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                  decoration: BoxDecoration(
                      color: index % 2 == 0
                          ? AppColors.lightBlue
                          : AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(8)),
                  child: InkWell(
                    onDoubleTap: () {
                      setState(() {
                        favWords[index].isFavorite =
                            !favWords[index].isFavorite;
                      });
                    },
                    child: ListTile(
                      trailing: InkWell(
                        onTap: () {
                          setState(() {
                            favWords[index].isFavorite =
                                !favWords[index].isFavorite;
                          });
                        },
                        child: Image.asset(
                          AppAssets.heart,
                          scale: 1,
                          color: favWords[index].isFavorite
                              ? Colors.red
                              : Color.fromARGB(255, 175, 175, 175),
                        ),
                      ),
                      title: AutoSizeText(
                        favWords[index].noun!,
                        style: AppStyles.h3.copyWith(
                            color: index % 2 != 0
                                ? Colors.white
                                : AppColors.blackGrey,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            shadows: [
                              BoxShadow(
                                color: Colors.black26,
                                offset: Offset(2, 3),
                                blurRadius: 6,
                              )
                            ]),
                        minFontSize: 12,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: AutoSizeText(
                        favWords[index].quote ?? 'default quote',
                        style: AppStyles.h4.copyWith(
                          letterSpacing: 1.1,
                          color: index % 2 != 0
                              ? Colors.white
                              : AppColors.blackGrey,
                        ),
                        minFontSize: 18,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                );
              })),
        ),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.lightBlue,
          title: Text(
            'Favorite Words',
            style:
                AppStyles.h3.copyWith(color: AppColors.textColor, fontSize: 40),
          ),
          leading: InkWell(
            onTap: () {
              reUpdateFav();
              Navigator.pop(context);
            },
            child: Image.asset(
              AppAssets.left_Arrow,
              scale: 1,
            ),
          ),
        ));
  }
}
