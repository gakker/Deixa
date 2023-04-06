// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:deixa/data/constant/strings.dart';
import 'package:deixa/data/repository/remote/nftMarketPlace/nft_repo_impl.dart';
import 'package:deixa/helpers/secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CustomBindings extends AutomatedTestWidgetsFlutterBinding {
  @override
  bool get overrideHttpClient => false;
}

void main() {
  group("SWAP", () {
    SecureStorage.transferKey =
        "13baee3a1797874bf384cbe764e7a4e7c90d3628042e70cd9ed538d4febefd58";

    setUpAll(() {
      TestWidgetsFlutterBinding.ensureInitialized();
    });
    test("Swap", () async {
      await Hive.initFlutter();
      await Hive.openBox(USERS);
      // await SwapRepoImpl().swapCoin("from", "to", "amount");
    });
  });
  group("NFT", () {
    late NftMarketplaceImpl nft;

    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      await dotenv.load(fileName: ".env.development");
      // nft = NftMarketplaceImpl(null, null, null);
      // await nft.initWeb3();
    });
  });
}
