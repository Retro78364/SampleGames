import 'package:flame/components.dart';

/// スプライト集約クラス
class SpriteCollector {
  /// 自機スプライト
  static late Sprite ownSprite;

  /// 敵機スプライト
  static late List<Sprite> enemys = [];

  /// 透明スプライト
  static late Sprite emptySprite;

  /// 全スプライトをロード
  static Future<void> loadAll() async {
    ownSprite = await Sprite.load("own.png");
    enemys.add(await Sprite.load("enemy0.png"));
    enemys.add(await Sprite.load("enemy1.png"));
    enemys.add(await Sprite.load("enemy2.png"));
    enemys.add(await Sprite.load("enemy3.png"));
    enemys.add(await Sprite.load("enemy4.png"));
    enemys.add(await Sprite.load("enemy5.png"));
    enemys.add(await Sprite.load("enemy6.png"));
    enemys.add(await Sprite.load("enemy7.png"));
    enemys.add(await Sprite.load("enemy8.png"));
    emptySprite = await Sprite.load("empty.png");
  }
}
