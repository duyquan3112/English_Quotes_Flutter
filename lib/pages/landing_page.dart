import 'package:english_quotes/values/app_assets.dart';
import 'package:english_quotes/values/app_colors.dart';
import 'package:english_quotes/values/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class landingPage extends StatelessWidget {
  const landingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(children: [
          Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text('Welcome to ',
              style: AppStyles.h3,),
          )),
          Expanded(
              child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text('English',
                    style: AppStyles.h2.copyWith(
                      color: AppColors.blackGrey,
                      fontWeight: FontWeight.bold
                    ),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 30),
                    child: Text('Quotes',
                      textAlign: TextAlign.right,
                      style: AppStyles.h4.copyWith(
                        height: 0.5,
                      ),),
                  )
                ],
              ),
          )),
          Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 150),
                child: RawMaterialButton(
                  shape: CircleBorder(),
                  fillColor: AppColors.lightBlue,
                  onPressed: () {},
                  child: Image.asset(AppAssets.right_Arrow),),
              )),
        ]),
      ),
    );
  }
}
