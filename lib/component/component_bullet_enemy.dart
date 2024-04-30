import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import '../game_core.dart';
import 'component_ex.dart';

/// 敵機弾・コンポーネント
class ComponentBulletEnemy extends CircleComponent
    with CollisionCallbacks, HasGameRef<GameCore>
    implements ComponentEx {
  /// 弾のサイズ
  final double _size = 10.0;

  /// 弾の移動量
  late Vector2 _delta;

  /// 初期座標
  late Vector2 _loc;

  /// コンストラクタ
  ComponentBulletEnemy(this._loc) : super();

  /// Component種別を返却
  @override
  GameComponentType getType() {
    return GameComponentType.typeEnemyBullet;
  }

  /// 初期処理
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // サイズとポジションを決定
    size = Vector2(_size, _size);
    anchor = Anchor.center;
    position = _loc;

    // 初期移動量を決定
    Vector2 posDiff = gameRef.charPlayer.position - position;
    double shahenLongPerBaseSpeed =
        sqrt(posDiff.x * posDiff.x + posDiff.y * posDiff.y) /
            3; // 3 = baseSpeed;

    _delta = posDiff / shahenLongPerBaseSpeed;

    // 色は白
    setColor(Colors.red);

    // 円形の当たり判定を設定
    add(CircleHitbox());
  }

  /// 更新ハンドラ
  @override
  void update(double delta) {
    // ゲーム停止中なら、何もしない
    if (!gameRef.isRunning) {
      return;
    }

    super.update(delta);

    // 移動量に従って表示位置更新
    position += _delta * delta * 100;
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
    if (other is ScreenHitbox) {
      gameRef.remove(this);
    } else {
      switch (type) {
        case GameComponentType.typePlayer:
          gameRef.remove(this);
          break;
        default:
          break;
      }
    }
  }
}
