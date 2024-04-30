import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import '../game_core.dart';
import 'game_components.dart';

/// 敵機の弾幕・コンポーネント
class ComponentBulletDanmaku extends CircleComponent
    with CollisionCallbacks, HasGameRef<GameCore> {
  /// 弾のサイズ
  var _size = 20.0;

  /// 弾の移動量
  late Vector2 _delta = Vector2.zero();

  /// 弾の初期位置
  late Vector2 _loc;

  /// 弾の角速度
  late double _angleRate;

  /// 弾の角度
  late double _angle;

  /// 加速度
  late double _speedRate;

  /// 速度
  late double _speed;

  /// 弾色
  late Color _color;

  /// コンストラクタ
  ComponentBulletDanmaku(
    this._loc,
    this._angleRate,
    this._angle,
    this._speedRate,
    this._speed,
    this._color,
  ) : super() {}

  /// 初期処理
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // サイズとポジションを決定
    size = gameRef.globalInfo.gameLevel == 0
        ? Vector2(_size / 2, _size / 2)
        : Vector2(_size, _size);
    anchor = Anchor.center;
    position = _loc;

    // 色は白
    setColor(_color);

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

    // 移動量を算出
    double radian = _angle * pi / 180;
    _delta.x = _speed * cos(radian);
    _delta.y = _speed * sin(radian);

    // 移動量に従って表示位置更新
    position += _delta * delta * 100;

    // 速度・角度を更新
    _speed += _speedRate * delta;
    _angle += _angleRate * delta;
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
    } else if (other is ComponentPlayer) {
      gameRef.remove(this);
    }
  }
}
