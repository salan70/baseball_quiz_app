// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import 'hitter_quiz_result.dart';

part 'daily_hitter_quiz_result.freezed.dart';

// @freezed
// class DailyHitterQuizResult with _$DailyHitterQuizResult {
//   const factory DailyHitterQuizResult({
//     required DateTime questionedAt,
//     required HitterQuizResult hitterQuizResult,
//   }) = _DailyHitterQuizResult;
// }

@freezed
class DailyHitterQuizResult with _$DailyHitterQuizResult {
  const factory DailyHitterQuizResult({
    required Map<String, HitterQuizResult> resultMap,
  }) = _DailyHitterQuizResult;
}
