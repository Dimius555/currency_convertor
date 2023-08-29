import 'package:currency_convertor/data/models/rate.dart';

class Rates {
  final String base;
  final DateTime dt;
  final List<Rate> rates;

  Rates({required this.base, required this.dt, required this.rates});

  static Rates empty() {
    return Rates(base: '', dt: DateTime.now(), rates: []);
  }

  static Rates fromAPI(Map<String, dynamic> json) {
    List<Rate> rates = [];
    json['rates'].keys.forEach((key) {
      final rate =
          Rate(currency: key, rate: json['rates'][key] is double ? json['rates'][key] : json['rates'][key].toDouble());
      rates.add(rate);
    });
    return Rates(base: json['base'], dt: DateTime.tryParse(json['date'])!, rates: rates);
  }

  static Rates fromJson(Map<String, dynamic> json) {
    return Rates(
      base: json['base'],
      dt: DateTime.tryParse(json['dt'])!,
      rates: (json['rates'] as List).map((e) => Rate.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "base": base,
      "dt": dt.toString(),
      'rates': rates.map((e) => e.toJson()).toList(),
    };
  }
}
