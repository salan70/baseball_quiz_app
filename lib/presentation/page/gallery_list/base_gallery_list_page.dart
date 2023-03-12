import 'package:flutter/material.dart';

import '../../../util/constant/colors_constant.dart';
import '../../component/back_to_top_button.dart';
import '../../component/banner_ad_widget.dart';
import 'normal_quiz_gallery_list/normal_quiz_gallery_list_page.dart';

class BaseGalleryListPage extends StatelessWidget {
  const BaseGalleryListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(
                    labelStyle: Theme.of(context).textTheme.titleLarge,
                    labelColor: primaryColor,
                    indicatorColor: primaryColor,
                    indicatorSize: TabBarIndicatorSize.label,
                    tabs: const <Widget>[
                      Tab(text: 'ノーマルクイズ'),
                      Tab(text: '今日の１問'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: <Widget>[
                        const NormalQuizGalleryListPage(),
                        Container(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  BackToTopButton(),
                  SizedBox(height: 8),
                  BannerAdWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}