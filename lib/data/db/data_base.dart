import 'dart:async';

import 'package:currency_convertor/services/data_base_service.dart';
import 'package:sembast/sembast.dart';

class DataStore {
  DataStore({required DatabaseService databaseService}) : _databaseService = databaseService;

  final DatabaseService _databaseService;

  late Database db;

  final store = StoreRef.main();

  Future<DataStore> initDB() async {
    db = await _databaseService.database;
    return this;
  }
}
