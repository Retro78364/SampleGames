import 'dart:async';

/// 時間関連処理制御クラス
class TimerController {
  // タイマー
  late Timer? timer;

  /// タイマー開始
  /// duration ... タイマー発火までの時間（ミリ秒）
  /// callback ... コールバック
  void startTime(int duration, void Function() callback) {
    timer = Timer.periodic(Duration(milliseconds: duration), (Timer _) {
      callback();
    });
  }

  /// タイマーストップ
  void stop() {
    timer?.cancel();
  }

  /// 現在時間を数値で取得（ミリ秒）
  static int getMillisec() {
    return DateTime.now().millisecondsSinceEpoch;
  }
}
