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
          globalInfo.touchBaseX = details.localPosition.dx;
          globalInfo.touchBaseY = details.localPosition.dy;
          _calcTouchPos(details.localPosition);
        },
        onPointerUp: (PointerEvent details) {
          _calcTouchPos(details.localPosition);
        },
        onPointerCancel: (PointerEvent details) {
          _calcTouchPos(details.localPosition);
        },
      ),
    );
  }

  /// タッチ座標更新
  void _calcTouchPos(Offset currentPos) {
    globalInfo.touchPosX =
        globalInfo.touchPosX + currentPos.dx - globalInfo.touchBaseX;
    globalInfo.touchPosY =
        globalInfo.touchPosY + currentPos.dy - globalInfo.touchBaseY;
    globalInfo.touchBaseX = currentPos.dx;
    globalInfo.touchBaseY = currentPos.dy;
  }
}
