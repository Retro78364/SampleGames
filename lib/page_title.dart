import 'package:flutter/material.dart';
import 'page_game.dart';
import 'audio.dart';

/// タイトルページ・ウィジェット
class TitlePage extends StatelessWidget {
  /// コンストラクタ
  TitlePage() : super() {
    AudioManager.stopBgm();
    AudioManager.startBgm('audio/bgm_title.mp3');
  }

  /// UI再構築
  @override
  Widget build(BuildContext context) {
    final _deviceWidth = MediaQuery.of(context).size.width;
    final _deviceHeight = MediaQuery.of(context).size.height;
    bool isVertLong = _deviceHeight > _deviceWidth;
    final _shortLength = isVertLong ? _deviceWidth : _deviceHeight;

    return Scaffold(
      body: Container(
        color: Color.fromARGB(255, 28, 60, 86),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          isVertLong
              ? SizedBox.square(dimension: _deviceHeight / 30)
              : SizedBox.shrink(),
          Container(
            padding: EdgeInsets.fromLTRB(
                0, 0, _deviceHeight / 20, _deviceHeight / 20),
            width: MediaQuery.of(context).size.width,
            height: _shortLength * 0.6,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.contain,
                image: AssetImage("assets/images/title_s.png"),
              ),
            ),
          ),
          isVertLong
              ? SizedBox.square(dimension: _deviceHeight / 30)
              : SizedBox.shrink(),
          TextButton(
              child: Text("STAGE 1"),
              style: TextButton.styleFrom(
                foregroundColor: Colors.orange,
              ),
              onPressed: () {
                AudioManager.stopBgm();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PageGame(
                              stageNumber: 1,
                            )));
              }),
          isVertLong
              ? SizedBox.square(dimension: _deviceHeight / 30)
              : SizedBox.shrink(),
          TextButton(
              child: Text("STAGE 2"),
              style: TextButton.styleFrom(
                foregroundColor: Colors.orange,
              ),
              onPressed: () {
                AudioManager.stopBgm();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PageGame(
                              stageNumber: 2,
                            )));
              }),
          isVertLong
              ? SizedBox.square(dimension: _deviceHeight / 30)
              : SizedBox.shrink(),
          TextButton(
              child: Text("STAGE 3"),
              style: TextButton.styleFrom(
                foregroundColor: Colors.orange,
              ),
              onPressed: () {
                AudioManager.stopBgm();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PageGame(
                              stageNumber: 3,
                            )));
              }),
          isVertLong
              ? SizedBox.square(dimension: _deviceHeight / 30)
              : SizedBox.shrink(),
          TextButton(
              child: Text("STAGE 1 (EASY)"),
              style: TextButton.styleFrom(
                foregroundColor: Colors.orange,
              ),
              onPressed: () {
                AudioManager.stopBgm();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PageGame(
                              stageNumber: 1,
                              gameLevel: 0,
                            )));
              }),
          isVertLong
              ? SizedBox.square(dimension: _deviceHeight / 30)
              : SizedBox.shrink(),
          TextButton(
              child: Text("STAGE 2 (EASY)"),
              style: TextButton.styleFrom(
                foregroundColor: Colors.orange,
              ),
              onPressed: () {
                AudioManager.stopBgm();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PageGame(
                              stageNumber: 2,
                              gameLevel: 0,
                            )));
              }),
          isVertLong
              ? SizedBox.square(dimension: _deviceHeight / 30)
              : SizedBox.shrink(),
          TextButton(
              child: Text("STAGE 3 (EASY)"),
              style: TextButton.styleFrom(
                foregroundColor: Colors.orange,
              ),
              onPressed: () {
                AudioManager.stopBgm();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PageGame(
                              stageNumber: 3,
                              gameLevel: 0,
                            )));
              }),
        ]),
      ),
    );
  }
}
