import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../data/models/article.dart';
import '../../../state/news_provider.dart';
import '../../widgets/app_bar_widget.dart';
import '../../widgets/loading_shimmer.dart';
import 'widgets/category_chip_bar.dart';
import 'widgets/featured_banner.dart';
import 'widgets/news_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewsProvider>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const VilasAppBar(),
      body: Consumer<NewsProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.articles.isEmpty) {
            return const _HomeLoading();
          }

          return RefreshIndicator(
            onRefresh: provider.refresh,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: FeaturedBanner(
                    articles: provider.featured,
                    isLoading: provider.isLoading,
                    onArticleTap: _openArticle,
                  ),
                ),
                SliverToBoxAdapter(
                  child: CategoryChipBar(
                    categories: provider.categories,
                    selectedCategory: provider.selectedCategory,
                    onSelected: provider.selectCategory,
                  ),
                ),
                if (provider.error != null)
                  SliverToBoxAdapter(
                    child: _ErrorMessage(message: provider.error!),
                  ),
                if (provider.articles.isEmpty && provider.error == null)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: Text(AppStrings.noArticles)),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    sliver: SliverList.separated(
                      itemCount: provider.articles.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final article = provider.articles[index];
                        return NewsCard(
                          article: article,
                          onTap: () => _openArticle(article),
                        );
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _openArticle(Article article) {
    context.push('/artigo/${article.id}', extra: article);
  }
}

class _HomeLoading extends StatelessWidget {
  const _HomeLoading();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        LoadingShimmer.box(
          height: 260,
          margin: EdgeInsets.fromLTRB(16, 16, 16, 8),
        ),
        LoadingShimmer.card(),
        LoadingShimmer.card(),
      ],
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
    );
  }
}
