import 'package:audioplayers/audioplayers.dart';

abstract class AudioplayerDataSource {
  Stream<Duration> get onPositionChanged;

  Stream<PlayerState> get onPlayerStateChanged;

  /// Creates a new AudioPlayer object.
  /// If the player already intialized, it disposes the old one and initializes a new one.
  ///
  /// This method needs to be called before invoking any other methods.
  Future<void> init();
  Future<void> setSourceUrl(String url);
  Future<void> play(String url);
  Future<void> pause();
  Future<void> resume();
  Future<void> seek(Duration duration);
  Future<void> stop();
  Future<void> release();

  /// Disposes the player and clears the resources. Now, other audio-related methods will throw an exception if called.
  ///
  /// To be able to use those methods, player needs to be re-initialized by calling [init()].
  Future<void> dispose();
}
