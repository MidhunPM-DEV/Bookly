import 'package:flutter/foundation.dart';

class FavoritesStore extends ChangeNotifier {
  FavoritesStore._();

  static final instance = FavoritesStore._();

  final Set<String> _ids = {};

  int get count => _ids.length;

  bool contains(String id) => _ids.contains(id);

  void toggle(String id) {
    if (!_ids.add(id)) {
      _ids.remove(id);
    }
    notifyListeners();
  }

  void remove(String id) {
    if (_ids.remove(id)) notifyListeners();
  }
}
