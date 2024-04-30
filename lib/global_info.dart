/// グローバル情報クラス
class GlobalInfo {
  /// ゲームレベル
  int gameLevel = 1;

  /// キャラクタの基本サイズ
  double baseSize = 0;

  /// キャラクタの半分サイズ
  double halfX = 0;

  /// デバイスの幅
  double deviceWidth = 0;

  /// デバイスの高さ
  double deviceHeight = 0;

  /// デバイスの高さの3/4
  double deviceHeight3of4 = 0;

  /// デバイスの高さの1/4
  double deviceHeight1of4 = 0;

  /// タッチ座標原点X
  /// TODO: 現在は随時更新しているが、タッチ開始以降変化しないようにする予定
  double touchBaseX = 0;

  /// タッチ座標原点Y
  /// TODO: 現在は随時更新しているが、タッチ開始以降変化しないようにする予定
  double touchBaseY = 0;

  /// タッチ座標X
  double touchPosX = 0;

  /// タッチ座標Y
  double touchPosY = 0;

  /// スコア
  int score = 0;
}
