import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'Infrastructure/supabase/supabase_providers.dart';
import 'repository/hitter_repository.dart';
import 'repository/supabase/supabase_hitter_repository.dart';
import 'ui/page/prepare_quiz/prepare_quiz_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // .envの読み込み
  await dotenv.load();

  // Supabaseの初期化
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_API_KEY']!,
  );

  runApp(
    ProviderScope(
      overrides: [
        hitterRepositoryProvider.overrideWith(
          (ref) {
            return SupabaseHitterRepository(
              ref.watch(supabaseProvider),
            );
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const Scaffold(
        body: Center(child: TextButtonWidget()),
      ),
    );
  }
}

class TextButtonWidget extends StatelessWidget {
  const TextButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: const Text('クイズの設定をする'),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute<Widget>(
            builder: (_) => const PrepareQuizPage(),
          ),
        );
      },
    );
  }
}
