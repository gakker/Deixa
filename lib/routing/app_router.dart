import 'package:auto_route/auto_route.dart';
import 'package:deixa/presentation/screens/authentication/pincode/create_pin_code.dart';
import 'package:deixa/presentation/screens/authentication/seedphrase/create_seed_phrase.dart';
import 'package:deixa/presentation/screens/deixa_media/pages/details/page/deixa_media_details_screen.dart';
import 'package:deixa/presentation/screens/deixa_media/pages/scrollable_list/page/deixa_media_scrollable_list_screen.dart';
import 'package:deixa/presentation/screens/cloud_backup/page/cloud_backup_screen.dart';
import 'package:deixa/presentation/screens/drawer/about.dart';
import 'package:deixa/presentation/screens/drawer/account/account_screen.dart';
import 'package:deixa/presentation/screens/drawer/community.dart';
import 'package:deixa/presentation/screens/drawer/phone2FA/2fa_screen.dart';
import 'package:deixa/presentation/screens/drawer/phone2FA/phone_2fa.dart';
import 'package:deixa/presentation/screens/drawer/preferences.dart';
import 'package:deixa/presentation/screens/drawer/security.dart';
import 'package:deixa/presentation/screens/my_certificate/my_certificate_screen.dart';
import 'package:deixa/presentation/screens/nft/nft_user_detail.dart';
import 'package:deixa/presentation/screens/nftMarketplace/nft_detail_view.dart';
import 'package:deixa/presentation/screens/podcasts/pages/channel/page/podcast_channel_screen.dart';
import 'package:deixa/presentation/screens/podcasts/pages/channels_list/page/podcast_channels_list_screen.dart';

import 'package:deixa/presentation/screens/screens.dart';
import 'package:deixa/presentation/screens/survey/page/reward_survey_screen.dart';
import 'package:deixa/presentation/screens/wallet_screens/secure_your_wallet.dart';
import 'package:deixa/presentation/screens/wallet_screens/wallet_home_screen.dart';
import 'package:injectable/injectable.dart';

import '../presentation/screens/Avatar/Avatar.dart';
import '../presentation/screens/Community/community.dart';
import '../presentation/screens/authentication/forgot_password.dart';
import '../presentation/screens/authentication/reset_password.dart';
import '../presentation/screens/authentication/seedphrase/verify_seed_phrase.dart';
import '../presentation/screens/content/page/content_screen.dart';
import '../presentation/screens/events/pages/details/page/event_detail.dart';
import '../presentation/screens/podcasts/pages/episode/page/podcast_episode_screen.dart';
import '../presentation/screens/rewards/rewards.dart';
import '../presentation/screens/sendCrypto/coinDetail/send_coin_detail.dart';

// flutter packages pub run build_runner watch --delete-conflicting-outputs
@MaterialAutoRouter(
  replaceInRouteName: 'Screen,Route',
  routes: <AutoRoute<dynamic>>[
    AutoRoute<void>(
      page: BuySellCryptoScreen,
    ),
    AutoRoute<void>(page: SplashScreen, initial: true),
    AutoRoute<void>(page: StartScreen),
    AutoRoute<void>(page: OnBoardingScreen),
    AutoRoute<void>(page: AppMiddleWareScreen),
    AutoRoute<void>(page: OTPLockScreen),
    AutoRoute<void>(page: HomeScreen),
    AutoRoute<void>(page: LockScreen),
    AutoRoute<void>(page: BottomNavHomeScreen),
    AutoRoute<void>(page: PortfolioScreen),
    AutoRoute<void>(page: CoinHistoryScreen),
    AutoRoute<void>(page: NotificationsScreen),
    AutoRoute<void>(page: ActivitiesScreen),
    AutoRoute<void>(page: CoinsListScreen),
    AutoRoute<void>(page: ReferralRequestScreen),
    AutoRoute<void>(page: NewsListScreen),
    AutoRoute<void>(page: NewsDetailScreen),
    AutoRoute<void>(page: SendCryptoScreen),
    AutoRoute<void>(page: SendCoinDetailScreen),
    AutoRoute<void>(page: ReceiveCryptoScreen),
    AutoRoute<void>(page: SwapScreen),
    AutoRoute<void>(page: BuySellCryptoScreen),
    AutoRoute<void>(page: ProfileScreen),
    AutoRoute<void>(page: LimitsVerificationScreen),
    AutoRoute<void>(page: KYCScreen),
    AutoRoute<void>(page: TransactionsScreen),
    AutoRoute<void>(page: PreferenceScreen),
    AutoRoute<void>(page: SecurityScreen),
    AutoRoute<void>(page: TwoFAScreen),
    AutoRoute<void>(page: Phone2FAScreen),
    AutoRoute<void>(page: AccountScreen),
    AutoRoute<void>(page: JoinCommunityScreen),
    AutoRoute<void>(page: AboutScreen),
    AutoRoute<void>(page: SignInScreen),
    AutoRoute<void>(page: SignUpScreen),
    AutoRoute<void>(page: SocialLoginScreen),
    AutoRoute<void>(page: AnonymousLoginScreen),
    AutoRoute<void>(page: NFTOwnerDetailScreen),
    AutoRoute<void>(page: AddressScannerScreen),
    AutoRoute<void>(page: MyQrCodeScreen),
    // AutoRoute<void>(page: NFTMarketplaceScreen),
    AutoRoute<void>(page: CreateSeedPhraseScreen),
    AutoRoute<void>(page: VerifySeedPhraseScreen),
    AutoRoute<void>(page: CreatePinCodeScreen),
    AutoRoute<void>(page: NFTDetailScreen),
    AutoRoute(page: RewardSurveyScreen),
    AutoRoute<void>(page: Community),
    AutoRoute<void>(page: AvatarScreen),
    AutoRoute<void>(page: RewardsScreen),
    AutoRoute<void>(page: EventDetailsScreen),
    AutoRoute<void>(page: LockScreen),
    AutoRoute<void>(page: ForgotPasswordScreen),
    AutoRoute<void>(page: ResetPasswordScreen),
    AutoRoute<void>(page: ContentScreen),
    AutoRoute<void>(page: DeixaMediaDetailsScreen),
    AutoRoute<void>(page: DeixaMediaScrollableListScreen),
    AutoRoute<void>(page: PodcastChannelScreen),
    AutoRoute<void>(page: PodcastEpisodeScreen),
    AutoRoute<void>(page: PodcastChannelsListScreen),
    AutoRoute<void>(page: SecureYourWalletScreen),
    AutoRoute<void>(page: MyCertificateScreen),
    AutoRoute<void>(page: CloudBackupScreen),
    AutoRoute<void>(page: WalletHomeScreen),
  ],
)
@Singleton()
class $AppRouter {}
