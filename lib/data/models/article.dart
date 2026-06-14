import '../../core/utils/html_parser.dart';

class Article {
  const Article({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.content,
    required this.imageUrl,
    required this.categoryName,
    required this.categorySlug,
    required this.publishedAt,
    required this.link,
    required this.authorName,
  });

  final int id;
  final String title;
  final String excerpt;
  final String content;
  final String imageUrl;
  final String categoryName;
  final String categorySlug;
  final DateTime publishedAt;
  final String link;
  final String authorName;

  bool get isNew {
    return publishedAt.isAfter(
      DateTime.now().subtract(const Duration(hours: 24)),
    );
  }

  factory Article.fromWordPress(Map<String, dynamic> json) {
    final embedded = _map(json['_embedded']);
    final featuredMedia = _firstMap(embedded?['wp:featuredmedia']);
    final author = _firstMap(embedded?['author']);
    final category = _firstCategory(embedded?['wp:term']);

    return Article(
      id: _int(json['id']),
      title: HtmlParser.cleanText(_rendered(json['title'])),
      excerpt: HtmlParser.cleanText(_rendered(json['excerpt'])),
      content: _rendered(json['content']),
      imageUrl: _string(featuredMedia?['source_url']),
      categoryName: HtmlParser.cleanText(_string(category?['name'])),
      categorySlug: _string(category?['slug']),
      publishedAt: DateTime.tryParse(_string(json['date'])) ?? DateTime.now(),
      link: _string(json['link']),
      authorName: HtmlParser.cleanText(_string(author?['name'])),
    );
  }

  factory Article.fromRss({
    required int id,
    required String title,
    required String excerpt,
    required String content,
    required String link,
    required String authorName,
    DateTime? publishedAt,
    String imageUrl = '',
  }) {
    return Article(
      id: id,
      title: HtmlParser.cleanText(title),
      excerpt: HtmlParser.cleanText(excerpt),
      content: content,
      imageUrl: imageUrl,
      categoryName: '',
      categorySlug: '',
      publishedAt: publishedAt ?? DateTime.now(),
      link: link,
      authorName: HtmlParser.cleanText(authorName),
    );
  }

  static String _rendered(dynamic value) {
    final map = _map(value);
    return _string(map?['rendered']);
  }

  static Map<String, dynamic>? _firstCategory(dynamic value) {
    if (value is! List) {
      return null;
    }

    for (final group in value) {
      if (group is! List) {
        continue;
      }

      for (final item in group) {
        final map = _map(item);
        if (map?['taxonomy'] == 'category') {
          return map;
        }
      }
    }

    for (final group in value) {
      if (group is List && group.isNotEmpty) {
        return _map(group.first);
      }
    }

    return null;
  }

  static Map<String, dynamic>? _firstMap(dynamic value) {
    if (value is List && value.isNotEmpty) {
      return _map(value.first);
    }
    return null;
  }

  static Map<String, dynamic>? _map(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return null;
  }

  static String _string(dynamic value) => value?.toString() ?? '';

  static int _int(dynamic value) {
    if (value is int) {
      return value;
    }
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
