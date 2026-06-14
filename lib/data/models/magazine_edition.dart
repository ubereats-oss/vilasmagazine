import '../../core/constants/app_strings.dart';
import '../../core/utils/date_formatter.dart';
import 'article.dart';

class MagazineEdition {
  const MagazineEdition({
    required this.id,
    required this.title,
    required this.coverUrl,
    required this.link,
    required this.publishedAt,
  });

  final int id;
  final String title;
  final String coverUrl;
  final String link;
  final DateTime publishedAt;

  String get label =>
      '${AppStrings.edition} ${DateFormatter.monthYear(publishedAt)}';

  factory MagazineEdition.fromArticle(Article article) {
    return MagazineEdition(
      id: article.id,
      title: article.title,
      coverUrl: article.imageUrl,
      link: article.link,
      publishedAt: article.publishedAt,
    );
  }
}
