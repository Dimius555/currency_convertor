import 'dart:developer';
import 'dart:io';

import 'package:currency_convertor/config/constants.dart';
import 'package:currency_convertor/data/api/api.dart';
import 'package:currency_convertor/data/db/data_base.dart';
import 'package:currency_convertor/data/models/currency_model.dart';
import 'package:currency_convertor/data/models/custom_exception.dart';
import 'package:currency_convertor/data/models/rates.dart';
import 'package:dio/dio.dart';

part 'interfacies.dart';

class CurrencyRepositoryImpl extends CurrencyRepository {
  CurrencyRepositoryImpl({
    required API api,
    required DataStore dataStore,
  })  : _api = api,
        _dataStore = dataStore;

  final API _api;
  final DataStore _dataStore;

  // Переменная, которая отвечает за время последнего
  // запроса на получение актуальных кэффициентов валют
  DateTime? _ratesRequestDateTime;

  @override
  Future<List<CurrencyModel>> fetchListOfCurencies() async {
    try {
      final query = Uri(queryParameters: {'access_key': Constants.apiKey}).query;
      final response = await _api.fetchData('symbols?$query');
      final currencies = _parseCurrencies(response.data);
      return currencies;
    } on CustomException {
      rethrow;
    } on DioException catch (e) {
      if (e.error is SocketException) log('🔥 SocketException, no internet');
      try {
        return await _dataStore.fetchCurrencies();
      } catch (e) {
        rethrow;
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<Rates> fetchListOfRates() async {
    // Если данные были ранее запрошены и более 5 минут,
    // то снова делаем запрос
    if (_ratesRequestDateTime == null || DateTime.now().difference(_ratesRequestDateTime!).inMinutes > 5) {
      try {
        final query = Uri(queryParameters: {'access_key': Constants.apiKey}).query;
        final response = await _api.fetchData('latest?$query');
        _ratesRequestDateTime = DateTime.now();
        final rateResponse = Rates.fromAPI(response.data);
        _dataStore.saveRates(rateResponse);
        return rateResponse;
      } on CustomException {
        rethrow;
      } on DioException catch (e) {
        if (e.error is SocketException) log('🔥 SocketException, no internet');
        try {
          return await _dataStore.fetchRates();
        } catch (e) {
          rethrow;
        }
      } catch (e) {
        log(e.toString());
        rethrow;
      }
    } else {
      // Если данные были ранее запрошены и прошло менее 5 минут, то нет смысла снова делать запрос.
      // Данные подтягиваются из БД
      return await _dataStore.fetchRates();
    }
  }

  List<CurrencyModel> _parseCurrencies(Map<String, dynamic> json) {
    List<CurrencyModel> currencies = [];
    json['symbols'].keys.forEach((key) {
      final rate = CurrencyModel(aplpha3: key, name: json['symbols'][key]);
      currencies.add(rate);
    });
    return currencies;
  }
}
