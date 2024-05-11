import 'dart:convert';

/// CSVユーティリティ・クラス
class CsvUtil {
  /// CSVをパースする
  /// source ... パース対象文字列
  /// separator ... １行内の区切り文字
  static Future<List<List<String>>> parse(String source,
      {String separator = ','}) async {
    List<List<String>> result = [];

    LineSplitter lineSplitter = const LineSplitter();
    List<String> lines = lineSplitter.convert(source);
    lines.forEach((line) {
      List<String> column = line.split(separator);
      result.add(column);
    });

    return result;
  }
}
