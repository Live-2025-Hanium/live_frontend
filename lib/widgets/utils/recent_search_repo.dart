import 'package:shared_preferences/shared_preferences.dart';

/// Recent search repository.
///
/// This class stores recent search terms in `SharedPreferences` under a key
/// namespaced by `scope`. By default the scope is `default` which preserves
/// existing behavior. Use the provided helpers `RecentSearchRepo.map` and
/// `RecentSearchRepo.forum` to separate map and forum (게시판) recent searches.
class RecentSearchRepo {
  static const String _keyBase = 'recent_searches';
  static Future<SharedPreferences> get _prefs =>
      SharedPreferences.getInstance();

  // Compose the actual storage key using a scope name.
  static String _keyFor(String scope) => '$_keyBase:$scope';

  /// Fetch all recent searches for [scope]. Default scope is `'default'` to
  /// preserve legacy behavior.
  static Future<List<String>> fetchAll({String scope = 'default'}) async {
    final p = await _prefs;
    final key = _keyFor(scope);
    final list = p.getStringList(key) ?? const <String>[];
    final sanitized = <String>{};
    for (final e in list) {
      final t = e.trim();
      if (t.isNotEmpty) sanitized.add(t);
    }
    return sanitized.toList(growable: false);
  }

  /// Insert or move [term] to the front for [scope]. Keeps up to [max] items.
  static Future<void> upsert(
    String term, {
    int max = 10,
    String scope = 'default',
  }) async {
    final p = await _prefs;
    final key = _keyFor(scope);
    final list = p.getStringList(key) ?? <String>[];
    final t = term.trim();
    if (t.isEmpty) return;
    final next = [t, ...list.where((e) => e != t)];
    if (next.length > max) next.removeRange(max, next.length);
    await p.setStringList(key, next);
  }

  /// Remove [term] from [scope].
  static Future<void> remove(String term, {String scope = 'default'}) async {
    final p = await _prefs;
    final key = _keyFor(scope);
    final list = p.getStringList(key) ?? <String>[];
    list.removeWhere((e) => e == term);
    await p.setStringList(key, list);
  }

  /// Clear all entries under [scope].
  static Future<void> clear({String scope = 'default'}) async {
    final p = await _prefs;
    final key = _keyFor(scope);
    await p.remove(key);
  }

  // Convenience scoped accessors to avoid passing the scope string everywhere.
  static RecentSearchScope get map => const RecentSearchScope('map');
  static RecentSearchScope get forum => const RecentSearchScope('forum');
}

/// Lightweight wrapper for scoped operations.
class RecentSearchScope {
  final String scope;
  const RecentSearchScope(this.scope);

  Future<List<String>> fetchAll() => RecentSearchRepo.fetchAll(scope: scope);
  Future<void> upsert(String term, {int max = 10}) =>
      RecentSearchRepo.upsert(term, max: max, scope: scope);
  Future<void> remove(String term) =>
      RecentSearchRepo.remove(term, scope: scope);
  Future<void> clear() => RecentSearchRepo.clear(scope: scope);
}
