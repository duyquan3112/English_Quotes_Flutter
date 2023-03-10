import 'package:auto_size_text/auto_size_text.dart';
import 'package:english_quotes/models/english_today.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../values/app_assets.dart';
import '../values/app_colors.dart';
import '../values/app_styles.dart';

class AllWordsPage extends StatelessWidget {
  final List<EnglishToday> words;
  const AllWordsPage({super.key, required this.words});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          padding: EdgeInsets.all(8),
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: words
                .map((e) => Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(8)),
                      child: AutoSizeText(
                        e.noun ?? '',
                        style: AppStyles.h4.copyWith(shadows: [
                          BoxShadow(
                            color: Colors.black38,
                            offset: Offset(2, 3),
                            blurRadius: 6,
                          ),
                        ], fontWeight: FontWeight.bold, letterSpacing: 1),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ))
                .toList(),
          ),
        ),
        backgroundColor: AppColors.lightBlue,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.lightBlue,
          title: Text(
            'All Words',
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
