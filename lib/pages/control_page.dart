import 'package:english_quotes/values/app_colors.dart';
import 'package:english_quotes/values/share_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../values/app_assets.dart';
import '../values/app_styles.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({super.key});

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  double sliderValue = 5;
  late SharedPreferences prefs;
  @override
  void initState() {
    initDefaultValue();
    super.initState();
  }

  initDefaultValue() async {
    prefs = await SharedPreferences.getInstance();
    int value = prefs.getInt(ShareKeys.counter) ?? 5;
    setState(() {
      sliderValue = value.toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlue,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.lightBlue,
        title: Text(
          'Your Control',
          style:
              AppStyles.h3.copyWith(color: AppColors.textColor, fontSize: 40),
        ),
        leading: InkWell(
          onTap: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setInt(ShareKeys.counter, sliderValue.toInt());
            Navigator.pop(context);
          },
          child: Image.asset(
            AppAssets.left_Arrow,
            scale: 1,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            Spacer(),
            Text(
              'Select the number of words displayed at once',
              style: AppStyles.h5.copyWith(color: AppColors.textColor),
            ),
            Spacer(),
            Text(
              '${sliderValue.toInt()}',
              style: AppStyles.h1.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 150),
            ),
            Spacer(),
            Slider(
                value: sliderValue,
                min: 5,
                max: 100,
                divisions: 95,
                activeColor: AppColors.primaryColor,
                inactiveColor: AppColors.primaryColor,
                onChanged: (value) {
                  print(sliderValue);
                  print(value);
                  setState(() {
                    sliderValue = value;
                  });
                }),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerLeft,
              child: Text(
                'Slide to set',
                style: AppStyles.h5.copyWith(color: AppColors.textColor),
              ),
            ),
            Spacer(),
            Spacer(),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
