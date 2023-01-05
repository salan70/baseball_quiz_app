import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../state/hitter_search_condition_state.dart';

final choseTeamViewModelProvider =
    Provider.autoDispose<ChoseTeamViewModel>(ChoseTeamViewModel.new);

class ChoseTeamViewModel {
  ChoseTeamViewModel(
    this.ref,
  );

  final Ref ref;

  // 選択した球団のリストを保存する
  void saveTeamList(List<Object?> selectedList) {
    final searchCondition = ref.watch(hitterSearchConditionProvider);
    final notifier = ref.watch(hitterSearchConditionProvider.notifier);

    final teamList = selectedList.cast<String>();

    notifier.state = searchCondition.copyWith(teamList: teamList);
  }

  // 球団を取り除けるか判別する
  // 選択中のteamListの長さが2以上の場合に取り除ける
  // （取り除くとteamListが空になる場合取り除けない）
  bool canRemoveTeam() {
    final searchCondition = ref.watch(hitterSearchConditionProvider);
    final teamList = searchCondition.teamList;

    return teamList.length > 1;
  }

  // 選択した球団を取り除く
  void removeTeam(int selectedIndex) {
    final searchCondition = ref.watch(hitterSearchConditionProvider);
    final notifier = ref.watch(hitterSearchConditionProvider.notifier);

    final teamList = searchCondition.teamList;

    // teamListに対してremoveAt()が使えない（immutableだから？）ため、
    // 以下のようにremovedTeamListを作成
    final removedTeamList = <String>[];
    for (final team in teamList) {
      if (team != teamList[selectedIndex]) {
        removedTeamList.add(team);
      }
    }

    notifier.state = searchCondition.copyWith(teamList: removedTeamList);
  }
}
