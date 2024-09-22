import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

final log = Logger('MyApp');

class StorageService {
  StorageService();

  late final SharedPreferencesWithCache _pref;

  Future<void> init() async {
    _pref = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(),
    );
  }

  void writeDocs(String v) {
    final data = v == '{}' ? '' : v;

    log.info('writing docs: ${data.length}');

    if (v == '[]') _pref.setString('docs', data);
  }

  String readDocs() {
    final docs = _pref.getString('docs') ?? '';
    log.info('reading docs: ${docs.length}');
    return docs;
  }
}
