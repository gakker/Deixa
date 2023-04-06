// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart' as _i18;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../data/data_sources/audioplayer/audioplayer_data_source_impl.dart'
    as _i5;
import '../data/data_sources/content/content_data_store_impl.dart' as _i7;
import '../data/data_sources/deixa_media/deixa_media_data_source_impl.dart'
    as _i11;
import '../data/data_sources/dynamic_link/dynamic_link_data_source_impl.dart'
    as _i44;
import '../data/data_sources/events/events_data_source_impl.dart' as _i15;
import '../data/data_sources/google_drive/google_drive_data_source_impl.dart'
    as _i25;
import '../data/data_sources/podcast/podcast_data_source_impl.dart' as _i27;
import '../data/data_sources/push_notifications/push_notifications_data_source_impl.dart'
    as _i31;
import '../data/repository/cloud_backup/cloud_backup_repository_impl.dart'
    as _i41;
import '../data/repository/contents/content_repository_impl.dart' as _i9;
import '../data/repository/deixa_media/deixa_media_repository_impl.dart'
    as _i13;
import '../data/repository/dynamic_links/dynamic_links_repository_impl.dart'
    as _i46;
import '../data/repository/events/events_repository_impl.dart' as _i17;
import '../data/repository/podcast/podcast_repository_impl.dart' as _i29;
import '../data/repository/push_notifications/push_notifications_repository_impl.dart'
    as _i33;
import '../domain/data_sources/audioplayer/audioplayer_data_source.dart' as _i4;
import '../domain/data_sources/content/content_data_source.dart' as _i6;
import '../domain/data_sources/deixa_media/deixa_media_data_source.dart'
    as _i10;
import '../domain/data_sources/dynamic_links/dynamic_links_data_source.dart'
    as _i43;
import '../domain/data_sources/events/events_data_source.dart' as _i14;
import '../domain/data_sources/google_drive/google_drive_data_source.dart'
    as _i24;
import '../domain/data_sources/podcast/podcast_data_source.dart' as _i26;
import '../domain/data_sources/push_notifications/push_notifications_data_source.dart'
    as _i30;
import '../domain/repositories/cloud_backup/cloud_backup_repository.dart'
    as _i40;
import '../domain/repositories/contents/contents_repository.dart' as _i8;
import '../domain/repositories/deixa_media/deixa_media_repository.dart' as _i12;
import '../domain/repositories/dynamic_links/dynamic_links_repository.dart'
    as _i45;
import '../domain/repositories/events/events_repository.dart' as _i16;
import '../domain/repositories/podcast/podcast_repository.dart' as _i28;
import '../domain/repositories/push_notifications/push_notification_repository.dart'
    as _i32;
import '../domain/usecases/cloud_backup/get_current_user_cloud_backup_use_case.dart'
    as _i47;
import '../domain/usecases/cloud_backup/get_export_key_to_cloud_backup_use_case.dart'
    as _i48;
import '../domain/usecases/cloud_backup/get_import_key_from_cloud_backup_use_case.dart'
    as _i49;
import '../domain/usecases/cloud_backup/get_sign_in_cloud_backup_use_case.dart'
    as _i56;
import '../domain/usecases/cloud_backup/get_sign_out_cloud_backup_use_case.dart'
    as _i57;
import '../domain/usecases/content/get_content_by_slug_use_case.dart' as _i20;
import '../domain/usecases/deixa_media/get_deixa_media_item_use_case.dart'
    as _i21;
import '../domain/usecases/deixa_media/get_deixa_media_use_case.dart' as _i22;
import '../domain/usecases/dynamic_links/create_dynamic_link_use_case.dart'
    as _i63;
import '../domain/usecases/dynamic_links/on_dyanamic_links_callback_use_case.dart'
    as _i60;
import '../domain/usecases/events/get_all_events_by_all_categories_usecase.dart'
    as _i19;
import '../domain/usecases/events/get_event_by_Id_use_case.dart' as _i23;
import '../domain/usecases/podcast/dispose_podcast_audio_player_use_case.dart'
    as _i42;
import '../domain/usecases/podcast/get_on_podcast_player_state_changed_stream_use_case.dart'
    as _i50;
import '../domain/usecases/podcast/get_on_posistion_changed_podcast_episode_use_case.dart'
    as _i51;
import '../domain/usecases/podcast/get_podcast_channel_by_id_use_case.dart'
    as _i52;
import '../domain/usecases/podcast/get_podcast_channels_use_case.dart' as _i53;
import '../domain/usecases/podcast/get_podcast_episode_by_id_use_case.dart'
    as _i54;
