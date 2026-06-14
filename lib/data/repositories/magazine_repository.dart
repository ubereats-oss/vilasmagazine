import '../models/category.dart';
import '../models/article.dart';
import '../models/magazine_edition.dart';
import '../../core/constants/app_strings.dart';
import '../services/wordpress_api_service.dart';
import 'news_repository.dart';

class MagazineRepository {
  MagazineRepository(this._apiService, this._newsRepository);

  final WordPressApiService _apiService;
  final NewsRepository _newsRepository;

  Future<List<MagazineEdition>> fetchEditions() async {
    final categories = await _newsRepository.fetchCategories();
    final category = categories.firstWhere(
      (item) => item.slug == 'edicao-do-mes',
      orElse: () => const Category(
        id: 317,
        name: AppStrings.categoryEditionMonth,
        slug: 'edicao-do-mes',
      ),
    );

    if (!category.hasId) {
      return const [];
    }

    final posts = await _apiService.getPosts(
      categoryId: category.id,
      perPage: 24,
    );

    return posts
        .map(Article.fromWordPress)
        .map(MagazineEdition.fromArticle)
        .toList(growable: false);
  }
}
