import 'package:flutter/foundation.dart' hide Category;

import '../core/constants/app_strings.dart';
import '../data/models/article.dart';
import '../data/models/category.dart';
import '../data/repositories/news_repository.dart';

class NewsProvider extends ChangeNotifier {
  NewsProvider(this._repository);

  final NewsRepository _repository;

  List<Article> _articles = [];
  List<Article> _featured = [];
  List<Category> _categories = Category.fallbacks;
  Category? _selectedCategory;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  String? _error;
  int _currentPage = 1;
  Future<void>? _initialLoad;

  List<Article> get articles => _articles;
  List<Article> get featured => _featured;
  List<Category> get categories => _categories;
  Category? get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;
  String? get error => _error;

  Future<void> initialize() {
    return _initialLoad ??= _loadInitial();
  }

  Future<void> _loadInitial() async {
    _setLoading(true);
    try {
      await loadCategories();
      _featured = await _repository.fetchFeatured();
      await _loadFirstPage();
      _error = null;
    } catch (_) {
      _error = AppStrings.noConnection;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadFeatured() async {
    _featured = await _repository.fetchFeatured();
    notifyListeners();
  }

  Future<void> loadArticles({int? categoryId}) async {
    _selectedCategory = _categoryFromId(categoryId);
    await _loadFirstPage();
  }

  Future<void> loadMore() async {
    if (_isLoading || _isLoadingMore || !_hasMore) {
      return;
    }

    _isLoadingMore = true;
    notifyListeners();

    try {
      final nextPage = _currentPage + 1;
      final nextArticles = await _repository.fetchArticles(
        page: nextPage,
        categoryId: _selectedCategory?.id,
      );
      _currentPage = nextPage;
      _articles = [..._articles, ...nextArticles];
      _hasMore = nextArticles.isNotEmpty;
      _error = null;
    } catch (_) {
      _error = AppStrings.noConnection;
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> loadCategories() async {
    _categories = await _repository.fetchCategories();
    notifyListeners();
  }

  Future<void> selectCategory(Category? category) async {
    _selectedCategory = category?.isAll == true ? null : category;
    await _loadFirstPage();
  }

  Future<void> selectCategorySlug(String? slug) async {
    if (slug == null || slug.isEmpty) {
      await selectCategory(null);
      return;
    }

    Category? category;
    for (final item in _categories) {
      if (item.slug == slug) {
        category = item;
        break;
      }
    }
    await selectCategory(category);
  }

  Future<void> refresh() async {
    _initialLoad = null;
    await _loadInitial();
  }

  Future<Article> fetchArticleById(int id) {
    return _repository.fetchArticle(id);
  }

  Future<List<Article>> search(String term) {
    if (term.trim().isEmpty) {
      return Future.value(const []);
    }
    return _repository.fetchArticles(search: term, perPage: 20);
  }

  Future<void> _loadFirstPage() async {
    _currentPage = 1;
    _hasMore = true;
    final categoryId = _selectedCategory?.id;
    _articles = await _repository.fetchArticles(categoryId: categoryId);
    _hasMore = _articles.isNotEmpty;
    _error = null;
    notifyListeners();
  }

  Category? _categoryFromId(int? id) {
    if (id == null) {
      return null;
    }
    for (final category in _categories) {
      if (category.id == id) {
        return category;
      }
    }
    return null;
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
