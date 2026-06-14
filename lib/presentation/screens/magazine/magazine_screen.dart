import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/utils/url_launcher_helper.dart';
import '../../../data/models/magazine_edition.dart';
import '../../../state/magazine_provider.dart';
import '../../widgets/app_bar_widget.dart';
import '../../widgets/article_image.dart';
import '../../widgets/loading_shimmer.dart';

class MagazineScreen extends StatefulWidget {
  const MagazineScreen({super.key});

  @override
  State<MagazineScreen> createState() => _MagazineScreenState();
}

class _MagazineScreenState extends State<MagazineScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MagazineProvider>().loadEditions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const VilasAppBar(title: AppStrings.magazineTitle),
      body: Consumer<MagazineProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.editions.isEmpty) {
            return const _MagazineLoading();
          }

          if (provider.editions.isEmpty) {
            return RefreshIndicator(
              onRefresh: provider.refresh,
              child: const CustomScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: Text(AppStrings.noEditions)),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: provider.refresh,
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.62,
              ),
              itemCount: provider.editions.length,
              itemBuilder: (context, index) {
                return _MagazineCard(edition: provider.editions[index]);
              },
            ),
          );
        },
      ),
    );
  }
}

class _MagazineCard extends StatelessWidget {
  const _MagazineCard({required this.edition});

  final MagazineEdition edition;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => UrlLauncherHelper.open(edition.link),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ArticleImage(
                imageUrl: edition.coverUrl,
                height: double.infinity,
                borderRadius: 0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    edition.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    edition.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
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

class _MagazineLoading extends StatelessWidget {
  const _MagazineLoading();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.all(16),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 0.62,
      children: const [
        LoadingShimmer.box(height: 280),
        LoadingShimmer.box(height: 280),
        LoadingShimmer.box(height: 280),
        LoadingShimmer.box(height: 280),
      ],
    );
  }
}
