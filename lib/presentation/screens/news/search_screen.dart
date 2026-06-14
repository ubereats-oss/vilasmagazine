import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../data/models/article.dart';
import '../../../state/news_provider.dart';
import '../../widgets/app_bar_widget.dart';
import '../home/widgets/news_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  Future<List<Article>>? _future;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const VilasAppBar(title: AppStrings.search, showSearch: false),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
              autofocus: true,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: AppStrings.searchHint,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  tooltip: AppStrings.search,
                  onPressed: _search,
                  icon: const Icon(Icons.arrow_forward),
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
              onSubmitted: (_) => _search(),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Article>>(
              future: _future,
              builder: (context, snapshot) {
                if (_future == null) {
                  return const Center(child: Text(AppStrings.searchEmpty));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final articles = snapshot.data ?? const <Article>[];
                if (articles.isEmpty) {
                  return const Center(child: Text(AppStrings.searchNoResults));
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: articles.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final article = articles[index];
                    return NewsCard(
                      article: article,
                      onTap: () =>
                          context.push('/artigo/${article.id}', extra: article),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _search() {
    final term = _controller.text.trim();
    setState(() {
      _future = context.read<NewsProvider>().search(term);
    });
  }
}
