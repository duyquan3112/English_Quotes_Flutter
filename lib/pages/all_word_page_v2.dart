import 'package:auto_size_text/auto_size_text.dart';
import 'package:english_quotes/models/english_today.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../values/app_assets.dart';
import '../values/app_colors.dart';
import '../values/app_styles.dart';

class AllWordsPageVer2 extends StatefulWidget {
  final List<EnglishToday> words;
  const AllWordsPageVer2({super.key, required this.words});

  @override
  State<AllWordsPageVer2> createState() => _AllWordsPageVer2State();
}

class _AllWordsPageVer2State extends State<AllWordsPageVer2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: ListView.builder(
              itemCount: widget.words.length,
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
                        widget.words[index].isFavorite =
                            !widget.words[index].isFavorite;
                      });
                    },
                    child: ListTile(
                      trailing: InkWell(
                        onTap: () {
                          setState(() {
                            widget.words[index].isFavorite =
                                !widget.words[index].isFavorite;
                          });
                        },
                        child: Image.asset(
                          AppAssets.heart,
                          scale: 1,
                          color: widget.words[index].isFavorite
                              ? Colors.red
                              : Color.fromARGB(255, 175, 175, 175),
                        ),
                      ),
                      title: AutoSizeText(
                        widget.words[index].noun!,
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
                        widget.words[index].quote ?? 'default quote',
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
            'More Words',
            style:
                AppStyles.h3.copyWith(color: AppColors.textColor, fontSize: 40),
          ),
          leading: InkWell(
            onTap: () {
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
