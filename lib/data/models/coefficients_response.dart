import 'package:currency_convertor/data/models/rate.dart';

class CoefficientResponse {
  final String base;
  final DateTime dt;
  final List<Rate> rates;

  CoefficientResponse({required this.base, required this.dt, required this.rates});

  CoefficientResponse fromAPI(Map<String, dynamic> json) {
    List<Rate> rates = [];
    json['rates'].keys.forEach((key) {
      final rate = Rate(currency: key, rate: json['rates'][key]);
      rates.add(rate);
    });
    return CoefficientResponse(base: json['base'], dt: DateTime.tryParse(json['date'])!, rates: rates);
  }
}

