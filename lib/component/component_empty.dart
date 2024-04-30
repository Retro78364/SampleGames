import 'package:flame/components.dart';
import '../sprite_collector.dart';
import 'component_ex.dart';

/// 画面中心配置の透明コンポーネント
class ComponentEmpty extends SpriteComponent implements ComponentEx {
  ComponentEmpty() : super();

  /// Component種別を返却
  @override
  GameComponentType getType() {
    return GameComponentType.typeUnknown;
  }

  /// 初期処理ハンドラ
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    anchor = Anchor.topLeft;
    sprite = SpriteCollector.emptySprite;
    size = Vector2(2, 2);
  }
}
