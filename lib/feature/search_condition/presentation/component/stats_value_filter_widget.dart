import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../util/constant/search_condition_constant.dart';
import '../../application/search_condition_state.dart';

class StatsValueFilterWidget extends ConsumerWidget {
  const StatsValueFilterWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchCondition = ref.watch(searchConditionProvider);
    final notifier = ref.watch(searchConditionProvider.notifier);

    final size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.only(left: 16, right: size.width * 0.2),
      child: Column(
        children: [
          // 最低通算試合数
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('最低通算試合数'),
              DropdownButton<int>(
                items: statsFilterDropdownMenu(minGamesOptionList),
                onChanged: (int? value) {
                  notifier.state = searchCondition.copyWith(minGames: value!);
                },
                value: searchCondition.minGames,
              ),
            ],
          ),
          // 最低通算打席数
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('最低通算ヒット数'),
              DropdownButton<int>(
                items: statsFilterDropdownMenu(minHitsOptionList),
                onChanged: (int? value) {
                  notifier.state = searchCondition.copyWith(minHits: value!);
                },
                value: searchCondition.minHits,
              ),
            ],
          ),
          // 最低通算ホームラン数
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('最低通算ホームラン数'),
              DropdownButton<int>(
                items: statsFilterDropdownMenu(minHrOptionList),
                onChanged: (int? value) {
                  notifier.state = searchCondition.copyWith(minHr: value!);
                },
                value: searchCondition.minHr,
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<int>> statsFilterDropdownMenu(List<int> intItemList) {
    return intItemList
        .map(
          (e) => DropdownMenuItem(
            value: e,
            child: Text('$e'),
          ),
        )
        .toList();
  }
}