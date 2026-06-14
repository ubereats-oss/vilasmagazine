import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../data/models/article.dart';
import '../../../widgets/article_image.dart';
import '../../../widgets/category_badge.dart';
import '../../../widgets/loading_shimmer.dart';

class FeaturedBanner extends StatelessWidget {
  const FeaturedBanner({
    super.key,
    required this.articles,
    required this.onArticleTap,
    this.isLoading = false,
  });

  final List<Article> articles;
  final ValueChanged<Article> onArticleTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading && articles.isEmpty) {
      return const LoadingShimmer.box(
        height: 260,
        margin: EdgeInsets.fromLTRB(16, 16, 16, 8),
      );
    }

    if (articles.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: CarouselSlider.builder(
        itemCount: articles.length,
        itemBuilder: (context, index, realIndex) {
          final article = articles[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _FeaturedItem(
              article: article,
              onTap: () => onArticleTap(article),
            ),
          );
        },
        options: CarouselOptions(
          height: 260,
          viewportFraction: 1,
          enableInfiniteScroll: articles.length > 1,
          autoPlay: articles.length > 1,
          autoPlayInterval: const Duration(seconds: 5),
        ),
      ),
    );
  }
}

class _FeaturedItem extends StatelessWidget {
  const _FeaturedItem({required this.article, required this.onTap});

  final Article article;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ArticleImage(
              imageUrl: article.imageUrl,
              height: 260,
              borderRadius: 0,
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.transparent, AppColors.darkOverlay],
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CategoryBadge(label: article.categoryName, compact: true),
                  const SizedBox(height: 10),
                  Text(
                    article.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.surface,
                      fontSize: 22,
                      height: 1.16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppStrings.highlights,
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall?.copyWith(color: AppColors.surface),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
