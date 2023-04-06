import 'dart:async';

import 'package:deixa/app.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  FlutterError.onError = (details, {bool forceReport = false}) {
    if (details.stack != null)
      Zone.current.handleUncaughtError(details.exception, details.stack!);
  };

  runZonedGuarded(() async {
    // Init your App.
    await dotenv.load(fileName: ".env.development");

    await initApplication("prod");
  }, (exception, stackTrace) async {
    await Sentry.captureException(exception, stackTrace: stackTrace);
  });
}

enum ENV { PRODUCTION, DEVELOPMENT, STAGING, LOCAL }
