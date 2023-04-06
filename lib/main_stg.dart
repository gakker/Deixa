import 'dart:async';

import 'package:deixa/app.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  if (kReleaseMode) {
    FlutterError.onError = (details, {bool forceReport = false}) {
      if (details.stack != null)
        Zone.current.handleUncaughtError(details.exception, details.stack!);
    };
  }
  runZonedGuarded(() async {
    // Init your App.
    await dotenv.load(fileName: ".env.development");

    await initApplication("staging");
  }, (exception, stackTrace) async {
    await Sentry.captureException(exception, stackTrace: stackTrace);
  });
}