import '../domain/usecases/podcast/get_podcast_episodes_by_channel_use_case.dart'
    as _i55;
import '../domain/usecases/podcast/init_podcast_audio_player_use_case.dart'
    as _i58;
import '../domain/usecases/podcast/pause_podcast_episode_use_case.dart' as _i61;
import '../domain/usecases/podcast/play_podcast_episode_use_case.dart' as _i62;
import '../domain/usecases/podcast/resume_podcast_episode_use_case.dart'
    as _i34;
import '../domain/usecases/podcast/seek_podcast_episode_use_case.dart' as _i35;
import '../domain/usecases/podcast/stop_podcast_episode_use_case.dart' as _i37;
import '../domain/usecases/push_notifications/init_push_notifications_use_case.dart'
    as _i59;
import '../domain/usecases/push_notifications/show_local_notification_use_case.dart'
    as _i36;
import '../domain/usecases/push_notifications/subscribe_to_firebase_messaging_topics_use_case.dart'
    as _i38;
import '../domain/usecases/push_notifications/unsubscribe_from_firebase_messaging_topics_use_case.dart'
    as _i39;
import '../routing/app_router.dart' as _i3;
import 'modules/firebase_dynamic_links_module.dart'
    as _i64; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(
  _i1.GetIt get, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(
    get,
    environment,
    environmentFilter,
  );
  final firebaseDynamicLinksModule = _$FirebaseDynamicLinksModule();
  gh.singleton<_i3.$AppRouter>(_i3.$AppRouter());
  gh.singleton<_i4.AudioplayerDataSource>(_i5.AudioplayerDataSourceImpl());
  gh.singleton<_i6.ContentDataSource>(_i7.ContentsDataSourceImpl());
  gh.singleton<_i8.ContentRepository>(
      _i9.ContentRepositoryImpl(get<_i6.ContentDataSource>()));
  gh.singleton<_i10.DeixaMediaDataSource>(_i11.DeixaMediaDataSourceImpl());
  gh.singleton<_i12.DeixaMediaRepository>(
      _i13.DeixaMediaRepositoryImpl(get<_i10.DeixaMediaDataSource>()));
  gh.singleton<_i14.EventsDataSource>(_i15.EventsDataSourceImpl());
  gh.singleton<_i16.EventsRepository>(
      _i17.EventsRepositoryImpl(get<_i14.EventsDataSource>()));
  gh.factory<_i18.FirebaseDynamicLinks>(
      () => firebaseDynamicLinksModule.firebaseDynamicLinks);
  gh.factory<_i19.GetAllEventsByAllCategoriesUseCase>(() =>
      _i19.GetAllEventsByAllCategoriesUseCase(get<_i16.EventsRepository>()));
  gh.factory<_i20.GetContentBySlugUseCase>(
      () => _i20.GetContentBySlugUseCase(get<_i8.ContentRepository>()));
  gh.factory<_i21.GetDeixaMediaItemUseCase>(
      () => _i21.GetDeixaMediaItemUseCase(get<_i12.DeixaMediaRepository>()));
  gh.factory<_i22.GetDeixaMediaUseCase>(
      () => _i22.GetDeixaMediaUseCase(get<_i12.DeixaMediaRepository>()));
  gh.factory<_i23.GetEventByIdUseCase>(
      () => _i23.GetEventByIdUseCase(get<_i16.EventsRepository>()));
  gh.singleton<_i24.GoogleDriveDataSource>(_i25.GoogleDriveDataSourceImpl());
  gh.singleton<_i26.PodcastDataSource>(_i27.PodcastDataSourceImpl());
  gh.singleton<_i28.PodcastRepository>(_i29.PodcastRepositoryImpl(
    get<_i26.PodcastDataSource>(),
    get<_i4.AudioplayerDataSource>(),
  ));
  gh.singleton<_i30.PushNotificationDataSource>(
      _i31.PushNotificationDataSourceImpl());
  gh.singleton<_i32.PushNotificationRepository>(
      _i33.PushNotificationsRepositoryImpl(
          get<_i30.PushNotificationDataSource>()));
  gh.factory<_i34.ResumePodcastAudioPlayerUseCase>(() =>
      _i34.ResumePodcastAudioPlayerUseCase(get<_i28.PodcastRepository>()));
  gh.factory<_i35.SeekPodcastAudioPlayerUseCase>(
      () => _i35.SeekPodcastAudioPlayerUseCase(get<_i28.PodcastRepository>()));
  gh.factory<_i36.ShowLocalNotificationUseCase>(() =>
      _i36.ShowLocalNotificationUseCase(
          get<_i32.PushNotificationRepository>()));
  gh.factory<_i37.StopPodcastAudioPlayerUseCase>(
      () => _i37.StopPodcastAudioPlayerUseCase(get<_i28.PodcastRepository>()));
  gh.factory<_i38.SubscribeToFirebaseMessagingTopicsUseCase>(() =>
      _i38.SubscribeToFirebaseMessagingTopicsUseCase(
          get<_i32.PushNotificationRepository>()));
  gh.factory<_i39.UnsubscribeToFirebaseMessagingTopicsUseCase>(() =>
      _i39.UnsubscribeToFirebaseMessagingTopicsUseCase(
          get<_i32.PushNotificationRepository>()));
  gh.singleton<_i40.CloudBackupRepository>(
      _i41.CloudBackupRepositoryImpl(get<_i24.GoogleDriveDataSource>()));
  gh.factory<_i42.DisposePodcastAudioPlayerUseCase>(() =>
      _i42.DisposePodcastAudioPlayerUseCase(get<_i28.PodcastRepository>()));
  gh.singleton<_i43.DynamicLinksDataSource>(
      _i44.DynamicLinksDataSourceImpl(get<_i18.FirebaseDynamicLinks>()));
  gh.singleton<_i45.DynamicLinksRepository>(
      _i46.DynamicLinksRepositoryImpl(get<_i43.DynamicLinksDataSource>()));
  gh.factory<_i47.GetCurrentUserCloudBackupUseCase>(() =>
      _i47.GetCurrentUserCloudBackupUseCase(get<_i40.CloudBackupRepository>()));
  gh.factory<_i48.GetExportKeyToCloudBackupUseCase>(() =>
      _i48.GetExportKeyToCloudBackupUseCase(get<_i40.CloudBackupRepository>()));
  gh.factory<_i49.GetImportKeyToCloudBackupUseCase>(() =>
      _i49.GetImportKeyToCloudBackupUseCase(get<_i40.CloudBackupRepository>()));
  gh.factory<_i50.GetOnPodcastPlayerStateChangedStreamUseCase>(() =>
      _i50.GetOnPodcastPlayerStateChangedStreamUseCase(
          get<_i28.PodcastRepository>()));
  gh.factory<_i51.GetOnPositionedChangedAudioPlayerUseCase>(() =>
      _i51.GetOnPositionedChangedAudioPlayerUseCase(
          get<_i28.PodcastRepository>()));
  gh.factory<_i52.GetPodcastChannelByIdUseCase>(
      () => _i52.GetPodcastChannelByIdUseCase(get<_i28.PodcastRepository>()));
  gh.factory<_i53.GetPodcastChannelsUseCase>(
      () => _i53.GetPodcastChannelsUseCase(get<_i28.PodcastRepository>()));
  gh.factory<_i54.GetPodcastEpisodeByIdUseCase>(
      () => _i54.GetPodcastEpisodeByIdUseCase(get<_i28.PodcastRepository>()));
  gh.factory<_i55.GetPodcastEpisodesByChannel>(
      () => _i55.GetPodcastEpisodesByChannel(get<_i28.PodcastRepository>()));
  gh.factory<_i56.GetSignInCloudBackupUseCase>(() =>
      _i56.GetSignInCloudBackupUseCase(get<_i40.CloudBackupRepository>()));
  gh.factory<_i57.GetSignOutCloudBackupUseCase>(() =>
      _i57.GetSignOutCloudBackupUseCase(get<_i40.CloudBackupRepository>()));
  gh.factory<_i58.InitPodcastAudioPlayerUseCase>(
      () => _i58.InitPodcastAudioPlayerUseCase(get<_i28.PodcastRepository>()));
  gh.factory<_i59.InitPushNotificaionsUseCase>(() =>
      _i59.InitPushNotificaionsUseCase(get<_i32.PushNotificationRepository>()));
  gh.factory<_i60.OnDynamicLinkCallbackUseCase>(() =>
      _i60.OnDynamicLinkCallbackUseCase(get<_i45.DynamicLinksRepository>()));
  gh.factory<_i61.PausePodcastAudioPlayerUseCase>(
      () => _i61.PausePodcastAudioPlayerUseCase(get<_i28.PodcastRepository>()));
  gh.factory<_i62.PlayPodcastAudioPlayerUseCase>(
      () => _i62.PlayPodcastAudioPlayerUseCase(get<_i28.PodcastRepository>()));
  gh.factory<_i63.CreateDynamicLinkUseCase>(
      () => _i63.CreateDynamicLinkUseCase(get<_i45.DynamicLinksRepository>()));
  return get;
}

class _$FirebaseDynamicLinksModule extends _i64.FirebaseDynamicLinksModule {}
