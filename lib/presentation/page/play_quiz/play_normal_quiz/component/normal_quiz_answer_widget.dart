import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../application/admob/interstitial_ad_service.dart';
import '../../../../../application/quiz/hitter_quiz/hitter_quiz_service.dart';
import '../../../../../application/quiz/hitter_quiz/hitter_quiz_state.dart';
import '../../../../../application/widget/widget_state.dart';
import '../../../../../util/constant/text_in_app.dart';
import '../../../quiz_result/normal_quiz_result/normal_quiz_result_page.dart';
import '../../component/answer_widget.dart';
import '../../component/incorrect_dialog.dart';

class NormalQuizAnswerWidget extends ConsumerWidget {
  const NormalQuizAnswerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnswerWidget(
      onSubmittedAnswer: () async {
        final navigator = Navigator.of(context);
        const normalQuizResultPage = NormalQuizResultPage();

        final isCorrectNotifier = ref.read(isCorrectQuizStateProvider.notifier);

        // interstitial広告を作成
        final interstitialAdService = ref.read(interstitialAdServiceProvider);
        await interstitialAdService.createAd();
        await interstitialAdService.waitResult();

        isCorrectNotifier.state =
            ref.read(hitterQuizServiceProvider).isCorrectHitterQuiz();

        // 正解の場合
        if (isCorrectNotifier.state) {
          await navigator.push(
            MaterialPageRoute<Widget>(builder: (_) => normalQuizResultPage),
          );
          return;
        }

        // interstitial広告を確率で表示
        await interstitialAdService.randomShowAd();

        if (context.mounted) {
          await showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return IncorrectDialog(
                selectedHitter: ref.read(answerTextFieldProvider).text,
                retireConfirmText: normalQuizRetireConfirmText,
                resultPage: normalQuizResultPage,
              );
            },
          );
        }
      },
    );
  }
}
