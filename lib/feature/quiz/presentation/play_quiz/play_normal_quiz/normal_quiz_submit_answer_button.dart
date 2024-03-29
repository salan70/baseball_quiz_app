import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../common_widget/my_button.dart';
import '../../../../../util/constant/hitting_stats_constant.dart';
import '../../../../admob/application/interstitial_ad_service.dart';
import '../../../../quiz_result/application/quiz_result_service.dart';
import '../../../application/hitter_quiz_notifier.dart';
import '../../../domain/hitter.dart';
import '../../quiz_result/normal_quiz_result/normal_quiz_result_page.dart';
import '../component/incorrect_dialog.dart';

class NormalQuizSubmitAnswerButton extends ConsumerWidget {
  const NormalQuizSubmitAnswerButton({
    super.key,
    required this.buttonType,
    required this.enteredHitter,
  });

  final ButtonType buttonType;
  final Hitter? enteredHitter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MyButton(
      buttonName: 'submit_answer_button',
      buttonType: buttonType,
      onPressed: enteredHitter == null
          ? null
          : () async {
              final navigator = Navigator.of(context);

              // interstitial 広告を作成する。
              final interstitialAdService =
                  ref.read(interstitialAdServiceProvider);
              await interstitialAdService.createAd();
              await interstitialAdService.waitResult();

              final hitterQuizNotifier = ref.read(
                hitterQuizNotifierProvider(QuizType.normal, questionedAt: null)
                    .notifier,
              );
              final isCorrect = hitterQuizNotifier.isCorrectHitterQuiz();

              // 正解の場合。
              if (isCorrect) {
                hitterQuizNotifier.markCorrect();
                await ref
                    .read(quizResultServiceProvider)
                    .createNormalQuizResult();

                // `createNormalQuizResult()` でエラーが発生しなかった場合のみ、
                // 画面遷移する。
                await navigator.push(
                  MaterialPageRoute<Widget>(
                    builder: (_) => NormalQuizResultPage(),
                    settings: const RouteSettings(
                      name: '/play_normal_quiz_page',
                    ),
                  ),
                );
                return;
              }
              // 不正解の場合。
              hitterQuizNotifier.addIncorrectCount();

              // 広告を確率で表示する。
              await interstitialAdService.randomShowAd();

              if (context.mounted) {
                await showDialog<void>(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) {
                    return IncorrectDialog.normal(
                      hitterName: enteredHitter!.label,
                    );
                  },
                );
              }
            },
      child: const Text('回答する'),
    );
  }
}
