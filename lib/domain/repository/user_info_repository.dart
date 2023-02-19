// ignore_for_file: one_member_abstracts

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entity/quiz_result.dart';

final userInfoRepositoryProvider = Provider<UserInfoRepository>(
  (ref) => throw UnimplementedError('Provider was not initialized'),
);

abstract class UserInfoRepository {
  /// ユーザー情報を作成する
  Future<void> updateUserInfo(User user);

  /// ユーザー情報を作成する
  Future<bool> existSpecifiedDailyQuizResult(User user, String dailyQuizId);

  /// dailyQuizの結果を作成する
  Future<void> createDailyQuiz(User user, String dailyQuizId);

  /// dailyQuizの結果を更新する
  Future<void> updateDailyQuiz(
    User user,
    String dailyQuizId,
    QuizResult quizResult,
  );
}
