import 'package:flutter/foundation.dart';

import '../core/constants/app_strings.dart';
import '../data/models/magazine_edition.dart';
import '../data/repositories/magazine_repository.dart';

class MagazineProvider extends ChangeNotifier {
  MagazineProvider(this._repository);

  final MagazineRepository _repository;

  List<MagazineEdition> _editions = [];
  bool _isLoading = false;
  String? _error;

  List<MagazineEdition> get editions => _editions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadEditions() async {
    if (_isLoading) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      _editions = await _repository.fetchEditions();
      _error = null;
    } catch (_) {
      _error = AppStrings.noConnection;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() => loadEditions();
}
