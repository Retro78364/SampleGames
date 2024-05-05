import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'global_info.dart';
import 'game_core.dart';

/// ゲーム画面
class PageGame extends StatefulWidget {
  int? gameLevel;

  /// コンストラクタ
  /// 第二引数でゲームレベル指定
  PageGame({Key? key, this.gameLevel}) : super(key: key);

  /// ステート生成
  @override
  State createState() => _PageGameState(gameLevel);
}

/// ゲーム画面ステート
class _PageGameState extends State<PageGame> {
  int? _gameLevel;
  late GlobalInfo globalInfo;

  /// コンストラクタ
  _PageGameState(this._gameLevel);

  /// UI再構築
  @override
  Widget build(BuildContext context) {
    // グローバル情報を作成し、サイズ関連情報を算出
    globalInfo = GlobalInfo();
    globalInfo.gameLevel = _gameLevel ?? 1;
    globalInfo.deviceWidth = MediaQuery.of(context).size.width;
    globalInfo.deviceHeight = MediaQuery.of(context).size.height;
    globalInfo.deviceHeight3of4 = globalInfo.deviceHeight * 0.75;
    globalInfo.deviceHeight1of4 = globalInfo.deviceHeight * 0.25;
    final int devideNum = 12;
    globalInfo.baseSize = (globalInfo.deviceWidth < globalInfo.deviceHeight)
        ? globalInfo.deviceWidth / devideNum
        : globalInfo.deviceHeight / devideNum;
    globalInfo.halfX = globalInfo.deviceWidth / 2;
    globalInfo.moveMagnification = 1.4;

    return new Scaffold(
      // appBar: new AppBar(
      //   title: new Text('SCORE : ${score}'),
      // ),
      body: Listener(
        child: GameWidget(game: GameCore(context, globalInfo)),
        onPointerMove: (PointerEvent details) {
          _calcTouchPos(details.localPosition);
        },
        onPointerDown: (PointerEvent details) {
          // タッチ基本座標・タッチ時の自機位置を更新
          globalInfo.touchBaseX = details.localPosition.dx;
          globalInfo.touchBaseY = details.localPosition.dy;
          globalInfo.playerPosXOnTouchDown = globalInfo.touchPosX;
          globalInfo.playerPosYOnTouchDown = globalInfo.touchPosY;
        },
      ),
    );
  }

  /// タッチ座標更新
  void _calcTouchPos(Offset currentPos) {
    // タッチダウン座標からの差分を移動距離倍率を考慮して現在座標に反映
    double diffX = currentPos.dx - globalInfo.touchBaseX;
    double diffY = currentPos.dy - globalInfo.touchBaseY;
    diffX *= globalInfo.moveMagnification;
    diffY *= globalInfo.moveMagnification;
    globalInfo.touchPosX = globalInfo.playerPosXOnTouchDown + diffX;
    globalInfo.touchPosY = globalInfo.playerPosYOnTouchDown + diffY;
    // 画面外には飛び出さないよう補正
    if (globalInfo.touchPosX < 0) {
      globalInfo.touchPosX = 0;
    } else if (globalInfo.touchPosX > globalInfo.deviceWidth) {
      globalInfo.touchPosX = globalInfo.deviceWidth;
    }
    if (globalInfo.touchPosY < 0) {
      globalInfo.touchPosY = 0;
    } else if (globalInfo.touchPosY > globalInfo.deviceHeight) {
      globalInfo.touchPosY = globalInfo.deviceHeight;
    }
  }
}
