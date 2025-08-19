import 'package:shared_preferences/shared_preferences.dart';

class RecentSearchRepo {
  static const String _key = 'recent_searches';
  static Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  static Future<List<String>> fetchAll() async {
    final p = await _prefs;
    final list = p.getStringList(_key) ?? const <String>[];
    final sanitized = <String>{};
    for (final e in list) {
      final t = e.trim();
      if (t.isNotEmpty) sanitized.add(t);
    }
    return sanitized.toList(growable: false);
  }

  static Future<void> upsert(String term, {int max = 10}) async {
    final p = await _prefs;
    final list = p.getStringList(_key) ?? <String>[];
    final t = term.trim();
    if (t.isEmpty) return;
    final next = [t, ...list.where((e) => e != t)];
    if (next.length > max) next.removeRange(max, next.length);
    await p.setStringList(_key, next);
  }

  static Future<void> remove(String term) async {
    final p = await _prefs;
    final list = p.getStringList(_key) ?? <String>[];
    list.removeWhere((e) => e == term);
    await p.setStringList(_key, list);
  }

  static Future<void> clear() async {
    final p = await _prefs;
    await p.remove(_key);
  }
}
