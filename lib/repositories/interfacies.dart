part of 'currency_repository.dart';

abstract interface class CurrencyRepository {
  Future<List<CurrencyModel>> fetchListOfCurencies();
  Future<Rates> fetchListOfRates();
}
