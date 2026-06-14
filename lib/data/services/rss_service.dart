import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

import '../../core/constants/app_strings.dart';
import '../../core/utils/html_parser.dart';
import '../models/article.dart';

class RssService {
  RssService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<List<Article>> fetchLatest({int limit = 20}) async {
    final uri = Uri.parse('${AppStrings.wordpressBaseUrl}/feed/');
    final response = await _client
        .get(uri)
        .timeout(const Duration(seconds: 15));

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw StateError('RSS request failed.');
    }

    final document = XmlDocument.parse(response.body);
    final items = document.findAllElements('item').take(limit).toList();

    return items
        .asMap()
        .entries
        .map((entry) {
          final item = entry.value;
          final title = _childText(item, 'title');
          final link = _childText(item, 'link');
          final content = _childText(item, 'encoded');
          final excerpt = HtmlParser.cleanText(
            content,
          ).split('. ').take(2).join('. ');
          final author = _childText(item, 'creator');
          final date = DateTime.tryParse(_childText(item, 'pubDate'));

          return Article.fromRss(
            id: entry.key + 1,
            title: title,
            excerpt: excerpt,
            content: content,
            link: link,
            authorName: author,
            publishedAt: date,
          );
        })
        .toList(growable: false);
  }

  String _childText(XmlElement item, String name) {
    for (final child in item.childElements) {
      if (child.name.local == name || child.name.qualified == name) {
        return child.innerText.trim();
      }
    }
    return '';
  }
}
