import '../models/article.dart';
import '../models/category.dart';
import '../services/rss_service.dart';
import '../services/wordpress_api_service.dart';

class NewsRepository {
  NewsRepository(this._apiService, this._rssService);

  final WordPressApiService _apiService;
  final RssService _rssService;

  Future<List<Article>> fetchFeatured() {
    return fetchArticles(perPage: 5);
  }

  Future<List<Article>> fetchArticles({
    int page = 1,
    int perPage = 10,
    int? categoryId,
    String? search,
  }) async {
    try {
      final posts = await _apiService.getPosts(
        page: page,
        perPage: perPage,
        categoryId: categoryId,
        search: search,
      );
      return posts.map(Article.fromWordPress).toList(growable: false);
    } catch (_) {
      final canUseRssFallback =
          page == 1 &&
          categoryId == null &&
          (search == null || search.trim().isEmpty);
      if (!canUseRssFallback) {
        rethrow;
      }
      return _rssService.fetchLatest(limit: perPage);
    }
  }

  Future<Article> fetchArticle(int id) async {
    final post = await _apiService.getPost(id);
    return Article.fromWordPress(post);
  }

  Future<List<Category>> fetchCategories() async {
    try {
      final categories = await _apiService.getCategories();
      final parsed = {
        for (final category in categories.map(Category.fromWordPress))
          category.slug: category,
      };

      if (parsed.isEmpty) {
        return Category.fallbacks;
      }

      return [
        Category.all,
        for (final fallback in Category.fallbacks.skip(1))
          parsed[fallback.slug] ?? fallback,
      ];
    } catch (_) {
      return Category.fallbacks;
    }
  }
}
