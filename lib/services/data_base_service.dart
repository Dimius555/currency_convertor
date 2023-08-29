import 'dart:async';
import 'dart:developer';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

/// Сервис для работы с БД.
class DatabaseService {
  static DatabaseService? _db;
  static DatabaseService get instance => _db ??= DatabaseService();

  /// Версия БД
  /// 1 - исходная версия
  static const int _currentDbVersion = 1;

  Completer<Database>? _dbOpenCompleter;

  // Получение БД
  Future<Database> get database async {
    if (_dbOpenCompleter == null) {
      _dbOpenCompleter = Completer();
      await _openDatabase();
    }
    return _dbOpenCompleter!.future;
  }

  Future _openDatabase() async {
    try {
      final appDocumentDir = await getApplicationDocumentsDirectory();
      final dbPath = path.join(appDocumentDir.path, 'CurrenciesDB.db');
      // Так как БД только 1 версии, то нет необходимости
      // делать проверку на версию и делать миграцию
      final database = await databaseFactoryIo.openDatabase(dbPath, version: _currentDbVersion);

      _dbOpenCompleter!.complete(database);
      log('✅ DB is Activated!');
    } catch (e) {
      log('🔥 DB activation is failed: $e');
    }
  }
}
