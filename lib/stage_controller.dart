import 'dart:async';
import 'package:pair/pair.dart';
import 'util/csv_util.dart';
import 'package:flutter/services.dart' show rootBundle;

/// ステージ制御
/// とりあえず１面用にしか作成していない。
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
  List<Pair<int, String>> _enemyDataListBase = [];

  /// ステージ進行中フラグ
  bool _isGameRunning = false;

  /// ステージ進行用タイマー
  late StreamController<String> _resultController;

  late final int _stageNumber;

  /// コンストラクタ
  StageController(this._stageNumber) {
    // C++からの応答を通知するためのコントローラ作成
    _resultController = StreamController();
  }

  // C++から通知される敵情報通知ストリームを取得
  Stream<String> getEnemyStream() {
    return _resultController.stream;
  }

  /// ステージ進行開始
  /// stageNumber ... ステージ番号
  Future<void> runStage(int stageNumber) async {
    print("compute - runStageCore START ------------");

    // ステージデータを読み込む
    _enemyDataListBase = await _loadStageData(_stageNumber);

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
    // print("key:${oneEnemy.key} / value:${oneEnemy.value}");

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
    runStage(_stageNumber);
  }

  /// ステージデータを読み込む
  /// stageNumber ... ステージ番号
  Future<List<Pair<int, String>>> _loadStageData(int stageNumber) async {
    List<Pair<int, String>> result = [];

    // assetsからテキストファイルを読込み、文字列をtsvとしてパース
    String data =
        await rootBundle.loadString(_getStageFilePathOfAssets(stageNumber));
    List<List<String>> parsedStringsList =
        await CsvUtil.parse(data, separator: '\t');

    parsedStringsList.forEach((element) {
      // print("element=$element");
      if (element.length != 2) {
        throw FormatException("stage data must be 'time \t string' format");
      }

      int time = int.parse(element[0]);
      result.add(Pair(time, element[1]));
    });

    return result;
  }

  /// ステージデータのファイル名を取得
  /// stageNumber ... ステージ番号
  String _getStageFilePathOfAssets(int stageNumber) {
    return 'assets/stage/stage$stageNumber.txt';
  }
}
