// App Main Screen
import 'dart:developer';
import 'dart:io';

import 'package:deixa/domain/providers/language_provider.dart';
import 'package:deixa/domain/providers/theme_provider.dart';
import 'package:deixa/helpers/firebase_analytics_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:deixa/presentation/res/colors.dart';
import 'package:deixa/data/constant/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/app_config.dart';
import 'helpers/route_observer.dart';
import 'locator/locator.dart';
import 'routing/app_router.gr.dart';
import 'utils/localization.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((_) {
  throw UnimplementedError('Not yet initiated');
});

Future initApplication(String env) async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await Hive.openBox(USERS);
  await Hive.openBox(SETTINGS);
  await Hive.openBox(ALL_CRYPTO_DATAS);
  await Hive.openBox(CRYPTO_DATAS);
  await setupLocator();

  await SentryFlutter.init(
    (options) {
      options.environment = env;
      options.autoSessionTrackingInterval = Duration(milliseconds: 60000);
      options.tracesSampleRate = 0.2;
      options.dsn = dotenv.env['SENTRY_DSN'];
      options.enableAutoPerformanceTracking = true;
    },
    appRunner: () => runApp(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences)
        ],
        child: DefaultAssetBundle(
          bundle: SentryAssetBundle(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Stack(
              children: [
                AppMain(),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    padding: EdgeInsets.only(top: 60, right: 60),
                    child: Banner(
                      message: "Alpha",
                      location: BannerLocation.bottomStart,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
  SentryFlutter.setAppStartEnd(DateTime.now().toUtc());
}

class AppMain extends ConsumerStatefulWidget {
  @override
  _AppMainState createState() => _AppMainState();
}

class _AppMainState extends ConsumerState<AppMain> {
  final _router = locator<AppRouter>();

  @override
  Widget build(BuildContext context) {
    locator<FirebaseAnalyticsService>()
        .analytics
        .setAnalyticsCollectionEnabled(false);
    locator<FirebaseAnalyticsService>()
        .analytics
        .setAnalyticsCollectionEnabled(true);

    final themeModeController = ref.watch(themeModeProvider);
    final languageController = ref.watch(languageProvider);
    final ThemeData theme = ThemeData();

    return MaterialApp.router(
      locale: Locale(languageController.getLocale),
      routeInformationParser: _router.defaultRouteParser(),
      routerDelegate: _router.delegate(
          navigatorObservers: () => [
                locator<FirebaseAnalyticsService>().appAnalyticsObserver(),
                DeixaRouteObserver(),
                SentryNavigatorObserver(
                    enableAutoTransactions: false,
                    setRouteNameAsTransaction: true)
              ]),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        AppLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('ar', "AE"),
        Locale('de', "DE"),
        Locale('en', "US"),
        Locale('es', "ES"),
        Locale('fr', "FR"),
        Locale('hi', "IN"),
        Locale('id', "ID"),
        Locale('ja', "JP"),
        Locale('ko', "KR"),
        Locale('nl', "NL"),
        Locale('pt', "PT"),
        Locale('ru', "RU"),
        Locale('zh', "CN"),
      ],
      debugShowCheckedModeBanner: false,
      title: APP_NAME,
      themeMode: themeModeController.getTheme(),
      theme: ThemeData(
        primarySwatch: kPrimarySwatch,
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      darkTheme: ThemeData(
        primarySwatch: kPrimarySwatch,
        scaffoldBackgroundColor: kScaffoldBackgroundColor,
        colorScheme: theme.colorScheme.copyWith(
          secondary: accentColor,
          brightness: Brightness.dark,
          primary: Colors.purple,
        ),
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
    );
  }
}

bool isOpening = false;
Future<void> initDynamicLinks() async {
  FirebaseDynamicLinks.instance.onLink
      .listen((PendingDynamicLinkData dynamicLink) async {
    final deepLink = dynamicLink.link;
    log('on Success : ' + deepLink.toString());

    log("is opening 1:$isOpening");
    if (isOpening) return;
    log("is opening 2:$isOpening");

    isOpening = true;
    await Future.delayed(Duration(seconds: 1));
    referringLink = deepLink.queryParameters['invited_by'] ?? "";
    isOpening = false;
  });

  final data = await FirebaseDynamicLinks.instance.getInitialLink();
  final deepLink = data?.link;

  if (deepLink != null) {
    if (isOpening) return;
    isOpening = true;
    log('pending dynamic link : ' + deepLink.toString());
    print('pending dynamic link : ' + deepLink.toString());

    await Future.delayed(Duration(seconds: 2));
    referringLink = deepLink.queryParameters['invited_by'] ?? "";
    isOpening = false;
  }
}
