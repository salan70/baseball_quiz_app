import 'package:flutter/material.dart';

import '../../domain/hitter_quiz.dart';
import 'quiz_widget.dart';

class ResultQuizWidget extends StatelessWidget {
  const ResultQuizWidget({
    super.key,
    required this.globalKey,
    required this.hitterQuiz,
  });

  final GlobalKey globalKey;
  final HitterQuiz hitterQuiz;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: globalKey,
      child: ColoredBox(
        color: Theme.of(context).colorScheme.background,
        child: QuizWidget(hitterQuiz: hitterQuiz),
      ),
    );
  }
}
