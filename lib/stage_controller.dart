import 'dart:async';
import 'package:pair/pair.dart';

/// ステージ制御
/// とりあえず１面用にしか作成していない。
/// TODO: 複数ステージ用に切り替えられるように、このクラスがステージ別の情報を複数管理するなど
/// の形式に変更予定
/// NOTE: この部分は元々C++のスレッドで実装しており、Dartでも isolate の compute() を使用
/// して実装してみたが、外部からスレッドを停止させるのがうまく実装できず、タイマーで実装した。
class StageController {
  /// 現在実行中のステージデータ
  List<Pair<int, String>> enemyDataList = [];

  /// ステージデータ原本（リセット時は enemyDataList にこれをコピーする
  /// Pair の 先頭の int 値は全項目からの通知間隔ミリ秒。
  /// 後ろのデータがメイン処理部分に通知され、カンマでパースされ処理が実行される
  /// 基本的に敵出現用（"敵種別,X座標%,Y座標%")だったが、敵種別部分を999にするとBGMを変更
  /// できる等、無理やり拡張している。
  /// TODO: このあたりは整理してリファクタが必要
  final List<Pair<int, String>> _enemyDataListBase = [
    const Pair(1, "999,audio/bgm_stage01.mp3"),
    const Pair(1000, "1,0.8,-1"),
    const Pair(400, "1,0.8,-1"),
    const Pair(400, "1,0.8,-1"),
    const Pair(400, "1,0.8,-1"),
    const Pair(400, "1,0.8,-1"),
    const Pair(400, "1,0.8,-1"),
    const Pair(400, "1,0.8,-1"),
    const Pair(1000, "1,0.0,-1"),
    const Pair(400, "1,0.0,-1"),
    const Pair(400, "1,0.0,-1"),
    const Pair(400, "1,0.0,-1"),
    const Pair(400, "1,0.0,-1"),
    const Pair(400, "1,0.0,-1"),
    const Pair(400, "1,0.0,-1"),
    const Pair(1000, "1,-0.8,-1"),
    const Pair(400, "1,-0.8,-1"),
    const Pair(400, "1,-0.8,-1"),
    const Pair(400, "1,-0.8,-1"),
    const Pair(400, "1,-0.8,-1"),
    const Pair(400, "1,-0.8,-1"),
    const Pair(400, "1,-0.8,-1"),
    const Pair(1000, "1,0.8,-1"),
    const Pair(400, "2,0.8,-1"),
    const Pair(400, "2,0.8,-1"),
    const Pair(400, "2,0.8,-1"),
    const Pair(400, "2,0.8,-1"),
    const Pair(400, "2,0.8,-1"),
    const Pair(400, "2,0.8,-1"),
    const Pair(1000, "1,0.0,-1"),
    const Pair(400, "2,0.0,-1"),
    const Pair(400, "3,0.0,-1"),
    const Pair(400, "2,0.0,-1"),
    const Pair(400, "3,0.0,-1"),
    const Pair(400, "2,0.0,-1"),
    const Pair(400, "3,0.0,-1"),
    const Pair(1000, "3,-0.8,-1"),
    const Pair(400, "3,-0.8,-1"),
    const Pair(400, "3,-0.8,-1"),
    const Pair(400, "3,-0.8,-1"),
    const Pair(400, "3,-0.8,-1"),
    const Pair(400, "3,-0.8,-1"),
    const Pair(400, "3,-0.8,-1"),
    const Pair(1000, "1,0.4,-1"),
    const Pair(400, "1,0.7,-1"),
    const Pair(400, "1,0.2,-1"),
    const Pair(400, "1,0.3,-1"),
    const Pair(400, "1,0.8,-1"),
    const Pair(400, "1,-0.8,-1"),
    const Pair(400, "1,0.2,-1"),
    const Pair(1000, "1,0.0,-1"),
    const Pair(400, "1,-0.4,-1"),
    const Pair(400, "1,-0.6,-1"),
    const Pair(400, "1,-0.4,-1"),
    const Pair(400, "1,-0.6,-1"),
    const Pair(400, "1,0.0,-1"),
    const Pair(400, "1,0.2,-1"),
    const Pair(1000, "1,-0.8,-1"),
    const Pair(400, "1,-0.2,-1"),
    const Pair(400, "1,-0.3,-1"),
    const Pair(400, "1,-0.4,-1"),
    const Pair(400, "1,-0.5,-1"),
    const Pair(400, "1,-0.1,-1"),
    const Pair(400, "1,-0.3,-1"),
    const Pair(1000, "1,0.1,-1"),
    const Pair(400, "2,-0.7,-1"),
    const Pair(400, "2,0.2,-1"),
    const Pair(400, "2,-0.1,-1"),
    const Pair(400, "2,0.1,-1"),
    const Pair(400, "2,-0.3,-1"),
    const Pair(400, "2,0.8,-1"),
    const Pair(1000, "1,0.0,-1"),
    const Pair(400, "2,0.0,-1"),
    const Pair(400, "3,0.3,-1"),
    const Pair(400, "2,-0.3,-1"),
    const Pair(400, "3,0.2,-1"),
    const Pair(400, "2,0.0,-1"),
    const Pair(400, "3,-0.9,-1"),
    const Pair(1000, "3,-0.8,-1"),
    const Pair(400, "3,-0.4,-1"),
    const Pair(400, "3,0.8,-1"),
    const Pair(400, "3,-0.2,-1"),
    const Pair(400, "3,0.8,-1"),
    const Pair(400, "3,0.1,-1"),
    const Pair(400, "3,-0.3,-1"),
    const Pair(3000, "999,audio/bgm_warning.mp3"),
    const Pair(1, "998,WARNING!"),
    const Pair(500, "997, "),
    const Pair(500, "998,WARNING!"),
    const Pair(500, "997, "),
    const Pair(500, "998,WARNING!"),
    const Pair(500, "997, "),
    const Pair(500, "998,WARNING!"),
    const Pair(500, "997, "),
    const Pair(1, "999,audio/bgm_stage01_boss.mp3"),
    const Pair(1000, "7,0,-1"),
  ];

  /// ステージ進行中フラグ
  bool _isGameRunning = false;

  /// ステージ進行用タイマー
  late StreamController<String> _resultController;

  /// コンストラクタ
  StageController() {
    // C++からの応答を通知するためのコントローラ作成
    _resultController = StreamController();
  }

  // C++から通知される敵情報通知ストリームを取得
  Stream<String> getEnemyStream() {
    return _resultController.stream;
  }

  /// ステージ進行開始
  Future<void> runStage() async {
    print("compute - runStageCore START ------------");

    _isGameRunning = true;

    // 敵データを初期化
    enemyDataList = []..addAll(_enemyDataListBase);

    _setTimerToNext();
  }

  _setTimerToNext() {
    Pair<int, String> oneEnemy;
    if (enemyDataList.isEmpty) {
      return;
    }

    // 先頭要素を取得して取り除く
    oneEnemy = enemyDataList[0];
    enemyDataList.removeAt(0);
    print("key:${oneEnemy.key} / value:${oneEnemy.value}");

    Future.delayed(Duration(milliseconds: oneEnemy.key), () {
      if (!_isGameRunning) {
        return;
      }

      _resultController.sink.add(oneEnemy.value);

      _setTimerToNext();
    });
  }

  /// ゲームオーバー実行
  void gameOvered() {
    _isGameRunning = false;
  }

  /// ゲームリトライ実行
  void gameRetry() {
    runStage();
  }
}
