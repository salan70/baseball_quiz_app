import 'package:baseball_quiz_app/ui/page/play_quiz/component/answer_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('isShownAds', () {
    test('bool型を返すか確認', () {
      final result =
          ProviderContainer().read(answerViewModelProvider).isShownAds();
      expect(bool, result.runtimeType);
    });
  });
}
