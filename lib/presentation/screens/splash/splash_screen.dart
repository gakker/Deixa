import 'package:deixa/data/repository/local/api/secure_storage_api.dart';
import 'package:deixa/domain/providers/crypto_provider.dart';
import 'package:deixa/domain/providers/wallet_connector_provider.dart';
import 'package:deixa/routing/app_router.gr.dart';
import 'package:flutter/material.dart';

import 'package:deixa/helpers/debug_report.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../locator/locator.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  AppRouter _router = locator<AppRouter>();

  @override
  initState() {
    SecureStorageApi.instance.init();
    ref.read(walletConnectorProvider).init();
    ref.read(cryptoProvider).initialize();
    super.initState();
    finishSplashScreen();
  }

  Future<void> finishSplashScreen() async {
    await Future.delayed(
      const Duration(seconds: 4),
      () {
        _router.pushAndPopUntil(
          AppMiddleWareRoute(),
          predicate: (Route<dynamic> route) => false,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Debug.showPage("Splash Screen", "/src/lib/pages/splash_screen");
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            child: Image(
                fit: BoxFit.fill,
                image: AssetImage("assets/gif/deixa-rotate-3d.gif")),
          ),
        ],
      ),
    );
  }
}
