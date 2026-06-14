import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'data/models/article.dart';
import 'presentation/screens/about/about_screen.dart';
import 'presentation/screens/guide/guide_screen.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/magazine/magazine_screen.dart';
import 'presentation/screens/news/article_detail_screen.dart';
import 'presentation/screens/news/news_list_screen.dart';
import 'presentation/screens/news/search_screen.dart';
import 'presentation/widgets/main_scaffold.dart';

class VilasMagazineApp extends StatelessWidget {
  const VilasMagazineApp({super.key});

  static final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScaffold(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/noticias',
                builder: (context, state) => NewsListScreen(
                  categorySlug: state.uri.queryParameters['categoria'],
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/revista',
                builder: (context, state) => const MagazineScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/guia',
                builder: (context, state) => const GuideScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/sobre',
                builder: (context, state) => const AboutScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/busca',
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: '/artigo/:id',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
          final extra = state.extra;
          return ArticleDetailScreen(
            articleId: id,
            initialArticle: extra is Article ? extra : null,
          );
        },
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: _router,
    );
  }
}
