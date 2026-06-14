import 'package:dio/dio.dart';

import '../../core/constants/app_strings.dart';

class WordPressApiService {
  WordPressApiService({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: AppStrings.wordpressBaseUrl,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 15),
              headers: const {'Accept': 'application/json'},
            ),
          );

  final Dio _dio;

  Future<List<Map<String, dynamic>>> getPosts({
    int page = 1,
    int perPage = 20,
    int? categoryId,
    String? search,
  }) async {
    final queryParameters = <String, dynamic>{
      'page': page,
      'per_page': perPage,
      '_embed': true,
    };

    if (categoryId != null) {
      queryParameters['categories'] = categoryId;
    }

    final trimmedSearch = search?.trim();
    if (trimmedSearch != null && trimmedSearch.isNotEmpty) {
      queryParameters['search'] = trimmedSearch;
    }

    final response = await _get(
      '/wp-json/wp/v2/posts',
      queryParameters: queryParameters,
    );

    return _list(response.data);
  }

  Future<Map<String, dynamic>> getPost(int id) async {
    final response = await _get(
      '/wp-json/wp/v2/posts/$id',
      queryParameters: const {'_embed': true},
    );

    return _map(response.data);
  }

  Future<List<Map<String, dynamic>>> getCategories() async {
    final response = await _get(
      '/wp-json/wp/v2/categories',
      queryParameters: const {'per_page': 50, 'hide_empty': true},
    );

    return _list(response.data);
  }

  Future<Response<dynamic>> _get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    DioException? lastException;

    for (var attempt = 0; attempt < 3; attempt++) {
      try {
        return await _dio.get(path, queryParameters: queryParameters);
      } on DioException catch (exception) {
        lastException = exception;
        if (attempt == 2 || !_shouldRetry(exception)) {
          rethrow;
        }

        final delay = Duration(milliseconds: 450 * (1 << attempt));
        await Future<void>.delayed(delay);
      }
    }

    throw lastException ?? StateError('WordPress request failed.');
  }

  bool _shouldRetry(DioException exception) {
    final statusCode = exception.response?.statusCode;
    return exception.type == DioExceptionType.connectionTimeout ||
        exception.type == DioExceptionType.receiveTimeout ||
        exception.type == DioExceptionType.connectionError ||
        statusCode == null ||
        statusCode >= 500;
  }

  List<Map<String, dynamic>> _list(dynamic data) {
    if (data is List) {
      return data.map(_map).toList(growable: false);
    }
    throw StateError('WordPress response is not a list.');
  }

  Map<String, dynamic> _map(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data;
    }
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    throw StateError('WordPress response is not an object.');
  }
}
