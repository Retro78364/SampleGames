/// Component種別
/// 敵用クラスが追加されても、この種別を返すようにすることで衝突判定などではtypeの分岐だけで
/// すむようにしたい。
enum GameComponentType {
  typeUnknown,
  typePlayer,
  typePlayerBullet,
  typeEnemy,
  typeEnemyBullet,
}

/// ComponentExクラス
/// 各Componentクラスの種別を列挙型で取得したい。
/// Componentにextensionを追加しようとしたが、fieldは持てないようなので断念
/// 各Componentクラスで本抽象クラスをimplementを必須とし、メソッドで種別を取得する形式
/// とする。
abstract class ComponentEx {
  GameComponentType getType();
}
