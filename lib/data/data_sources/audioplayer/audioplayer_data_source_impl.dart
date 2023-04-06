import 'package:audioplayers/audioplayers.dart';
import 'package:deixa/domain/data_sources/audioplayer/audioplayer_data_source.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: AudioplayerDataSource)
class AudioplayerDataSourceImpl implements AudioplayerDataSource {
  AudioPlayer? _player = AudioPlayer();

  @override
  Future<void> init() async {
    dispose();
    _player = AudioPlayer();
  }

  @override
  Future<void> setSourceUrl(String url) async => _player!.setSourceUrl(url);

  @override
  Future<void> pause() async => _player!.pause();

  @override
  Future<void> play(String url) async => _player!.play(UrlSource(url));

  @override
  Future<void> stop() async => _player!.stop();

  @override
  Future<void> seek(Duration duration) async => _player!.seek(duration);

  @override
  Future<void> resume() async => _player!.resume();

  @override
  Future<void> release() async => _player!.release();

  @override
  Stream<Duration> get onPositionChanged => _player!.onPositionChanged;

  @override
  Stream<PlayerState> get onPlayerStateChanged => _player!.onPlayerStateChanged;

  @override
  Future<void> dispose() async => _player?.dispose();
}
