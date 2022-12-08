import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constant/stats_type.dart';
import '../play_quiz_view_model.dart';

class QuizView extends ConsumerWidget {
  const QuizView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hitterQuizUi = ref.watch(hitterQuizUiProvider);

    return hitterQuizUi.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Text('Error: $err'),
      data: (data) {
        return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: data!.statsList.length,
            itemBuilder: (_, index) {
              final stats = data.statsList[index];
              final selectedStatsList = ref.watch(selectedStatsListProvider);

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(child: Center(child: Text(stats['年度']!))),
                    for (final selectedStats in selectedStatsList)
                      Expanded(
                          child:
                              Center(child: Text(stats[selectedStats.name]!))),
                  ],
                ),
              );
            });
      },
    );
  }
}