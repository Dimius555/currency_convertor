import 'dart:async';
import 'dart:developer';

import 'package:currency_convertor/data/models/currency_model.dart';
import 'package:currency_convertor/data/models/custom_exception.dart';
import 'package:currency_convertor/data/models/rates.dart';
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

  final String _currencies = '_currencies_';
  final String _rates = '_rates_';
  final String _lastDTUpdate = '_dt_';

  Future<void> saveDTUpdate(DateTime dt) async {
    try {
      await store.record(_lastDTUpdate).put(db, dt.millisecondsSinceEpoch);
      log('🔐 Saved DT of update to DB');
    } catch (e) {
      log('🔥 Failed to save DT of update: $e');
      rethrow;
    }
  }

  Future<DateTime> fetchDTUpdate() async {
    try {
      final int millisecondsSinceEpoch = await store.record(_lastDTUpdate).get(db) as int;
      final dt = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
      return dt;
    } catch (e) {
      log('🔥 Couldn\'t get DT from DB: $e');
      throw CustomException(reason: "Data is null", text: "The data doesn't exist", statusCode: -1);
    }
  }

  Future<void> saveCurrencies(List<CurrencyModel> list) async {
    final List<Map<String, dynamic>> res = [];
    for (var c in list) {
      final Map<String, dynamic> map = c.toJson();
      res.add(map);
    }
    try {
      await store.record(_currencies).put(db, res);
      log('🔐 Saved currencies to DB');
    } catch (e) {
      log('🔥 Failed to save currencies: $e');
      rethrow;
    }
  }

  Future<void> saveRates(Rates rates) async {
    final json = rates.toJson();

    try {
      await store.record(_rates).put(db, json);
      log('🔐 Saved rates to DB');
    } catch (e) {
      log('🔥 Failed to save rates: $e');
      rethrow;
    }
  }

  Future<List<CurrencyModel>> fetchCurrencies() async {
    try {
      final list = await store.record(_currencies).get(db) as dynamic;
      if (list == null) throw CustomException(reason: "List is null", text: "The list doesn't exist", statusCode: -1);
      if (list == []) throw CustomException(reason: "List is empty", text: "There is no data in DB", statusCode: -1);
      final List<CurrencyModel> result = [];
      for (var map in list) {
        final CurrencyModel transponder = CurrencyModel.fromJson(map);
        result.add(transponder);
      }
      return result;
    } catch (e) {
      log('🔥 Couldn\'t get currencies from DB: ${e.toString()}');
      rethrow;
    }
  }

  Future<Rates> fetchRates() async {
    try {
      final Map<String, dynamic> json = await store.record(_rates).get(db) as Map<String, dynamic>;
      final userModel = Rates.fromJson(json);
      return userModel;
    } catch (e) {
      log('🔥 Couldn\'t get rates from DB: $e');
      throw CustomException(reason: "Data is null", text: "The data doesn't exist", statusCode: -1);
    }
  }

  Future<void> removeCurrencies() async {
    try {
      await store.record(_currencies).delete(db);
    } catch (e) {
      log('🔥 Couldn\'t remove currencies from DB: $e');
      rethrow;
    }
  }

  Future<void> removeRates() async {
    try {
      await store.record(_rates).delete(db);
    } catch (e) {
      log('🔥 Couldn\'t remove rates from DB: $e');
      rethrow;
    }
  }

  Future<void> clearDB() async {
    try {
      await removeCurrencies();
      await removeRates();
    } catch (e) {
      log('🔥 Couldn\'t clear DB: $e');
      rethrow;
    }
  }
}
