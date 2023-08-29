import 'package:currency_convertor/data/api/api.dart';

part 'interfacies.dart';

class CurrencyRepositoryImpl extends CurrencyRepository {
  CurrencyRepositoryImpl({required API api}) : _api = api;

  final API _api;

  @override
  Future test() async {
    final res = await _api.fetchData('/convert?access_key=a9fd3f3eaa6e2f0551c9a0e4353c623c&from=GBP&to=JPY&amount=25');
    return res;
  }
}
