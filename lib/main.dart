import 'package:flutter/material.dart';
import 'page_title.dart';
import 'audio.dart';

/// アプリのメイン関数
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AudioManager.initWork();
  runApp(_MyApp());
}

/// アプリの土台となるウィジェット
class _MyApp extends StatelessWidget {
  /// UI再構築
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'STG App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF2196f3),
        canvasColor: const Color(0xFFfafafa),
      ),
      home: TitlePage(),
    );
  }
}
