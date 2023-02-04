import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'Infrastructure/firebase/firebase_providers.dart';
import 'Infrastructure/supabase/supabase_providers.dart';
import 'model/typeadapter/hitter_search_condition.dart';
import 'repository/auth_repository.dart';
import 'repository/firebase/firebase_auth_repository.dart';
import 'repository/hitter_repository.dart';
import 'repository/hitter_search_condition_repository.dart';
import 'repository/hive/hive_hitter_search_condition_repository.dart';
import 'repository/supabase/supabase_hitter_repository.dart';
import 'state/auth_service.dart';
import 'state/hitter_quiz_ui_state.dart';
import 'state/key_providers.dart';
import 'state/loading_state.dart';
import 'ui/component/quiz_loading_widget.dart';
import 'ui/page/top/top_page.dart';
import 'util/constant/color_constant.dart';
import 'util/constant/hitter_search_condition_constant.dart';
import 'util/logger.dart';
import 'util/widget_ref_extension.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初期化関連
  await initialize();

  // HiveのBoxをopen
  final hitterSearchConditionBox =
      await Hive.openBox<HitterSearchCondition>(hitterSearchConditionBoxKey);

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
        hitterSearchConditionRepositoryProvider.overrideWith(
          (ref) {
            return HiveHitterSearchConditionRepository(
              hitterSearchConditionBox,
            );
          },
        ),
        authRepositoryProvider.overrideWith((ref) {
          return FirebaseAuthRepository(
            ref.watch(firebaseAuthProvider),
          );
        }),
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> initialize() async {
  WidgetsFlutterBinding.ensureInitialized();

  // .envの読み込み
  await dotenv.load();

  // Firebaseの初期化
  await Firebase.initializeApp();

  // Firebase Crashlytics
  FlutterError.onError = (errorDetails) {
    // Flutterフレームワーク内でスローされたすべてのエラーを送信する
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Flutterフレームワークで処理されないエラーを送信する
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // FCM の通知権限リクエスト
  final messaging = FirebaseMessaging.instance;
  await messaging.requestPermission();

  // トークンの取得（デバッグ用）
  final token = await messaging.getToken();
  logger.i('🐯 FCM TOKEN: $token');

  // Hiveの初期化
  await Hive.initFlutter();
  Hive.registerAdapter(HitterSearchConditionAdapter());

  // Supabaseの初期化
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_API_KEY']!,
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyApp();
}

class _MyApp extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // main()だとうまく表示されないため、
      // MyAppのinitState()に記載
      // ATTをダイアログ表示
      // AdMobの初期化より前に実行する必要がある
      if (await AppTrackingTransparency.trackingAuthorizationStatus ==
          TrackingStatus.notDetermined) {
        await AppTrackingTransparency.requestTrackingAuthorization();
      }
      // AdMobの初期化
      await MobileAds.instance.initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    // hitterQuizUiNotifierProviderの結果をハンドリングする
    ref.handleAsyncValue<void>(
      hitterQuizUiStateProvider,
    );

    // Userを作成
    ref.read(authServiceProvider).createUser();

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.rocknRollOneTextTheme().copyWith(
          bodyText2: GoogleFonts.rocknRollOneTextTheme().bodyText2?.copyWith(
                fontSize: 16,
              ),
          button: GoogleFonts.rocknRollOneTextTheme().button?.copyWith(
                fontSize: 16,
              ),
          headline5: GoogleFonts.rocknRollOneTextTheme().button?.copyWith(
                color: primaryColor,
              ),
        ),
        // ボタン
        primaryColor: highlightColor,
        canvasColor: backgroundColor,
        scaffoldBackgroundColor: backgroundColor,
        dialogBackgroundColor: backgroundColor,
        colorScheme: const ColorScheme.light(
          primary: primaryColor,
          error: errorColor,
          background: backgroundColor,
        ),
      ),
      navigatorKey: ref.watch(navigatorKeyProvider),
      builder: (context, child) => Consumer(
        builder: (context, ref, _) {
          final isLoading = ref.watch(loadingProvider);
          return Stack(
            children: [
              child!,
              // ローディングを表示する
              if (isLoading) const QuizLoadingWidget(),
            ],
          );
        },
      ),
      home: const TopPage(),
    );
  }
}
