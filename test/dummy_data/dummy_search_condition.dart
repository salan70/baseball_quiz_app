import 'package:baseball_quiz_app/feature/search_condition/domain/search_condition.dart';
import 'package:baseball_quiz_app/util/constant/hitting_stats_constant.dart';

/// 1つの球団を選択しているダミーデータ
final dummySearchCondition1 = SearchCondition(
  teamList: [
    '千葉ロッテマリーンズ',
  ],
  minGames: 0,
  minHits: 0,
  minHr: 0,
  selectedStatsList: [
    StatsType.team.label,
    StatsType.avg.label,
    StatsType.hr.label,
    StatsType.ops.label,
  ],
);

/// 2つの球団を選択しているダミーデータ
final dummySearchCondition2 = SearchCondition(
  teamList: [
    '千葉ロッテマリーンズ',
    '阪神タイガース',
  ],
  minGames: 0,
  minHits: 0,
  minHr: 0,
  selectedStatsList: [
    StatsType.team.label,
    StatsType.avg.label,
    StatsType.hr.label,
    StatsType.ops.label,
  ],
);
