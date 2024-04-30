import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'game_components.dart';
import '../pair.dart';
import '../time.dart';
import '../audio.dart';
import '../game_core.dart';
import '../sprite_collector.dart';

/// 敵機・コンポーネント
class ComponentEnemy extends SpriteComponent
    with CollisionCallbacks, HasGameRef<GameCore> {
  /// 敵種別
  late int _moveType;

  /// ポジション
  late Vector2 _position;

  /// 弾発射Y座標
  late double _fireY;

  /// 撃墜時のスコア値
  late int _ownValue;

  /// 耐久値
  int _life = 1;

  /// 弾発車済みフラグ
  bool isFired = false;

  /// 移動量
  Vector2 _delta = Vector2.zero();

  /// ボスの攻撃パターンの原本
  final List<Pair<int, int>> _bossAttackBase = [
    const Pair(1000, 0),
    const Pair(300, 0),
    const Pair(300, 0),
    const Pair(300, 0),
    const Pair(300, 0),
    const Pair(1000, 1),
    const Pair(300, 1),
    const Pair(300, 1),
    const Pair(300, 1),
    const Pair(300, 1),
    const Pair(1000, 2),
    const Pair(800, 2),
    const Pair(800, 2),
    const Pair(800, 2),
    const Pair(800, 2),
    const Pair(1000, 3),
    const Pair(500, 3),
    const Pair(500, 3),
    const Pair(500, 3),
    const Pair(500, 3),
  ];

  /// ボスの攻撃パターンの実行中情報
  List<Pair<int, int>> _bossAttack = [];

  /// コンストラクタ
  ComponentEnemy(this._moveType, this._position) : super() {
    _life = 1;
    switch (this._moveType) {
      case 1:
        _delta.x = 0;
        _delta.y = 2;
        break;
      case 2:
        _delta.x = -1;
        _delta.y = 1.5;
        break;
      case 3:
        _delta.x = 1;
        _delta.y = 1.5;
        break;
      case 7:
      case 8:
        _life = 100;
        _delta.x = 0;
        _delta.y = 1;
        break;
    }
    _ownValue = 100;
  }

  /// ボス用の攻撃パターンを準備
  void prepareBullet() {
    int baseTime = TimerController.getMillisec();
    _bossAttack.clear();
    _bossAttackBase.forEach((element) {
      baseTime += element.first;
      _bossAttack.add(Pair(baseTime, element.second));
    });
  }

  /// 弾の発射
  void fireBullet(int type) {
    double speed = 1;
    double speedRate = 0;
    double angle = 0;
    double angleRate = 0;
    int bulletNum = 0;
    Color bulletColor = Colors.blueAccent;

    switch (type) {
      case 0:
        speed = 3;
        speedRate = 1;
        angle = 0;
        angleRate = 0;
        bulletNum = 16;
        break;
      case 1:
        speed = 2;
        speedRate = 2;
        angle = 5;
        angleRate = 5;
        bulletNum = 16;
        break;
      case 2:
        speed = 1;
        speedRate = 0;
        angle = 0;
        angleRate = -10;
        bulletNum = 14;
        break;
      case 3:
        speed = 5;
        speedRate = 5;
        angle = 0;
        angleRate = 0;
        bulletNum = 16;
        bulletColor = Colors.purpleAccent;
        break;
    }

    if (gameRef.globalInfo.gameLevel == 0) {
      speed *= 0.7;
      bulletNum = (bulletNum * 7 / 10).toInt();
    }

    double deltaAngle = 360 / bulletNum;
    for (int i = 0; i < bulletNum; i++) {
      double firstAngle = angle + deltaAngle * i;
      gameRef.add(ComponentBulletDanmaku(
          position, angleRate, firstAngle, speedRate, speed, bulletColor));
    }
  }

  /// 初期化処理ハンドラ
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    anchor = Anchor.center;
    position = _position;
    if (_moveType == 7 || _moveType == 8) {
      size = Vector2(
          gameRef.globalInfo.baseSize * 5, gameRef.globalInfo.baseSize * 5);
    } else {
      size = Vector2(gameRef.globalInfo.baseSize, gameRef.globalInfo.baseSize);
    }
    sprite = SpriteCollector.enemys[_moveType];
    angle = pi;
    add(CircleHitbox());

    // あまりギリギリで撃たれると避けれないので
    _fireY = Random().nextDouble() * (gameRef.size.y - _position.y - 80) +
        _position.y;
  }

  /// 更新ハンドラ
  @override
  void update(double delta) {
    // ゲーム停止中なら、何もしない
    if (!gameRef.isRunning) {
      return;
    }

    super.update(delta);

    if (_moveType == 7 || _moveType == 8) {
      if (_delta.y > 0) {
        if (position.y > gameRef.globalInfo.deviceHeight1of4) {
          _delta.y = 0;
          _delta.x = 2;
          // ボスの場合は、定期的に弾発射タイマー開始
          if (this._moveType == 7 || this._moveType == 8) {
            prepareBullet();
          }
        }
      } else if (_delta.x > 0) {
        if (position.x >= gameRef.globalInfo.deviceWidth) {
          _delta.y = 0;
          _delta.x = -2;
        }
      } else if (_delta.x < 0) {
        if (position.x <= 0) {
          _delta.y = 0;
          _delta.x = 2;
        }
      }
    }

    // 移動量に従って表示位置更新
    position += _delta * delta * 100;

    if (_moveType == 7 || _moveType == 8) {
      int current = TimerController.getMillisec();
      if (_bossAttack.length > 0) {
        Pair<int, int> one = _bossAttack[0];
        // 発射予定時間を過ぎていれば、発射
        if (one.first <= current) {
          _bossAttack.removeAt(0);
          fireBullet(one.second);
          // スケジュールが空になった場合は再度繰り返しのスケジュール
          if (_bossAttack.length <= 0) {
            prepareBullet();
          }
        }
      }
      return;
    }

    if (!isFired && _fireY < position.y) {
      isFired = true;
      gameRef.add(ComponentBulletEnemy(position));
    }
  }

  /// 衝突終了ハンドラ
  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    super.onCollision(points, other);

    // ゲーム停止中なら、何もしない
    if (!gameRef.isRunning) {
      return;
    }

    bool isDestroy = false;
    if (other is ComponentBulletPlayer) {
      _life -= 1;
      if (_life <= 0) {
        isDestroy = true;
      }
    }

    AudioManager.playHit();

    if (isDestroy) {
      gameRef.remove(this);
      gameRef.incrementScore(_ownValue);
      if (this._moveType == 7 || this._moveType == 8) {
        gameRef.gameOver(true);
      }
    }
  }
}
