import '../../core/constants/app_strings.dart';
import '../../core/utils/html_parser.dart';

class Category {
  const Category({
    required this.id,
    required this.name,
    required this.slug,
    this.count = 0,
    this.isAll = false,
  });

  final int? id;
  final String name;
  final String slug;
  final int count;
  final bool isAll;

  bool get hasId => id != null && id! > 0;

  factory Category.fromWordPress(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int?,
      name: HtmlParser.cleanText(json['name'] as String? ?? ''),
      slug: json['slug'] as String? ?? '',
      count: json['count'] as int? ?? 0,
    );
  }

  static const Category all = Category(
    id: null,
    name: AppStrings.categoryAll,
    slug: 'todas',
    isAll: true,
  );

  static const List<Category> fallbacks = [
    all,
    Category(id: 189, name: AppStrings.categoryCity, slug: 'cidade'),
    Category(id: 199, name: AppStrings.categoryCulture, slug: 'cultura'),
    Category(id: 313, name: AppStrings.categoryEducation, slug: 'educacao'),
    Category(id: 292, name: AppStrings.categorySports, slug: 'esportes'),
    Category(
      id: 203,
      name: AppStrings.categoryHealth,
      slug: 'saude-e-bem-estar',
    ),
    Category(
      id: 204,
      name: AppStrings.categoryEnvironment,
      slug: 'meio-ambiente-e-sustentabilidade',
    ),
    Category(
      id: 214,
      name: AppStrings.categoryBusiness,
      slug: 'negocios-e-cia',
    ),
    Category(id: 198, name: AppStrings.categoryBehavior, slug: 'comportamento'),
    Category(id: 209, name: AppStrings.categoryFashion, slug: 'moda-e-beleza'),
    Category(id: 304, name: AppStrings.categoryHome, slug: 'casa-coisas-e-tal'),
    Category(id: 184, name: AppStrings.categoryPet, slug: 'pet-e-cia'),
    Category(id: 281, name: AppStrings.categoryReligion, slug: 'religiao'),
    Category(id: 195, name: AppStrings.categoryTourism, slug: 'turismo'),
    Category(id: 187, name: AppStrings.categoryOpinion, slug: 'nossa-opiniao'),
    Category(
      id: 192,
      name: AppStrings.categoryReader,
      slug: 'tribuna-do-leitor',
    ),
    Category(id: 261, name: AppStrings.categoryRights, slug: 'seus-direitos'),
    Category(id: 190, name: AppStrings.categoryPeople, slug: 'nossa-gente'),
    Category(id: 197, name: AppStrings.categorySpecials, slug: 'especiais'),
  ];
}
