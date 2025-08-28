import 'package:shared_preferences/shared_preferences.dart';

/// ⚠️ TEMP: PR 머지 전까지 지도 탭에서만 쓰는 임시 레포
class MapRecentSearchTempRepo {
  static const String _key = 'recent_map_searches'; // 지도 전용 키
  static Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  static Future<List<String>> fetchAll() async {
    final p = await _prefs;
    final list = p.getStringList(_key) ?? const <String>[];
    // sanitize + 중복 제거
    final set = <String>{};
    for (final e in list) {
      final t = e.trim();
      if (t.isNotEmpty) set.add(t);
    }
    return set.toList(growable: false);
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
