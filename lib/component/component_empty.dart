import 'package:flame/components.dart';
import '../sprite_collector.dart';

/// 画面中心配置の透明コンポーネント
class ComponentEmpty extends SpriteComponent {
  ComponentEmpty() : super();

  /// 初期処理ハンドラ
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    anchor = Anchor.topLeft;
    sprite = SpriteCollector.emptySprite;
    size = Vector2(2, 2);
  }
}
