import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../state/news_provider.dart';
import '../../widgets/app_bar_widget.dart';
import '../../widgets/loading_shimmer.dart';
import '../home/widgets/category_chip_bar.dart';
import '../home/widgets/news_card.dart';

class NewsListScreen extends StatefulWidget {
  const NewsListScreen({super.key, this.categorySlug});

  final String? categorySlug;

  @override
  State<NewsListScreen> createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<NewsProvider>();
      await provider.loadCategories();
      await provider.selectCategorySlug(widget.categorySlug);
    });
  }

  @override
  void didUpdateWidget(covariant NewsListScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.categorySlug != widget.categorySlug) {
      context.read<NewsProvider>().selectCategorySlug(widget.categorySlug);
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NewsProvider>(
      builder: (context, provider, _) {
        final title = provider.selectedCategory?.name ?? AppStrings.navNews;

        return Scaffold(
          appBar: VilasAppBar(title: title),
          body: RefreshIndicator(
            onRefresh: provider.refresh,
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: CategoryChipBar(
                    categories: provider.categories,
                    selectedCategory: provider.selectedCategory,
                    onSelected: provider.selectCategory,
                  ),
                ),
                if (provider.isLoading && provider.articles.isEmpty)
                  const SliverToBoxAdapter(child: _NewsLoading())
                else if (provider.articles.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: Text(AppStrings.noArticles)),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    sliver: SliverList.separated(
                      itemCount:
                          provider.articles.length +
                          (provider.isLoadingMore ? 1 : 0),
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        if (index >= provider.articles.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(child: Text(AppStrings.loadMore)),
                          );
                        }

                        final article = provider.articles[index];
                        return NewsCard(
                          article: article,
                          onTap: () => context.push(
                            '/artigo/${article.id}',
                            extra: article,
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent * 0.8) {
      context.read<NewsProvider>().loadMore();
    }
  }
}

class _NewsLoading extends StatelessWidget {
  const _NewsLoading();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        LoadingShimmer.card(),
        LoadingShimmer.card(),
        LoadingShimmer.card(),
      ],
    );
  }
}
