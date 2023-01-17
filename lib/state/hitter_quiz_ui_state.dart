import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/ui/hitter_quiz_ui.dart';

// hitterQuizUiをAsyncValueとして返すプロバイダー
final hitterQuizUiStateProvider = StateProvider<AsyncValue<HitterQuizUi?>>(
  (_) => const AsyncValue.data(null),
);
