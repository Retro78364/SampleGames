import 'package:audioplayers/audioplayers.dart';

/// 音声管理者クラス
class AudioManager {
  /// BGM用
  static final _audioPlayerBgm = AudioPlayer();

  /// ヒット効果音用
  static final _audioPlayerHit = AudioPlayer();

  /// 被弾用
  static final _audioPlayerMiss = AudioPlayer();

  /// 初期処理
  static void initWork() {
    print('audio start');
    _audioPlayerBgm.setReleaseMode(ReleaseMode.loop);
    _audioPlayerHit.setReleaseMode(ReleaseMode.stop);
    _audioPlayerMiss.setReleaseMode(ReleaseMode.stop);
  }

  /// 利用終了
  static void finishWork() {
    print('audio end');
    _audioPlayerBgm.dispose();
    _audioPlayerHit.dispose();
    _audioPlayerMiss.dispose();
  }

  /// BGM開始
  static void startBgm(String mp3File) {
    _audioPlayerBgm.play(AssetSource(mp3File), volume: 0.5);
  }

  /// BGM停止
  static void stopBgm() {
    _audioPlayerBgm.stop();
  }

  /// ヒット効果音再生
  static void playHit() {
    _audioPlayerHit.stop();
    _audioPlayerHit.play(AssetSource("audio/effect_hit.mp3"), volume: 0.5);
  }

  /// 被弾効果音再生
  static void playMiss() {
    _audioPlayerMiss.play(AssetSource("audio/effect_miss.mp3"), volume: 0.5);
  }
}
