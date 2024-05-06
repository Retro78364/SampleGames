import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:isolate';

import 'audio.dart';
import 'time.dart';
import 'sprite_collector.dart';
import 'package:flame_tiled/flame_tiled.dart' as tiled;
import 'page_ending.dart';
import 'stage_controller.dart';
import 'global_info.dart';
import 'component/game_components.dart';

// ゲーム本体
class GameCore extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents {
  /// コンテキスト
  late final BuildContext _context;

  /// コンポーネントのリスト
  late final List<Component> _sprites = [];

  /// ゲーム実行中フラグ（falseで止まる）
  bool _flag = true;

  /// 自機
  late ComponentPlayer charPlayer;

  /// 背景スクロール用の中心に配置する透明スプライト（現状、うまく動作していない）
  late ComponentEmpty _centerSprite;

  /// ゲーム進行制御
  late StageController stageController;

  /// ゲーム進行制御からの通知受け取りポート
  late ReceivePort receivePort;

  /// 時間管理クラス
  late TimerController timerController;

  /// グローバル情報
  late GlobalInfo globalInfo;

  /// コンストラクタ
  /// globalInfo ... グローバル情報
  GameCore(this._context, this.globalInfo) : super() {}

  /// 背景色
  @override
  Color backgroundColor() => const Color(0xffccccff);

  /// 初期処理ハンドラ
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // 弾数制限を初期化
    ComponentBulletPlayer.clearAppendNum();

    timerController = TimerController();
    stageController = StageController();

    await SpriteCollector.loadAll();
    super.add(ScreenHitbox()); // 外枠の当たり判定追加

    // マップ読込・表示
    final tiledMap = await tiled.TiledComponent.load(
        'stg_map.tmx', Vector2.all(globalInfo.baseSize),
        priority: -1);
    add(tiledMap);

    // 画面中心オブジェクト追加
    _centerSprite = ComponentEmpty()
      ..position = size / 2
      ..size = Vector2(2, 2);
    add(_centerSprite);

    // カメラ追従設定
    camera.follow(_centerSprite);
    setMapCenter(Vector2(3, 50));

    // 自機を画面に追加
    charPlayer = ComponentPlayer();
    await add(charPlayer);

    stageController.runStage();

    // ゲーム思考制御からの通知
    // ここで敵を出現させたり、BGMを変更したり、ゲームを制御
    stageController.getEnemyStream().listen((message) async {
      if (message is! String) {
        print("message is! String");
        return;
      }
      if (!_flag) {
        print("!_flag");
        return;
      }

      final strList = message.split(',');

      final enemyMoveType = int.parse(strList[0]);
      if (enemyMoveType < 0) {
        // print("enemyMoveType < 0");
        return;
      } else if (enemyMoveType == 0) {
        // print("enemyMoveType == 0");
        gameOver(true);
        return;
      } else if (enemyMoveType == 999) {
        // print("enemyMoveType == 999");
        AudioManager.stopBgm();
        AudioManager.startBgm(strList[1]);
        return;
      } else if (enemyMoveType == 998) {
        // print("enemyMoveType == 998");
        add(ComponentMessage(strList[1]));
      } else if (enemyMoveType == 997) {
        // print("enemyMoveType == 997");
        removeText();
      }

      final posX = size.x / 2 + (size.x / 2) * double.parse(strList[1]);
      final posY = size.y / 2 + (size.y / 2) * double.parse(strList[2]);

      // 敵機を作成し、画面に追加
      var sp = await ComponentEnemy(enemyMoveType, Vector2(posX, posY));
      add(sp);
    });
  }

  /// コンポーネント（キャラクタ）を追加
  @override
  FutureOr<void> add(Component component) {
    if (component is! tiled.TiledComponent && component is! ComponentEmpty) {
      _sprites.add(component);
    }
    return super.add(component);
  }

  /// コンポーネント（キャラクタ）を削除
  @override
  void remove(Component component) {
    _sprites.remove(component);
    return super.remove(component);
  }

  /// テキストを削除する
  void removeText() {
    List<Component> tempTargetList = [];
    _sprites.forEach((element) {
      if (element is TextComponent) {
        tempTargetList.add(element);
      }
    });

    tempTargetList.forEach((element) {
      remove(element);
    });
  }

  /// ゲーム実行中フラグgetter
  bool get isRunning => _flag;

  /// ゲームオーバー・メソッド
  void gameOver(bool isSuccess) {
    _flag = false;
    AudioManager.stopBgm();
    stageController.gameOvered();
    // 画面にスプライトで終了メッセージを追加
    if (isSuccess) {
      // disposer?.cancel();
      // disposer = null;
      add(ComponentMessage("CLEAR !!"));

      Future.delayed(const Duration(milliseconds: 3000), () {
        Navigator.push(
          _context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => PageEnding(),
            transitionDuration: Duration(seconds: 2),
            transitionsBuilder: (_, a, __, c) =>
                FadeTransition(opacity: a, child: c),
          ),
        );
      });
      if (true) {
        return; // クリア時は、ダイアログ出さずに動画再生へ遷移
      }
    } else {
      add(ComponentMessage("GAME OVER."));
      // リトライ選択ダイアログ表示
      showDialog(
          context: _context,
          barrierDismissible: false,
          builder: (_) {
            return SimpleDialog(
              title: const Text('GAME OVER'),
              children: <Widget>[
                SimpleDialogOption(
                  child: const Text('リトライ'),
                  onPressed: () {
                    Navigator.pop(_context);
                    for (int i = _sprites.length - 1; i >= 0; i--) {
                      remove(_sprites[i]);
                    }
                    // 弾数制限を初期化
                    ComponentBulletPlayer.clearAppendNum();
                    // 自機を画面に追加
                    charPlayer = ComponentPlayer();
                    add(charPlayer);

                    _flag = true;

                    stageController.gameRetry();
                  },
                ),
                SimpleDialogOption(
                  child: const Text('終了'),
                  onPressed: () {
                    Navigator.pop(_context);
                    Navigator.pop(_context);
                  },
                ),
              ],
            );
          });
    }
  }

  /// スコアを追加
  void incrementScore(int score) {
    globalInfo.score += score;
  }

  /// 背景描画位置の更新（現状動作せず）
  void setMapCenter(Vector2 posByBlock) {
    Vector2 posSet = posByBlock * globalInfo.baseSize;
    _centerSprite.position += posSet;
  }
}
