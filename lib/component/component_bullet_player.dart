import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';

import '../game_core.dart';
import 'game_components.dart';
import 'component_ex.dart';

/// 自機弾・コンポーネント
class ComponentBulletPlayer extends CircleComponent
    with CollisionCallbacks, HasGameRef<GameCore>
    implements ComponentEx {
  /// 弾のサイズ
  var _size = 10.0;

  /// 弾の移動量
  late Vector2 _delta;

  /// 初期位置
  late Vector2 _loc;

  /// コンストラクタ
  ComponentBulletPlayer(this._loc) : super();

  /// Component種別を返却
  @override
  GameComponentType getType() {
    return GameComponentType.typePlayerBullet;
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
    _delta = Vector2(0, -5);

    // 色は白
    setColor(Colors.white);

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

    // 弾が外枠に接触
    if (other is ScreenHitbox) {
      gameRef.remove(this);
    }

    final GameComponentType type = other is ComponentEx
        ? (other as ComponentEx).getType()
        : GameComponentType.typeUnknown;

    // 弾が外枠に接触
    if (other is ScreenHitbox) {
      gameRef.remove(this);
    } else {
      switch (type) {
        case GameComponentType.typeEnemy:
          // 弾が敵機に接触
          gameRef.remove(this);
          break;
        default:
          break;
      }
    }
  }
}
