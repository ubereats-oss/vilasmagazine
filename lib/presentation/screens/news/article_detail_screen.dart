import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/url_launcher_helper.dart';
import '../../../data/models/article.dart';
import '../../../state/news_provider.dart';
import '../../widgets/article_image.dart';
import '../../widgets/category_badge.dart';
import '../../widgets/loading_shimmer.dart';

class ArticleDetailScreen extends StatefulWidget {
  const ArticleDetailScreen({
    super.key,
    required this.articleId,
    this.initialArticle,
  });

  final int articleId;
  final Article? initialArticle;

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  late final Future<Article> _articleFuture;

  @override
  void initState() {
    super.initState();
    _articleFuture = widget.initialArticle != null
        ? Future.value(widget.initialArticle)
        : context.read<NewsProvider>().fetchArticleById(widget.articleId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Article>(
      future: _articleFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: LoadingShimmer.card()));
        }

        final article = snapshot.data!;
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: AppColors.transparent,
            foregroundColor: AppColors.surface,
            elevation: 0,
            actions: [
              IconButton(
                tooltip: AppStrings.share,
                onPressed: () => _share(article),
                icon: const Icon(Icons.ios_share_outlined),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.surface,
            onPressed: () => _share(article),
            child: const Icon(Icons.share_outlined),
          ),
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Stack(
                  children: [
                    ArticleImage(
                      imageUrl: article.imageUrl,
                      height: 330,
                      borderRadius: 0,
                    ),
                    const Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.darkOverlay,
                              AppColors.transparent,
                              AppColors.darkOverlay,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 96),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 10,
                        runSpacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          CategoryBadge(label: article.categoryName),
                          Text(
                            DateFormatter.compact(article.publishedAt),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        article.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 24,
                          height: 1.18,
                        ),
                      ),
                      const SizedBox(height: 14),
                      const SizedBox(
                        width: 40,
                        height: 2,
                        child: ColoredBox(color: AppColors.primary),
                      ),
                      if (article.authorName.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(
                          article.authorName,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: AppColors.textSecondary,
                                fontStyle: FontStyle.italic,
                              ),
                        ),
                      ],
                      const SizedBox(height: 20),
                      Html(
                        data: article.content,
                        style: {
                          'body': Style(
                            margin: Margins.zero,
                            padding: HtmlPaddings.zero,
                            fontSize: FontSize(17),
                            lineHeight: const LineHeight(1.55),
                            color: AppColors.textPrimary,
                          ),
                          'p': Style(margin: Margins.only(bottom: 14)),
                          'a': Style(color: AppColors.primary),
                        },
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => UrlLauncherHelper.open(article.link),
                          icon: const Icon(Icons.open_in_browser_outlined),
                          label: const Text(AppStrings.readOnSite),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _share(Article article) async {
    await SharePlus.instance.share(
      ShareParams(
        title: article.title,
        subject: article.title,
        text: '${article.title}\n${article.link}',
      ),
    );
  }
}
