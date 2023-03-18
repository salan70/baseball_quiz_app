import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../admob/presentation/banner_ad_widget.dart';
import '../../daily_quiz/presentation/to_play_daily_quiz_button.dart';
import 'component/to_gallery_button.dart';
import 'component/to_play_normal_quiz_from_top_button.dart';
import 'component/to_prepare_quiz_button.dart';
import 'component/to_setting_button.dart';

class TopPage extends StatelessWidget {
  const TopPage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 40, top: 100, right: 40),
          child: Center(
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.topRight,
                  child: ToSettingButton(),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      ToPrepareQuizButton(),
                      SizedBox(height: 8),
                      ToPlayNormalQuizFromTopButton(),
                      SizedBox(height: 8),
                      ToPlayDailyQuizButton(),
                      SizedBox(height: 8),
                      ToGalleryButton(),
                      SizedBox(height: 80),
                    ],
                  ),
                ),
                const Align(
                  alignment: Alignment.bottomCenter,
                  child: BannerAdWidget(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}