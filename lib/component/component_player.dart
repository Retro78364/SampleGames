import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/services.dart';

import 'game_components.dart';
import '../time.dart';
import '../audio.dart';
import '../game_core.dart';
import '../sprite_collector.dart';
import 'component_ex.dart';

/// 自機・コンポーネント
class ComponentPlayer extends SpriteComponent
    with CollisionCallbacks, KeyboardHandler, HasGameRef<GameCore>
    implements ComponentEx {
  /// 移動量
  Vector2 _delta = Vector2.zero();

  /// 半分サイズ
  late Vector2 halfSize;

  /// 時間管理オブジェクト
  TimerController timer = TimerController();

  /// Component種別を返却
  @override
  GameComponentType getType() {
    return GameComponentType.typePlayer;
  }

  /// 初期処理ハンドラ
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    anchor = Anchor.center;
    sprite = SpriteCollector.ownSprite;
    size = gameRef.globalInfo.gameLevel == 0
        ? Vector2(
            gameRef.globalInfo.baseSize / 2, gameRef.globalInfo.baseSize / 2)
        : Vector2(gameRef.globalInfo.baseSize, gameRef.globalInfo.baseSize);
    halfSize = size / 2;
    // 初期位置指定
    gameRef.globalInfo.touchPosX = gameRef.canvasSize.x / 2 - 50;
    gameRef.globalInfo.touchPosY = gameRef.canvasSize.y / 5 * 4;
    position =
        Vector2(gameRef.globalInfo.touchPosX, gameRef.globalInfo.touchPosY);
    // 矩形当たり判定設定
    add(CircleHitbox());

    timer.startTime(200, () {
      gameRef.add(ComponentBulletPlayer(position));
    });
  }

  /// 更新ハンドラ
  @override
  void update(double delta) {
    if (!gameRef.isRunning) {
      return;
    }

    gameRef.setMapCenter(Vector2(0, -1) * delta);

    updateDeltaByTap();
    super.update(delta);
  }

  /// タップによる自機の移動
  void updateDeltaByTap() {
    position =
        Vector2(gameRef.globalInfo.touchPosX, gameRef.globalInfo.touchPosY);
  }

  /// キーイベントハンドラ
  @override
  bool onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (!gameRef.isRunning) {
      return false;
    }
    if (event is RawKeyUpEvent) {
      _delta = Vector2.zero();
    }
    if (event.character == 'j') {
      _delta.x = -3;
    }
    if (event.character == 'l') {
      _delta.x = 3;
    }
    return true;
  }

  /// 衝突ハンドラ
  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    super.onCollision(points, other);

    // ゲーム停止中なら、何もしない
    if (!gameRef.isRunning) {
      return;
    }

    final GameComponentType type = other is ComponentEx
        ? (other as ComponentEx).getType()
        : GameComponentType.typeUnknown;

    // 弾が外枠に接触
    switch (type) {
      case GameComponentType.typeEnemy:
      case GameComponentType.typeEnemyBullet:
        // 自機が敵・敵弾に接触
        timer.stop();
        gameRef.gameOver(false);
        AudioManager.playMiss();
        break;
      default:
        break;
    }
  }
}
