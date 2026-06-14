import 'package:flutter/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'data/repositories/magazine_repository.dart';
import 'data/repositories/news_repository.dart';
import 'data/services/rss_service.dart';
import 'data/services/wordpress_api_service.dart';
import 'firebase_options.dart';
import 'firebase_web_plugin_registrar.dart';
import 'state/magazine_provider.dart';
import 'state/news_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  registerFirebaseWebPlugin();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final apiService = WordPressApiService();
  final newsRepository = NewsRepository(apiService, RssService());
  final magazineRepository = MagazineRepository(apiService, newsRepository);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NewsProvider(newsRepository)),
        ChangeNotifierProvider(
          create: (_) => MagazineProvider(magazineRepository),
        ),
      ],
      child: const VilasMagazineApp(),
    ),
  );
}
