import 'package:baseball_quiz_app/feature/admob/application/ad_id_state.dart';
import 'package:baseball_quiz_app/feature/admob/domain/rewarded_ad_state.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../util/logger.dart';

part 'rewarded_ad_notifier.g.dart';

/// [RewardedAd] を保持する [Notifier].
@riverpod
class RewardedAdNotifier extends _$RewardedAdNotifier {
  @override
  RewardAdState build() => const RewardAdState();

  /// 広告を作成する。
  Future<void> loadAd() async {
    await RewardedAd.load(
      adUnitId: await ref.read(rewardAdIdProvider.future),
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (Ad ad) {
          logger.i('リワード広告を読み込みました。');
          state = state.copyWith(
            rewardedAd: ad as RewardedAd,
            isLoaded: true,
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          logger.e('リワード広告の読み込みに失敗しました。: $error');
        },
      ),
    );
  }

  /// 広告を表示する。
  ///
  /// 広告の視聴が完了したら、 state.isWatchCompleted が true になる。
  void showAd() {
    state.rewardedAd
      ?..fullScreenContentCallback = FullScreenContentCallback(
        // 広告が表示された場合。
        onAdShowedFullScreenContent: (ad) {
          logger.i('fullScreen content が表示されました。');
        },
        // 広告が閉じられた場合。
        onAdDismissedFullScreenContent: (ad) {
          logger.i('fullScreen content が閉じられました。');
          ad.dispose();
          loadAd();
        },
        // 広告でエラーが発生した場合。
        onAdFailedToShowFullScreenContent: (ad, error) {
          logger.e('fullScreen content でエラーが発生しました。', error);
          ad.dispose();
          loadAd();
        },
      )
      ..setImmersiveMode(true)
      ..show(
        onUserEarnedReward: (ad, reward) {
          logger.i('リワード広告の視聴が完了しました。');
          state = state.copyWith(isWatchCompleted: true);
        },
      );
  }

  /// state.isStartedQuiz を true にする。
  void updateIsStartedQuiz() {
    state = state.copyWith(isStartedQuiz: true);
  }
}
