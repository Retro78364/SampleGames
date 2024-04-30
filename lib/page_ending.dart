import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// エンディング画面
class PageEnding extends StatefulWidget {
  /// コンストラクタ
  const PageEnding({
    Key? key,
  }) : super(key: key);

  /// ステート生成
  @override
  State createState() => _PageEndingState();
}

/// エンディング画面ステート
class _PageEndingState extends State<PageEnding> {
  /// 動画コントローラ
  late VideoPlayerController _controller;

  /// ステート初期化メソッド
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/movie/movie_ending.mp4')
      ..addListener(() {
        setState(() {});
      })
      ..setLooping(false)
      ..initialize().then((_) => setState(() {}))
      ..play();
  }

  /// 終了メソッド
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// UI再構築
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromARGB(255, 0, 0, 0),
        child: Center(
          child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: Container(
              child: VideoPlayer(_controller),
            ),
          ),
        ),
      ),
//      body: SizedBox.expand(
//        child: FittedBox(
//          fit: BoxFit.cover,
//          child: SizedBox(
//            width: _controller.value.size.width,
//            height: _controller.value.size.height,
//            child: VideoPlayer(_controller),
//          ),
//        ),
//      ),
    );
  }
}
