import 'package:html/parser.dart' as html_parser;

abstract final class HtmlParser {
  static String cleanText(String value) {
    final document = html_parser.parse(value);
    final parsed = document.body?.text ?? value;

    return parsed
        .replaceAll('\u00A0', ' ')
        .replaceAll('&#8211;', '-')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}
