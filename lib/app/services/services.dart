import 'dart:async';

import 'package:cbt_inbal/app/providers/articles_provider.dart';
import 'package:cbt_inbal/app/services/storage_service.dart';
import 'package:cbt_inbal/log_utils.dart';
import 'package:get_it/get_it.dart';

class ServiceProvider {
  static final _getIt = GetIt.instance;

  static Future<void> init() async {
    try {
      // storage
      _getIt.registerSingletonAsync(
        () async {
          final storageService = StorageService();
          await storageService.init();
          return storageService;
        },
      );

      await _getIt.allReady();

      // doc provider
      _getIt.registerSingleton(
        DocsController(),
        dispose: (_) => docController.dispose(),
      );
    } catch (e, st) {
      logError('services e: $e, st: $st');
    }
  }
}

StorageService get storageService {
  return ServiceProvider._getIt.get<StorageService>();
}

DocsController get docController {
  return ServiceProvider._getIt.get<DocsController>();
}
