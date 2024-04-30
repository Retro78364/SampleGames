import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../game_core.dart';

/// メッセージ表示・コンポーネント
class ComponentMessage extends TextComponent with HasGameRef<GameCore> {
  /// 表示するメッセージ
  late String _message;

  /// コンストラクタ
  ComponentMessage(this._message) : super();

  /// 初期処理ハンドラ
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    anchor = Anchor.center;
    position = Vector2(gameRef.canvasSize.x / 2, gameRef.canvasSize.y / 2);
    text = _message;
    textRenderer = TextPaint(
      style: const TextStyle(
        fontSize: 80.0,
        fontWeight: FontWeight.w600,
        color: Colors.red,
      ),
    );
  }
}
